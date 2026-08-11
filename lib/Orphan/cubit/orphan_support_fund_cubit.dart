import 'package:charity_management/Orphan/cubit/orphan_support_fund_state.dart';
import 'package:charity_management/Orphan/repository/orphan_support_fund_repository.dart';
import 'package:charity_management/Payment/config/stripe_config.dart';
import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class OrphanSupportFundCubit extends Cubit<OrphanSupportFundState> {
  OrphanSupportFundCubit({
    OrphanSupportFundRepository? repository,
    StripeConfig? stripeConfig,
  }) : _repository = repository ?? OrphanSupportFundRepository(),
       _stripeConfig = stripeConfig ?? const StripeConfig(),
       super(const OrphanSupportFundState.initial());

  final OrphanSupportFundRepository _repository;
  final StripeConfig _stripeConfig;

  Future<void> donateWithCard({
    required double amount,
    required AppLocalizations localizations,
  }) async {
    if (state.isAnyLoading) {
      return;
    }

    if (amount <= 0) {
      emit(
        state.copyWith(
          cardStatus: OrphanSupportFundPaymentStatus.failure,
          cardMessage: localizations.paymentAmountMustBePositive,
          cardErrorType: OrphanSupportFundErrorType.validation,
        ),
      );
      return;
    }

    final stripeConfigError = _stripeConfig.validationMessage(localizations);
    if (stripeConfigError != null) {
      debugPrint(
        'Orphan support fund card donation blocked: $stripeConfigError',
      );
      emit(
        state.copyWith(
          cardStatus: OrphanSupportFundPaymentStatus.failure,
          cardMessage: stripeConfigError,
          cardErrorType: OrphanSupportFundErrorType.stripeConfiguration,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        cardStatus: OrphanSupportFundPaymentStatus.loading,
        clearCardMessage: true,
        clearCardError: true,
      ),
    );

    try {
      final paymentIntent = await _repository.createPaymentIntent(
        amount: amount,
      );

      await _repository.presentPaymentSheet(
        clientSecret: paymentIntent.clientSecret,
        merchantDisplayName: localizations.associationName,
      );

      emit(
        state.copyWith(
          cardStatus: OrphanSupportFundPaymentStatus.success,
          paymentIntent: paymentIntent,
          clearCardMessage: true,
          clearCardError: true,
        ),
      );
    } on StripeException catch (error) {
      _logStripeException(error);
      if (error.error.code == FailureCode.Canceled) {
        emit(
          state.copyWith(
            cardStatus: OrphanSupportFundPaymentStatus.canceled,
            cardMessage: localizations.paymentCanceled,
            cardErrorType: OrphanSupportFundErrorType.canceled,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          cardStatus: OrphanSupportFundPaymentStatus.failure,
          cardMessage:
              error.error.localizedMessage ??
              error.error.message ??
              localizations.stripePaymentError,
          cardErrorType: OrphanSupportFundErrorType.stripe,
        ),
      );
    } on DioException catch (error) {
      debugPrint('Orphan support fund card DioException:');
      debugPrint('  type: ${error.type}');
      debugPrint('  statusCode: ${error.response?.statusCode}');
      debugPrint('  response: ${error.response?.data}');
      debugPrint('  uri: ${error.requestOptions.uri}');
      emit(
        state.copyWith(
          cardStatus: OrphanSupportFundPaymentStatus.failure,
          cardMessage: ApiException.getMessage(error, localizations),
          cardErrorType: _dioErrorType(error),
        ),
      );
    } on FormatException {
      emit(
        state.copyWith(
          cardStatus: OrphanSupportFundPaymentStatus.failure,
          cardMessage: localizations.invalidServerResponse,
          cardErrorType: OrphanSupportFundErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Orphan support fund card unexpected error: $error');
      debugPrint('Orphan support fund card stack trace: $stackTrace');
      emit(
        state.copyWith(
          cardStatus: OrphanSupportFundPaymentStatus.failure,
          cardMessage: localizations.unexpectedError,
          cardErrorType: OrphanSupportFundErrorType.unexpected,
        ),
      );
    }
  }

  Future<void> donateFromWallet({
    required double amount,
    required AppLocalizations localizations,
  }) async {
    if (state.isAnyLoading) {
      return;
    }

    if (amount <= 0) {
      emit(
        state.copyWith(
          walletStatus: OrphanSupportFundPaymentStatus.failure,
          walletMessage: localizations.paymentAmountMustBePositive,
          walletErrorType: OrphanSupportFundErrorType.validation,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        walletStatus: OrphanSupportFundPaymentStatus.loading,
        clearWalletMessage: true,
        clearWalletError: true,
      ),
    );

    try {
      final donation = await _repository.donateFromWallet(amount: amount);

      emit(
        state.copyWith(
          walletStatus: OrphanSupportFundPaymentStatus.success,
          walletDonation: donation,
          walletMessage: donation.message,
          clearWalletError: true,
        ),
      );
    } on DioException catch (error) {
      debugPrint('Orphan support fund wallet DioException:');
      debugPrint('  type: ${error.type}');
      debugPrint('  statusCode: ${error.response?.statusCode}');
      debugPrint('  response: ${error.response?.data}');
      debugPrint('  uri: ${error.requestOptions.uri}');
      emit(
        state.copyWith(
          walletStatus: OrphanSupportFundPaymentStatus.failure,
          walletMessage: ApiException.getMessage(error, localizations),
          walletErrorType: _dioErrorType(error),
        ),
      );
    } on FormatException {
      emit(
        state.copyWith(
          walletStatus: OrphanSupportFundPaymentStatus.failure,
          walletMessage: localizations.invalidServerResponse,
          walletErrorType: OrphanSupportFundErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Orphan support fund wallet unexpected error: $error');
      debugPrint('Orphan support fund wallet stack trace: $stackTrace');
      emit(
        state.copyWith(
          walletStatus: OrphanSupportFundPaymentStatus.failure,
          walletMessage: localizations.unexpectedError,
          walletErrorType: OrphanSupportFundErrorType.unexpected,
        ),
      );
    }
  }

  OrphanSupportFundErrorType _dioErrorType(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return OrphanSupportFundErrorType.network;
    }

    if (error.response?.statusCode == 401) {
      return OrphanSupportFundErrorType.unauthorized;
    }

    if (error.response?.statusCode == 403) {
      return OrphanSupportFundErrorType.forbidden;
    }

    return OrphanSupportFundErrorType.backend;
  }

  void _logStripeException(StripeException error) {
    debugPrint('Orphan support fund StripeException:');
    debugPrint('  code: ${error.error.code}');
    debugPrint('  localizedMessage: ${error.error.localizedMessage}');
    debugPrint('  message: ${error.error.message}');
    debugPrint('  stripeErrorCode: ${error.error.stripeErrorCode}');
    debugPrint('  declineCode: ${error.error.declineCode}');
    debugPrint('  type: ${error.error.type}');
  }
}
