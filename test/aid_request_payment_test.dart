import 'package:charity_management/Payment/config/stripe_config.dart';
import 'package:charity_management/Payment/cubit/aid_request_payment_cubit.dart';
import 'package:charity_management/Payment/cubit/aid_request_payment_state.dart';
import 'package:charity_management/Payment/model/aid_request_payment_intent_model.dart';
import 'package:charity_management/Payment/repository/aid_request_payment_repository.dart';
import 'package:charity_management/Payment/service/aid_request_payment_service.dart';
import 'package:charity_management/Payment/service/stripe_payment_sheet_service.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/l10n/generated/app_localizations_en.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final localizations = AppLocalizationsEn();

  group('AidRequestPaymentIntentModel', () {
    test('parses backend response', () {
      final model = AidRequestPaymentIntentModel.fromJson(const {
        'transactionId': 101,
        'clientSecret': 'pi_123_secret_abc',
        'amount': '25.00',
        'currency': 'usd',
      });

      expect(model.transactionId, 101);
      expect(model.clientSecret, 'pi_123_secret_abc');
      expect(model.amount, '25.00');
      expect(model.currency, 'usd');
    });
  });

  group('AidRequestPaymentService', () {
    test('posts amount to the aid request payment-intent endpoint', () async {
      late RequestOptions capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'http://example.test'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedOptions = options;
              handler.resolve(
                Response<dynamic>(
                  requestOptions: options,
                  statusCode: 200,
                  data: const {
                    'transactionId': 101,
                    'clientSecret': 'pi_123_secret_abc',
                    'amount': '25.00',
                    'currency': 'usd',
                  },
                ),
              );
            },
          ),
        );

      final service = AidRequestPaymentService(dio: dio);
      final result = await service.createPaymentIntent(
        requestId: 42,
        amount: 25,
      );

      expect(capturedOptions.method, 'POST');
      expect(capturedOptions.path, ApiConstants.aidRequestPaymentIntent(42));
      expect(capturedOptions.data, {'amount': 25.0});
      expect(result.clientSecret, 'pi_123_secret_abc');
    });
  });

  group('AidRequestPaymentCubit', () {
    test('emits loading and success', () async {
      final service = _FakeAidRequestPaymentService();
      final stripeService = _FakeStripePaymentSheetService();
      final cubit = _buildCubit(service, stripeService);
      final states = <AidRequestPaymentState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.payForAidRequest(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        localizations: localizations,
      );
      await Future<void>.delayed(Duration.zero);

      expect(service.requestId, 42);
      expect(service.amount, 25);
      expect(stripeService.clientSecret, _paymentIntent.clientSecret);
      expect(cubit.state, isA<AidRequestPaymentSuccess>());
      expect(states, [
        isA<AidRequestPaymentLoading>(),
        isA<AidRequestPaymentSuccess>(),
      ]);

      await subscription.cancel();
      await cubit.close();
    });

    test('emits canceled when Stripe reports user cancellation', () async {
      final service = _FakeAidRequestPaymentService();
      final stripeService = _FakeStripePaymentSheetService(
        error: const StripeException(
          error: LocalizedErrorMessage(code: FailureCode.Canceled),
        ),
      );
      final cubit = _buildCubit(service, stripeService);

      await cubit.payForAidRequest(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        localizations: localizations,
      );

      expect(cubit.state, isA<AidRequestPaymentCanceled>());

      await cubit.close();
    });

    test('emits stripe failure for Stripe errors', () async {
      final service = _FakeAidRequestPaymentService();
      final stripeService = _FakeStripePaymentSheetService(
        error: const StripeException(
          error: LocalizedErrorMessage(
            code: FailureCode.Failed,
            localizedMessage: 'Card declined',
          ),
        ),
      );
      final cubit = _buildCubit(service, stripeService);

      await cubit.payForAidRequest(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        localizations: localizations,
      );

      expect(
        cubit.state,
        isA<AidRequestPaymentFailure>()
            .having(
              (state) => state.type,
              'type',
              AidRequestPaymentErrorType.stripe,
            )
            .having((state) => state.message, 'message', 'Card declined'),
      );

      await cubit.close();
    });

    test('emits network failure for Dio connection errors', () async {
      final service = _FakeAidRequestPaymentService(
        error: DioException(
          requestOptions: RequestOptions(path: '/payment'),
          type: DioExceptionType.connectionError,
        ),
      );
      final cubit = _buildCubit(service, _FakeStripePaymentSheetService());

      await cubit.payForAidRequest(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        localizations: localizations,
      );

      expect(
        cubit.state,
        isA<AidRequestPaymentFailure>().having(
          (state) => state.type,
          'type',
          AidRequestPaymentErrorType.network,
        ),
      );

      await cubit.close();
    });

    test('emits backend failure with backend message', () async {
      final requestOptions = RequestOptions(path: '/payment');
      final service = _FakeAidRequestPaymentService(
        error: DioException(
          requestOptions: requestOptions,
          response: Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: 400,
            data: const {'message': 'Amount exceeds remaining amount'},
          ),
        ),
      );
      final cubit = _buildCubit(service, _FakeStripePaymentSheetService());

      await cubit.payForAidRequest(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        localizations: localizations,
      );

      expect(
        cubit.state,
        isA<AidRequestPaymentFailure>()
            .having(
              (state) => state.type,
              'type',
              AidRequestPaymentErrorType.backend,
            )
            .having(
              (state) => state.message,
              'message',
              'Amount exceeds remaining amount',
            ),
      );

      await cubit.close();
    });

    test('validates amount before creating a payment intent', () async {
      final service = _FakeAidRequestPaymentService();
      final cubit = _buildCubit(service, _FakeStripePaymentSheetService());

      await cubit.payForAidRequest(
        requestId: 42,
        amount: 125,
        remainingAmount: 100,
        localizations: localizations,
      );

      expect(service.callCount, 0);
      expect(
        cubit.state,
        isA<AidRequestPaymentFailure>().having(
          (state) => state.type,
          'type',
          AidRequestPaymentErrorType.validation,
        ),
      );

      await cubit.close();
    });

    test('does not create payment intent when Stripe key is missing', () async {
      final service = _FakeAidRequestPaymentService();
      final cubit = _buildCubit(
        service,
        _FakeStripePaymentSheetService(),
        stripeConfig: const StripeConfig(publishableKey: ''),
      );

      await cubit.payForAidRequest(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        localizations: localizations,
      );

      expect(service.callCount, 0);
      expect(
        cubit.state,
        isA<AidRequestPaymentFailure>()
            .having(
              (state) => state.type,
              'type',
              AidRequestPaymentErrorType.stripeConfiguration,
            )
            .having(
              (state) => state.message,
              'message',
              localizations.stripePublishableKeyMissing,
            ),
      );

      await cubit.close();
    });
  });
}

