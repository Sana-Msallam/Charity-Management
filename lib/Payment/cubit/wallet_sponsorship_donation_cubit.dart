import 'package:charity_management/Payment/cubit/wallet_sponsorship_donation_state.dart';
import 'package:charity_management/Payment/repository/wallet_sponsorship_donation_repository.dart';
import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletSponsorshipDonationCubit
    extends Cubit<WalletSponsorshipDonationState> {
  WalletSponsorshipDonationCubit({
    WalletSponsorshipDonationRepository? repository,
  }) : _repository = repository ?? WalletSponsorshipDonationRepository(),
       super(const WalletSponsorshipDonationInitial());

  final WalletSponsorshipDonationRepository _repository;

  Future<void> donate({
    required int sponsorshipId,
    required AppLocalizations localizations,
  }) async {
    if (state is WalletSponsorshipDonationLoading) {
      return;
    }

    emit(const WalletSponsorshipDonationLoading());

    try {
      final donation = await _repository.donate(sponsorshipId: sponsorshipId);
      emit(WalletSponsorshipDonationSuccess(donation));
    } on DioException catch (error) {
      debugPrint('Wallet sponsorship donation DioException:');
      debugPrint('  type: ${error.type}');
      debugPrint('  statusCode: ${error.response?.statusCode}');
      debugPrint('  response: ${error.response?.data}');
      debugPrint('  uri: ${error.requestOptions.uri}');
      emit(
        WalletSponsorshipDonationFailure(
          message: ApiException.getMessage(error, localizations),
          type: _dioErrorType(error),
        ),
      );
    } on FormatException {
      debugPrint('Wallet sponsorship donation failed: invalid response.');
      emit(
        WalletSponsorshipDonationFailure(
          message: localizations.invalidServerResponse,
          type: WalletSponsorshipDonationErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Wallet sponsorship donation unexpected error: $error');
      debugPrint('Wallet sponsorship donation stack trace: $stackTrace');
      emit(
        WalletSponsorshipDonationFailure(
          message: localizations.unexpectedError,
          type: WalletSponsorshipDonationErrorType.unexpected,
        ),
      );
    }
  }

  void reset() {
    emit(const WalletSponsorshipDonationInitial());
  }

  WalletSponsorshipDonationErrorType _dioErrorType(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return WalletSponsorshipDonationErrorType.network;
    }

    if (error.response?.statusCode == 401) {
      return WalletSponsorshipDonationErrorType.unauthorized;
    }

    if (error.response?.statusCode == 403) {
      return WalletSponsorshipDonationErrorType.forbidden;
    }

    return WalletSponsorshipDonationErrorType.backend;
  }
}
