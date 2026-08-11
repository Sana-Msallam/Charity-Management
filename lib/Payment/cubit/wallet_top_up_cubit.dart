import 'package:charity_management/Payment/config/stripe_config.dart';
import 'package:charity_management/Payment/cubit/wallet_top_up_state.dart';
import 'package:charity_management/Payment/repository/wallet_top_up_repository.dart';
import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class WalletTopUpCubit extends Cubit<WalletTopUpState> {
  WalletTopUpCubit({
    WalletTopUpRepository? repository,
    StripeConfig? stripeConfig,
  }) : _repository = repository ?? WalletTopUpRepository(),
       _stripeConfig = stripeConfig ?? const StripeConfig(),
       super(const WalletTopUpState.initial());

  final WalletTopUpRepository _repository;
  final StripeConfig _stripeConfig;

  Future<void> fetchBalance({
    required AppLocalizations localizations,
    bool force = false,
  }) async {
    if (state.isBalanceLoading && !force) {
      return;
    }

    emit(
      state.copyWith(
        balanceStatus: WalletBalanceStatus.loading,
        clearBalanceError: true,
      ),
    );

    try {
      final balance = await _repository.fetchBalance();
      emit(
        state.copyWith(
          balanceStatus: WalletBalanceStatus.success,
          balance: balance,
          clearBalanceError: true,
        ),
      );
    } on DioException catch (error) {
      debugPrint('Wallet balance backend/network DioException:');
      debugPrint('  type: ${error.type}');
      debugPrint('  statusCode: ${error.response?.statusCode}');
      debugPrint('  response: ${error.response?.data}');
      debugPrint('  uri: ${error.requestOptions.uri}');
      emit(
        state.copyWith(
          balanceStatus: WalletBalanceStatus.failure,
          balanceErrorMessage: ApiException.getMessage(error, localizations),
          balanceErrorType: _dioErrorType(error),
        ),
      );
    } on FormatException {
      debugPrint('Wallet balance failed: invalid response.');
      emit(
        state.copyWith(
          balanceStatus: WalletBalanceStatus.failure,
          balanceErrorMessage: localizations.invalidServerResponse,
          balanceErrorType: WalletTopUpErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Wallet balance unexpected error: $error');
      debugPrint('Wallet balance stack trace: $stackTrace');
      emit(
        state.copyWith(
          balanceStatus: WalletBalanceStatus.failure,
          balanceErrorMessage: localizations.unexpectedError,
          balanceErrorType: WalletTopUpErrorType.unexpected,
        ),
      );
    }
  }

  Future<void> topUpWallet({
    required double amount,
    required AppLocalizations localizations,
  }) async {
    if (state.isTopUpLoading) {
      return;
    }

    if (amount <= 0) {
      emit(
        state.copyWith(
          topUpStatus: WalletTopUpStatus.failure,
          topUpMessage: localizations.paymentAmountMustBePositive,
          topUpErrorType: WalletTopUpErrorType.validation,
        ),
      );
      return;
    }

    final stripeConfigError = _stripeConfig.validationMessage(localizations);
    if (stripeConfigError != null) {
      debugPrint(
        'Wallet top-up blocked before backend call: $stripeConfigError',
      );
      emit(
        state.copyWith(
          topUpStatus: WalletTopUpStatus.failure,
          topUpMessage: stripeConfigError,
          topUpErrorType: WalletTopUpErrorType.stripeConfiguration,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        topUpStatus: WalletTopUpStatus.loading,
        clearTopUpError: true,
        clearTopUpMessage: true,
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
          topUpStatus: WalletTopUpStatus.success,
          paymentIntent: paymentIntent,
          clearTopUpError: true,
          clearTopUpMessage: true,
        ),
      );
      await fetchBalance(localizations: localizations, force: true);
    } on StripeException catch (error) {
      _logStripeException(error);
      if (error.error.code == FailureCode.Canceled) {
        emit(
          state.copyWith(
            topUpStatus: WalletTopUpStatus.failure,
            topUpMessage: localizations.paymentCanceled,
            topUpErrorType: WalletTopUpErrorType.canceled,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          topUpStatus: WalletTopUpStatus.failure,
          topUpMessage:
              error.error.localizedMessage ??
              error.error.message ??
              localizations.stripePaymentError,
          topUpErrorType: WalletTopUpErrorType.stripe,
        ),
      );
    } on DioException catch (error) {
      debugPrint('Wallet top-up backend/network DioException:');
      debugPrint('  type: ${error.type}');
      debugPrint('  statusCode: ${error.response?.statusCode}');
      debugPrint('  response: ${error.response?.data}');
      debugPrint('  uri: ${error.requestOptions.uri}');
      emit(
        state.copyWith(
          topUpStatus: WalletTopUpStatus.failure,
          topUpMessage: ApiException.getMessage(error, localizations),
          topUpErrorType: _dioErrorType(error),
        ),
      );
    } on FormatException {
      debugPrint('Wallet top-up failed: invalid payment intent response.');
      emit(
        state.copyWith(
          topUpStatus: WalletTopUpStatus.failure,
          topUpMessage: localizations.invalidServerResponse,
          topUpErrorType: WalletTopUpErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Wallet top-up unexpected error: $error');
      debugPrint('Wallet top-up stack trace: $stackTrace');
      emit(
        state.copyWith(
          topUpStatus: WalletTopUpStatus.failure,
          topUpMessage: localizations.unexpectedError,
          topUpErrorType: WalletTopUpErrorType.unexpected,
        ),
      );
    }
  }

  WalletTopUpErrorType _dioErrorType(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return WalletTopUpErrorType.network;
    }

    if (error.response?.statusCode == 401) {
      return WalletTopUpErrorType.unauthorized;
    }

    if (error.response?.statusCode == 403) {
      return WalletTopUpErrorType.forbidden;
    }

    return WalletTopUpErrorType.backend;
  }

  void _logStripeException(StripeException error) {
    debugPrint('Wallet top-up StripeException:');
    debugPrint('  code: ${error.error.code}');
    debugPrint('  localizedMessage: ${error.error.localizedMessage}');
    debugPrint('  message: ${error.error.message}');
    debugPrint('  stripeErrorCode: ${error.error.stripeErrorCode}');
    debugPrint('  declineCode: ${error.error.declineCode}');
    debugPrint('  type: ${error.error.type}');
  }
}
