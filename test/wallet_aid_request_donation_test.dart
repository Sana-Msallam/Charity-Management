import 'dart:async';

import 'package:charity_management/Payment/cubit/wallet_aid_request_donation_cubit.dart';
import 'package:charity_management/Payment/cubit/wallet_aid_request_donation_state.dart';
import 'package:charity_management/Payment/model/wallet_aid_request_donation_model.dart';
import 'package:charity_management/Payment/repository/wallet_aid_request_donation_repository.dart';
import 'package:charity_management/Payment/service/wallet_aid_request_donation_service.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/l10n/generated/app_localizations_en.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final localizations = AppLocalizationsEn();

  group('WalletAidRequestDonationModel', () {
    test('parses balanceAfter from response data', () {
      final model = WalletAidRequestDonationModel.fromJson(const {
        'success': true,
        'data': {'amount': '25.00', 'balanceAfter': '75.00', 'currency': 'USD'},
      });

      expect(model.amount, '25.00');
      expect(model.balanceAfter, '75.00');
      expect(model.currency, 'USD');
    });
  });

  group('WalletAidRequestDonationService', () {
    test(
      'posts decimal string amount to the wallet donation endpoint',
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
                      'success': true,
                      'data': {'balanceAfter': '75.00', 'amount': '25.00'},
                    },
                  ),
                );
              },
            ),
          );

        final service = WalletAidRequestDonationService(dio: dio);
        final result = await service.donate(requestId: 42, amount: 25);

        expect(capturedOptions.method, 'POST');
        expect(capturedOptions.path, ApiConstants.walletDonateAidRequest(42));
        expect(capturedOptions.data, {'amount': '25.00'});
        expect(result.balanceAfter, '75.00');
      },
    );
  });

  group('WalletAidRequestDonationCubit', () {
    test('emits loading and success', () async {
      final service = _FakeWalletAidRequestDonationService();
      final cubit = _buildCubit(service);
      final states = <WalletAidRequestDonationState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.donate(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        walletBalance: 100,
        localizations: localizations,
      );
      await Future<void>.delayed(Duration.zero);

      expect(service.requestId, 42);
      expect(service.amount, 25);
      expect(cubit.state, isA<WalletAidRequestDonationSuccess>());
      expect(states, [
        isA<WalletAidRequestDonationLoading>(),
        isA<WalletAidRequestDonationSuccess>(),
      ]);

      await subscription.cancel();
      await cubit.close();
    });

    test('validates positive amount before backend call', () async {
      final service = _FakeWalletAidRequestDonationService();
      final cubit = _buildCubit(service);

      await cubit.donate(
        requestId: 42,
        amount: 0,
        remainingAmount: 100,
        walletBalance: 100,
        localizations: localizations,
      );

      expect(service.callCount, 0);
      expect(
        cubit.state,
        isA<WalletAidRequestDonationFailure>().having(
          (state) => state.type,
          'type',
          WalletAidRequestDonationErrorType.validation,
        ),
      );

      await cubit.close();
    });

    test(
      'validates amount against remaining amount before backend call',
      () async {
        final service = _FakeWalletAidRequestDonationService();
        final cubit = _buildCubit(service);

        await cubit.donate(
          requestId: 42,
          amount: 125,
          remainingAmount: 100,
          walletBalance: 200,
          localizations: localizations,
        );

        expect(service.callCount, 0);
        expect(
          cubit.state,
          isA<WalletAidRequestDonationFailure>().having(
            (state) => state.type,
            'type',
            WalletAidRequestDonationErrorType.validation,
          ),
        );

        await cubit.close();
      },
    );

    test(
      'validates amount against wallet balance before backend call',
      () async {
        final service = _FakeWalletAidRequestDonationService();
        final cubit = _buildCubit(service);

        await cubit.donate(
          requestId: 42,
          amount: 125,
          remainingAmount: 200,
          walletBalance: 100,
          localizations: localizations,
        );

        expect(service.callCount, 0);
        expect(
          cubit.state,
          isA<WalletAidRequestDonationFailure>().having(
            (state) => state.type,
            'type',
            WalletAidRequestDonationErrorType.validation,
          ),
        );

        await cubit.close();
      },
    );

    test('emits backend message for backend failures', () async {
      final requestOptions = RequestOptions(path: '/wallet/donate');
      final service = _FakeWalletAidRequestDonationService(
        error: DioException(
          requestOptions: requestOptions,
          response: Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: 400,
            data: const {'message': 'Insufficient wallet balance'},
          ),
        ),
      );
      final cubit = _buildCubit(service);

      await cubit.donate(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        walletBalance: 100,
        localizations: localizations,
      );

      expect(
        cubit.state,
        isA<WalletAidRequestDonationFailure>()
            .having(
              (state) => state.type,
              'type',
              WalletAidRequestDonationErrorType.backend,
            )
            .having(
              (state) => state.message,
              'message',
              'Insufficient wallet balance',
            ),
      );

      await cubit.close();
    });

    test('ignores repeated taps while loading', () async {
      final completer = Completer<WalletAidRequestDonationModel>();
      final service = _FakeWalletAidRequestDonationService(
        donationCompleter: completer,
      );
      final cubit = _buildCubit(service);

      final firstCall = cubit.donate(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        walletBalance: 100,
        localizations: localizations,
      );
      await Future<void>.delayed(Duration.zero);

      await cubit.donate(
        requestId: 42,
        amount: 25,
        remainingAmount: 100,
        walletBalance: 100,
        localizations: localizations,
      );

      completer.complete(_walletDonation);
      await firstCall;

      expect(service.callCount, 1);

      await cubit.close();
    });
  });
}

WalletAidRequestDonationCubit _buildCubit(
  _FakeWalletAidRequestDonationService service,
) {
  return WalletAidRequestDonationCubit(
    repository: WalletAidRequestDonationRepository(service: service),
  );
}

const _walletDonation = WalletAidRequestDonationModel(
  amount: '25.00',
  balanceAfter: '75.00',
  currency: 'USD',
);

class _FakeWalletAidRequestDonationService
    extends WalletAidRequestDonationService {
  _FakeWalletAidRequestDonationService({this.error, this.donationCompleter});

  final Object? error;
  final Completer<WalletAidRequestDonationModel>? donationCompleter;
  int callCount = 0;
  int? requestId;
  double? amount;

  @override
  Future<WalletAidRequestDonationModel> donate({
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

    final donationCompleter = this.donationCompleter;
    if (donationCompleter != null) {
      return donationCompleter.future;
    }

    return _walletDonation;
  }
}
