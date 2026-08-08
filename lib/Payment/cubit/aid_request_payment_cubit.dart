import 'package:charity_management/Payment/config/stripe_config.dart';
import 'package:charity_management/Payment/cubit/aid_request_payment_state.dart';
import 'package:charity_management/Payment/repository/aid_request_payment_repository.dart';
import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AidRequestPaymentCubit extends Cubit<AidRequestPaymentState> {
  AidRequestPaymentCubit({
    AidRequestPaymentRepository? repository,
    StripeConfig? stripeConfig,
  }) : _repository = repository ?? AidRequestPaymentRepository(),
       _stripeConfig = stripeConfig ?? const StripeConfig(),
       super(const AidRequestPaymentInitial());

  final AidRequestPaymentRepository _repository;
  final StripeConfig _stripeConfig;

  Future<void> payForAidRequest({
    required int requestId,
    required double amount,
    required double remainingAmount,
    required AppLocalizations localizations,
  }) async {
    if (state is AidRequestPaymentLoading) {
      return;
    }

    if (amount <= 0) {
      emit(
        AidRequestPaymentFailure(
          message: localizations.paymentAmountMustBePositive,
          type: AidRequestPaymentErrorType.validation,
        ),
      );
      return;
    }

    if (amount > remainingAmount) {
      emit(
        AidRequestPaymentFailure(
          message: localizations.paymentAmountExceedsRemaining,
          type: AidRequestPaymentErrorType.validation,
        ),
      );
      return;
    }

    final stripeConfigError = _stripeConfig.validationMessage(localizations);
    if (stripeConfigError != null) {
      debugPrint('Payment blocked before backend call: $stripeConfigError');
      emit(
        AidRequestPaymentFailure(
          message: stripeConfigError,
          type: AidRequestPaymentErrorType.stripeConfiguration,
        ),
      );
      return;
    }

    emit(const AidRequestPaymentLoading());

    try {
      final paymentIntent = await _repository.createPaymentIntent(
        requestId: requestId,
        amount: amount,
      );

      await _repository.presentPaymentSheet(
        clientSecret: paymentIntent.clientSecret,
        merchantDisplayName: localizations.associationName,
      );

      emit(AidRequestPaymentSuccess(paymentIntent));
    } on StripeException catch (error) {
      _logStripeException(error);
      if (error.error.code == FailureCode.Canceled) {
        emit(AidRequestPaymentCanceled(localizations.paymentCanceled));
        return;
      }

      emit(
        AidRequestPaymentFailure(
          message:
              error.error.localizedMessage ??
              error.error.message ??
              localizations.stripePaymentError,
          type: AidRequestPaymentErrorType.stripe,
        ),
      );
    } on DioException catch (error) {
      debugPrint('Payment backend/network DioException:');
      debugPrint('  type: ${error.type}');
      debugPrint('  statusCode: ${error.response?.statusCode}');
      debugPrint('  response: ${error.response?.data}');
      debugPrint('  uri: ${error.requestOptions.uri}');
      emit(
        AidRequestPaymentFailure(
          message: ApiException.getMessage(error, localizations),
          type: _dioErrorType(error),
        ),
      );
    } on FormatException {
      debugPrint('Payment failed: invalid payment intent response format.');
      emit(
        AidRequestPaymentFailure(
          message: localizations.invalidServerResponse,
          type: AidRequestPaymentErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Payment unexpected error: $error');
      debugPrint('Payment stack trace: $stackTrace');
      emit(
        AidRequestPaymentFailure(
          message: localizations.unexpectedError,
          type: AidRequestPaymentErrorType.unexpected,
        ),
      );
    }
  }

  void reset() {
    emit(const AidRequestPaymentInitial());
  }

  AidRequestPaymentErrorType _dioErrorType(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return AidRequestPaymentErrorType.network;
    }

    if (error.response?.statusCode == 401) {
      return AidRequestPaymentErrorType.unauthorized;
    }

    return AidRequestPaymentErrorType.backend;
  }

  void _logStripeException(StripeException error) {
    debugPrint('Payment StripeException:');
    debugPrint('  code: ${error.error.code}');
    debugPrint('  localizedMessage: ${error.error.localizedMessage}');
    debugPrint('  message: ${error.error.message}');
    debugPrint('  stripeErrorCode: ${error.error.stripeErrorCode}');
    debugPrint('  declineCode: ${error.error.declineCode}');
    debugPrint('  type: ${error.error.type}');
  }
}
