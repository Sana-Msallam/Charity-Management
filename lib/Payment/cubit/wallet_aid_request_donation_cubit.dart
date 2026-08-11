import 'package:charity_management/Payment/cubit/wallet_aid_request_donation_state.dart';
import 'package:charity_management/Payment/repository/wallet_aid_request_donation_repository.dart';
import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletAidRequestDonationCubit
    extends Cubit<WalletAidRequestDonationState> {
  WalletAidRequestDonationCubit({
    WalletAidRequestDonationRepository? repository,
  }) : _repository = repository ?? WalletAidRequestDonationRepository(),
       super(const WalletAidRequestDonationInitial());

  final WalletAidRequestDonationRepository _repository;

  Future<void> donate({
    required int requestId,
    required double amount,
    required double remainingAmount,
    required double walletBalance,
    required AppLocalizations localizations,
  }) async {
    if (state is WalletAidRequestDonationLoading) {
      return;
    }

    if (amount <= 0) {
      emit(
        WalletAidRequestDonationFailure(
          message: localizations.paymentAmountMustBePositive,
          type: WalletAidRequestDonationErrorType.validation,
        ),
      );
      return;
    }

    if (amount > remainingAmount) {
      emit(
        WalletAidRequestDonationFailure(
          message: localizations.paymentAmountExceedsRemaining,
          type: WalletAidRequestDonationErrorType.validation,
        ),
      );
      return;
    }

    if (amount > walletBalance) {
      emit(
        WalletAidRequestDonationFailure(
          message: _insufficientWalletBalanceMessage(localizations),
          type: WalletAidRequestDonationErrorType.validation,
        ),
      );
      return;
    }

    emit(const WalletAidRequestDonationLoading());

    try {
      final donation = await _repository.donate(
        requestId: requestId,
        amount: amount,
      );
      emit(WalletAidRequestDonationSuccess(donation));
    } on DioException catch (error) {
      debugPrint('Wallet aid request donation DioException:');
      debugPrint('  type: ${error.type}');
      debugPrint('  statusCode: ${error.response?.statusCode}');
      debugPrint('  response: ${error.response?.data}');
      debugPrint('  uri: ${error.requestOptions.uri}');
      emit(
        WalletAidRequestDonationFailure(
          message: ApiException.getMessage(error, localizations),
          type: _dioErrorType(error),
        ),
      );
    } on FormatException {
      debugPrint('Wallet aid request donation failed: invalid response.');
      emit(
        WalletAidRequestDonationFailure(
          message: localizations.invalidServerResponse,
          type: WalletAidRequestDonationErrorType.backend,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Wallet aid request donation unexpected error: $error');
      debugPrint('Wallet aid request donation stack trace: $stackTrace');
      emit(
        WalletAidRequestDonationFailure(
          message: localizations.unexpectedError,
          type: WalletAidRequestDonationErrorType.unexpected,
        ),
      );
    }
  }

  void reset() {
    emit(const WalletAidRequestDonationInitial());
  }

  WalletAidRequestDonationErrorType _dioErrorType(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return WalletAidRequestDonationErrorType.network;
    }

    if (error.response?.statusCode == 401) {
      return WalletAidRequestDonationErrorType.unauthorized;
    }

    if (error.response?.statusCode == 403) {
      return WalletAidRequestDonationErrorType.forbidden;
    }

    return WalletAidRequestDonationErrorType.backend;
  }

  String _insufficientWalletBalanceMessage(AppLocalizations localizations) {
    if (localizations.localeName == 'ar') {
      return 'رصيد المحفظة غير كافٍ لإتمام هذا التبرع.';
    }

    return 'Your wallet balance is not enough to complete this donation.';
  }
}
