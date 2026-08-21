import 'package:charity_management/features/Donor/cubit/quick_donation_fund_state.dart';
import 'package:charity_management/features/Donor/repository/quick_donation_fund_repository.dart';
import 'package:charity_management/Payment/config/stripe_config.dart';
import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class QuickDonationFundCubit extends Cubit<QuickDonationFundState> {
  QuickDonationFundCubit({
    QuickDonationFundRepository? repository,
    StripeConfig? stripeConfig,
  }) : _repository = repository ?? QuickDonationFundRepository(),
       _stripeConfig = stripeConfig ?? const StripeConfig(),
       super(const QuickDonationFundState.initial());

  final QuickDonationFundRepository _repository;
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
          cardStatus: QuickDonationFundPaymentStatus.failure,
          cardMessage: localizations.paymentAmountMustBePositive,
          cardErrorType: QuickDonationFundErrorType.validation,
        ),
      );
      return;
    }

    final stripeConfigError = _stripeConfig.validationMessage(localizations);
    if (stripeConfigError != null) {
      emit(
        state.copyWith(
          cardStatus: QuickDonationFundPaymentStatus.failure,
          cardMessage: stripeConfigError,
          cardErrorType: QuickDonationFundErrorType.stripeConfiguration,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        cardStatus: QuickDonationFundPaymentStatus.loading,
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
          cardStatus: QuickDonationFundPaymentStatus.success,
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
            cardStatus: QuickDonationFundPaymentStatus.canceled,
            cardMessage: localizations.paymentCanceled,
            cardErrorType: QuickDonationFundErrorType.canceled,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          cardStatus: QuickDonationFundPaymentStatus.failure,
          cardMessage:
              error.error.localizedMessage ??
              error.error.message ??
              localizations.stripePaymentError,
          cardErrorType: QuickDonationFundErrorType.stripe,
        ),
      );
    } on DioException catch (error) {
      _logDioException('card', error);
      emit(
        state.copyWith(
          cardStatus: QuickDonationFundPaymentStatus.failure,
          cardMessage: ApiException.getMessage(error, localizations),
          cardErrorType: _dioErrorType(error),
        ),
      );
    } on FormatException {
      emit(
        state.copyWith(
          cardStatus: QuickDonationFundPaymentStatus.failure,
          cardMessage: localizations.invalidServerResponse,
          cardErrorType: QuickDonationFundErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Quick donation fund card unexpected error: $error');
      debugPrint('Quick donation fund card stack trace: $stackTrace');
      emit(
        state.copyWith(
          cardStatus: QuickDonationFundPaymentStatus.failure,
          cardMessage: localizations.unexpectedError,
          cardErrorType: QuickDonationFundErrorType.unexpected,
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
          walletStatus: QuickDonationFundPaymentStatus.failure,
          walletMessage: localizations.paymentAmountMustBePositive,
          walletErrorType: QuickDonationFundErrorType.validation,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        walletStatus: QuickDonationFundPaymentStatus.loading,
        clearWalletMessage: true,
        clearWalletError: true,
      ),
    );

    try {
      final donation = await _repository.donateFromWallet(amount: amount);

      emit(
        state.copyWith(
          walletStatus: QuickDonationFundPaymentStatus.success,
          walletDonation: donation,
          walletMessage: donation.message,
          clearWalletError: true,
        ),
      );
    } on DioException catch (error) {
      _logDioException('wallet', error);
      emit(
        state.copyWith(
          walletStatus: QuickDonationFundPaymentStatus.failure,
          walletMessage: ApiException.getMessage(error, localizations),
          walletErrorType: _dioErrorType(error),
        ),
      );
    } on FormatException {
      emit(
        state.copyWith(
          walletStatus: QuickDonationFundPaymentStatus.failure,
          walletMessage: localizations.invalidServerResponse,
          walletErrorType: QuickDonationFundErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Quick donation fund wallet unexpected error: $error');
      debugPrint('Quick donation fund wallet stack trace: $stackTrace');
      emit(
        state.copyWith(
          walletStatus: QuickDonationFundPaymentStatus.failure,
          walletMessage: localizations.unexpectedError,
          walletErrorType: QuickDonationFundErrorType.unexpected,
        ),
      );
    }
  }

  QuickDonationFundErrorType _dioErrorType(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return QuickDonationFundErrorType.network;
    }

    if (error.response?.statusCode == 401) {
      return QuickDonationFundErrorType.unauthorized;
    }

    if (error.response?.statusCode == 403) {
      return QuickDonationFundErrorType.forbidden;
    }

    return QuickDonationFundErrorType.backend;
  }

  void _logDioException(String source, DioException error) {
    debugPrint('Quick donation fund $source DioException:');
    debugPrint('  type: ${error.type}');
    debugPrint('  statusCode: ${error.response?.statusCode}');
    debugPrint('  response: ${error.response?.data}');
    debugPrint('  uri: ${error.requestOptions.uri}');
  }

  void _logStripeException(StripeException error) {
    debugPrint('Quick donation fund StripeException:');
    debugPrint('  code: ${error.error.code}');
    debugPrint('  localizedMessage: ${error.error.localizedMessage}');
    debugPrint('  message: ${error.error.message}');
    debugPrint('  stripeErrorCode: ${error.error.stripeErrorCode}');
    debugPrint('  declineCode: ${error.error.declineCode}');
    debugPrint('  type: ${error.error.type}');
  }
}
