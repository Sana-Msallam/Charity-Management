import 'package:charity_management/Payment/model/wallet_aid_request_donation_model.dart';

enum WalletAidRequestDonationErrorType {
  validation,
  network,
  backend,
  unauthorized,
  forbidden,
  unexpected,
}

sealed class WalletAidRequestDonationState {
  const WalletAidRequestDonationState();
}

final class WalletAidRequestDonationInitial
    extends WalletAidRequestDonationState {
  const WalletAidRequestDonationInitial();
}

final class WalletAidRequestDonationLoading
    extends WalletAidRequestDonationState {
  const WalletAidRequestDonationLoading();
}

final class WalletAidRequestDonationSuccess
    extends WalletAidRequestDonationState {
  const WalletAidRequestDonationSuccess(this.donation);

  final WalletAidRequestDonationModel donation;
}

final class WalletAidRequestDonationFailure
    extends WalletAidRequestDonationState {
  const WalletAidRequestDonationFailure({
    required this.message,
    required this.type,
  });

  final String message;
  final WalletAidRequestDonationErrorType type;
}
