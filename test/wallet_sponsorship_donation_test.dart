import 'dart:async';

import 'package:charity_management/Payment/cubit/wallet_sponsorship_donation_cubit.dart';
import 'package:charity_management/Payment/cubit/wallet_sponsorship_donation_state.dart';
import 'package:charity_management/Payment/model/wallet_sponsorship_donation_model.dart';
import 'package:charity_management/Payment/repository/wallet_sponsorship_donation_repository.dart';
import 'package:charity_management/Payment/service/wallet_sponsorship_donation_service.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/l10n/generated/app_localizations_en.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final localizations = AppLocalizationsEn();

  group('WalletSponsorshipDonationModel', () {
    test('parses monthly sponsorship payment response data', () {
      final model = WalletSponsorshipDonationModel.fromJson(const {
        'success': true,
        'message': 'Monthly sponsorship paid successfully',
        'data': {
          'paidAmount': '50.00',
          'coveredMonth': '2026-08',
          'balanceAfter': '150.00',
          'currency': 'USD',
        },
      });

      expect(model.message, 'Monthly sponsorship paid successfully');
      expect(model.paidAmount, '50.00');
      expect(model.coveredMonth, '2026-08');
      expect(model.balanceAfter, '150.00');
      expect(model.currency, 'USD');
    });
  });

  group('WalletSponsorshipDonationService', () {
    test('posts without body to the sponsorship donation endpoint', () async {
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
                    'message': 'Paid',
                    'data': {
                      'paidAmount': '50.00',
                      'coveredMonth': '2026-08',
                      'balanceAfter': '150.00',
                    },
                  },
                ),
              );
            },
          ),
        );

      final service = WalletSponsorshipDonationService(dio: dio);
      final result = await service.donate(sponsorshipId: 42);

      expect(capturedOptions.method, 'POST');
      expect(capturedOptions.path, ApiConstants.walletDonateSponsorship(42));
      expect(capturedOptions.data, isNull);
      expect(result.message, 'Paid');
      expect(result.paidAmount, '50.00');
    });
  });

  group('WalletSponsorshipDonationCubit', () {
    test('emits loading and success', () async {
      final service = _FakeWalletSponsorshipDonationService();
      final cubit = _buildCubit(service);
      final states = <WalletSponsorshipDonationState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.donate(sponsorshipId: 42, localizations: localizations);
      await Future<void>.delayed(Duration.zero);

      expect(service.sponsorshipId, 42);
      expect(cubit.state, isA<WalletSponsorshipDonationSuccess>());
      expect(states, [
        isA<WalletSponsorshipDonationLoading>(),
        isA<WalletSponsorshipDonationSuccess>(),
      ]);

      await subscription.cancel();
      await cubit.close();
    });

    test('emits backend message for backend failures', () async {
      final requestOptions = RequestOptions(path: '/wallet/donate');
      final service = _FakeWalletSponsorshipDonationService(
        error: DioException(
          requestOptions: requestOptions,
          response: Response<dynamic>(
            requestOptions: requestOptions,
            statusCode: 400,
            data: const {'message': 'This month was already paid'},
          ),
        ),
      );
      final cubit = _buildCubit(service);

      await cubit.donate(sponsorshipId: 42, localizations: localizations);

      expect(
        cubit.state,
        isA<WalletSponsorshipDonationFailure>()
            .having(
              (state) => state.type,
              'type',
              WalletSponsorshipDonationErrorType.backend,
            )
            .having(
              (state) => state.message,
              'message',
              'This month was already paid',
            ),
      );

      await cubit.close();
    });

    test('emits invalid server response for malformed success body', () async {
      final service = _FakeWalletSponsorshipDonationService(
        error: const FormatException(
          'Invalid wallet sponsorship donation response',
        ),
      );
      final cubit = _buildCubit(service);

      await cubit.donate(sponsorshipId: 42, localizations: localizations);

      expect(
        cubit.state,
        isA<WalletSponsorshipDonationFailure>()
            .having(
              (state) => state.type,
              'type',
              WalletSponsorshipDonationErrorType.backend,
            )
            .having(
              (state) => state.message,
              'message',
              localizations.invalidServerResponse,
            ),
      );

      await cubit.close();
    });

    test('ignores repeated taps while loading', () async {
      final completer = Completer<WalletSponsorshipDonationModel>();
      final service = _FakeWalletSponsorshipDonationService(
        donationCompleter: completer,
      );
      final cubit = _buildCubit(service);

      final firstCall = cubit.donate(
        sponsorshipId: 42,
        localizations: localizations,
      );
      await Future<void>.delayed(Duration.zero);

      await cubit.donate(sponsorshipId: 42, localizations: localizations);

      completer.complete(_walletDonation);
      await firstCall;

      expect(service.callCount, 1);

      await cubit.close();
    });
  });
}

WalletSponsorshipDonationCubit _buildCubit(
  _FakeWalletSponsorshipDonationService service,
) {
  return WalletSponsorshipDonationCubit(
    repository: WalletSponsorshipDonationRepository(service: service),
  );
}

const _walletDonation = WalletSponsorshipDonationModel(
  message: 'Paid',
  paidAmount: '50.00',
  coveredMonth: '2026-08',
  balanceAfter: '150.00',
);

class _FakeWalletSponsorshipDonationService
    extends WalletSponsorshipDonationService {
  _FakeWalletSponsorshipDonationService({this.error, this.donationCompleter});

  final Object? error;
  final Completer<WalletSponsorshipDonationModel>? donationCompleter;
  int callCount = 0;
  int? sponsorshipId;

  @override
  Future<WalletSponsorshipDonationModel> donate({
    required int sponsorshipId,
  }) async {
    callCount++;
    this.sponsorshipId = sponsorshipId;

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