AidRequestPaymentCubit _buildCubit(
  _FakeAidRequestPaymentService service,
  _FakeStripePaymentSheetService stripeService, {
  StripeConfig stripeConfig = const StripeConfig(
    publishableKey: 'pk_test_unit',
  ),
}) {
  return AidRequestPaymentCubit(
    repository: AidRequestPaymentRepository(
      paymentService: service,
      stripePaymentSheetService: stripeService,
    ),
    stripeConfig: stripeConfig,
  );
}

const _paymentIntent = AidRequestPaymentIntentModel(
  transactionId: 101,
  clientSecret: 'pi_123_secret_abc',
  amount: '25.00',
  currency: 'usd',
);

class _FakeAidRequestPaymentService extends AidRequestPaymentService {
  _FakeAidRequestPaymentService({this.error});

  final Object? error;
  int callCount = 0;
  int? requestId;
  double? amount;

  @override
  Future<AidRequestPaymentIntentModel> createPaymentIntent({
    required int requestId,
    required double amount,
  }) async {
    callCount++;
    this.requestId = requestId;
    this.amount = amount;

    final error = this.error;
    if (error != null) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }

    return _paymentIntent;
  }
}

class _FakeStripePaymentSheetService extends StripePaymentSheetService {
  _FakeStripePaymentSheetService({this.error});

  final Object? error;
  String? clientSecret;
  String? merchantDisplayName;

  @override
  Future<void> initAndPresentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    this.clientSecret = clientSecret;
    this.merchantDisplayName = merchantDisplayName;

    final error = this.error;
    if (error != null) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
  }
}
