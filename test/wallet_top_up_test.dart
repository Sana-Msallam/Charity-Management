import 'package:charity_management/Payment/config/stripe_config.dart';
import 'package:charity_management/Payment/cubit/wallet_top_up_cubit.dart';
import 'package:charity_management/Payment/cubit/wallet_top_up_state.dart';
import 'package:charity_management/Payment/model/aid_request_payment_intent_model.dart';
import 'package:charity_management/Payment/model/wallet_balance_model.dart';
import 'package:charity_management/Payment/repository/wallet_top_up_repository.dart';
import 'package:charity_management/Payment/service/stripe_payment_sheet_service.dart';
import 'package:charity_management/Payment/service/wallet_top_up_service.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/l10n/generated/app_localizations_en.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final localizations = AppLocalizationsEn();

  group('WalletBalanceModel', () {
    test('parses balance response data', () {
      final model = WalletBalanceModel.fromJson(const {
        'balance': '250.00',
        'currency': 'USD',
      });

      expect(model.balance, '250.00');
      expect(model.currency, 'USD');
    });
  });

  group('WalletTopUpService', () {
    test(
      'posts decimal string amount to the wallet payment endpoint',
      () async {
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

        final service = WalletTopUpService(dio: dio);
        final result = await service.createPaymentIntent(amount: 25);

        expect(capturedOptions.method, 'POST');
        expect(capturedOptions.path, ApiConstants.walletTopUpPaymentIntent);
        expect(capturedOptions.data, {'amount': '25.00'});
        expect(result.clientSecret, 'pi_123_secret_abc');
      },
    );

    test('gets wallet balance from the balance endpoint', () async {
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
                    'success': true,
                    'data': {'balance': '250.00', 'currency': 'USD'},
                  },
                ),
              );
            },
          ),
        );

      final service = WalletTopUpService(dio: dio);
      final result = await service.fetchBalance();

      expect(capturedOptions.method, 'GET');
      expect(capturedOptions.path, ApiConstants.walletBalance);
      expect(result.balance, '250.00');
      expect(result.currency, 'USD');
    });

    test('throws FormatException for incomplete balance response', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://example.test'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              handler.resolve(
                Response<dynamic>(
                  requestOptions: options,
                  statusCode: 200,
                  data: const {'success': true},
                ),
              );
            },
          ),
        );

      final service = WalletTopUpService(dio: dio);

      expect(service.fetchBalance(), throwsA(isA<FormatException>()));
    });
  });

  group('WalletTopUpCubit balance', () {
    test('emits balance loading and success', () async {
      final service = _FakeWalletTopUpService();
      final cubit = _buildCubit(service, _FakeStripePaymentSheetService());
      final states = <WalletTopUpState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.fetchBalance(localizations: localizations);
      await Future<void>.delayed(Duration.zero);

      expect(service.fetchBalanceCount, 1);
      expect(cubit.state.balanceStatus, WalletBalanceStatus.success);
      expect(cubit.state.balance?.balance, '250.00');
      expect(states.map((state) => state.balanceStatus), [
        WalletBalanceStatus.loading,
        WalletBalanceStatus.success,
      ]);

      await subscription.cancel();
      await cubit.close();
    });

    test('emits balance failure for 403 responses', () async {
      final requestOptions = RequestOptions(path: '/wallet/balance');
      final service = _FakeWalletTopUpService(
        balanceError: DioException(
          requestOptions: requestOptions,
          response: Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: 403,
          ),
        ),
      );
      final cubit = _buildCubit(service, _FakeStripePaymentSheetService());

      await cubit.fetchBalance(localizations: localizations);

      expect(cubit.state.balanceStatus, WalletBalanceStatus.failure);
      expect(cubit.state.balanceErrorType, WalletTopUpErrorType.forbidden);

      await cubit.close();
    });
  });

  group('WalletTopUpCubit payment', () {
    test('emits top-up success and refreshes balance', () async {
      final service = _FakeWalletTopUpService();
      final stripeService = _FakeStripePaymentSheetService();
      final cubit = _buildCubit(service, stripeService);
      final states = <WalletTopUpState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.topUpWallet(amount: 25, localizations: localizations);
      await Future<void>.delayed(Duration.zero);

      expect(service.amount, 25);
      expect(service.fetchBalanceCount, 1);
      expect(stripeService.clientSecret, _paymentIntent.clientSecret);
      expect(cubit.state.topUpStatus, WalletTopUpStatus.success);
      expect(cubit.state.balanceStatus, WalletBalanceStatus.success);
      expect(states.map((state) => state.topUpStatus), [
        WalletTopUpStatus.loading,
        WalletTopUpStatus.success,
        WalletTopUpStatus.success,
        WalletTopUpStatus.success,
      ]);
      expect(states.map((state) => state.balanceStatus), [
        WalletBalanceStatus.initial,
        WalletBalanceStatus.initial,
        WalletBalanceStatus.loading,
        WalletBalanceStatus.success,
      ]);

      await subscription.cancel();
      await cubit.close();
    });

    test(
      'emits canceled failure when Stripe reports user cancellation',
      () async {
        final service = _FakeWalletTopUpService();
        final stripeService = _FakeStripePaymentSheetService(
          error: const StripeException(
            error: LocalizedErrorMessage(code: FailureCode.Canceled),
          ),
        );
        final cubit = _buildCubit(service, stripeService);

        await cubit.topUpWallet(amount: 25, localizations: localizations);

        expect(cubit.state.topUpStatus, WalletTopUpStatus.failure);
        expect(cubit.state.topUpErrorType, WalletTopUpErrorType.canceled);
        expect(cubit.state.topUpMessage, localizations.paymentCanceled);

        await cubit.close();
      },
    );

    test('emits stripe failure for Stripe errors', () async {
      final service = _FakeWalletTopUpService();
      final stripeService = _FakeStripePaymentSheetService(
        error: const StripeException(
          error: LocalizedErrorMessage(
            code: FailureCode.Failed,
            localizedMessage: 'Card declined',
          ),
        ),
      );
      final cubit = _buildCubit(service, stripeService);

      await cubit.topUpWallet(amount: 25, localizations: localizations);

      expect(cubit.state.topUpStatus, WalletTopUpStatus.failure);
      expect(cubit.state.topUpErrorType, WalletTopUpErrorType.stripe);
      expect(cubit.state.topUpMessage, 'Card declined');

      await cubit.close();
    });

    test('emits network failure for Dio connection errors', () async {
      final service = _FakeWalletTopUpService(
        paymentError: DioException(
          requestOptions: RequestOptions(path: '/wallet'),
          type: DioExceptionType.connectionError,
        ),
      );
      final cubit = _buildCubit(service, _FakeStripePaymentSheetService());

      await cubit.topUpWallet(amount: 25, localizations: localizations);

      expect(cubit.state.topUpStatus, WalletTopUpStatus.failure);
      expect(cubit.state.topUpErrorType, WalletTopUpErrorType.network);

      await cubit.close();
    });

    test('emits unauthorized failure for 401 responses', () async {
      final requestOptions = RequestOptions(path: '/wallet');
      final service = _FakeWalletTopUpService(
        paymentError: DioException(
          requestOptions: requestOptions,
          response: Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: 401,
          ),
        ),
      );
      final cubit = _buildCubit(service, _FakeStripePaymentSheetService());

      await cubit.topUpWallet(amount: 25, localizations: localizations);

      expect(cubit.state.topUpStatus, WalletTopUpStatus.failure);
      expect(cubit.state.topUpErrorType, WalletTopUpErrorType.unauthorized);

      await cubit.close();
    });

    test('validates amount before creating a payment intent', () async {
      final service = _FakeWalletTopUpService();
      final cubit = _buildCubit(service, _FakeStripePaymentSheetService());

      await cubit.topUpWallet(amount: 0, localizations: localizations);

      expect(service.createPaymentIntentCount, 0);
      expect(cubit.state.topUpStatus, WalletTopUpStatus.failure);
      expect(cubit.state.topUpErrorType, WalletTopUpErrorType.validation);

      await cubit.close();
    });

    test(
      'emits backend failure for incomplete payment intent response',
      () async {
        final service = _FakeWalletTopUpService(
          paymentError: const FormatException('Invalid wallet top-up response'),
        );
        final cubit = _buildCubit(service, _FakeStripePaymentSheetService());

        await cubit.topUpWallet(amount: 25, localizations: localizations);

        expect(cubit.state.topUpStatus, WalletTopUpStatus.failure);
        expect(cubit.state.topUpErrorType, WalletTopUpErrorType.backend);

        await cubit.close();
      },
    );

    test('does not create payment intent when Stripe key is missing', () async {
      final service = _FakeWalletTopUpService();
      final cubit = _buildCubit(
        service,
        _FakeStripePaymentSheetService(),
        stripeConfig: const StripeConfig(publishableKey: ''),
      );

      await cubit.topUpWallet(amount: 25, localizations: localizations);

      expect(service.createPaymentIntentCount, 0);
      expect(cubit.state.topUpStatus, WalletTopUpStatus.failure);
      expect(
        cubit.state.topUpErrorType,
        WalletTopUpErrorType.stripeConfiguration,
      );

      await cubit.close();
    });
  });
}

WalletTopUpCubit _buildCubit(
  _FakeWalletTopUpService service,
  _FakeStripePaymentSheetService stripeService, {
  StripeConfig stripeConfig = const StripeConfig(
    publishableKey: 'pk_test_unit',
  ),
}) {
  return WalletTopUpCubit(
    repository: WalletTopUpRepository(
      walletTopUpService: service,
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

const _walletBalance = WalletBalanceModel(balance: '250.00', currency: 'USD');

class _FakeWalletTopUpService extends WalletTopUpService {
  _FakeWalletTopUpService({this.paymentError, this.balanceError});

  final Object? paymentError;
  final Object? balanceError;
  int createPaymentIntentCount = 0;
  int fetchBalanceCount = 0;
  double? amount;

  @override
  Future<AidRequestPaymentIntentModel> createPaymentIntent({
    required double amount,
  }) async {
    createPaymentIntentCount++;
    this.amount = amount;

    final error = paymentError;
    if (error != null) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }

    return _paymentIntent;
  }

  @override
  Future<WalletBalanceModel> fetchBalance() async {
    fetchBalanceCount++;

    final error = balanceError;
    if (error != null) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }

    return _walletBalance;
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
