import 'package:charity_management/Payment/model/wallet_sponsorship_donation_model.dart';

enum WalletSponsorshipDonationErrorType {
  network,
  backend,
  unauthorized,
  forbidden,
  unexpected,
}

sealed class WalletSponsorshipDonationState {
  const WalletSponsorshipDonationState();
}

final class WalletSponsorshipDonationInitial
    extends WalletSponsorshipDonationState {
  const WalletSponsorshipDonationInitial();
}

final class WalletSponsorshipDonationLoading
    extends WalletSponsorshipDonationState {
  const WalletSponsorshipDonationLoading();
}

final class WalletSponsorshipDonationSuccess
    extends WalletSponsorshipDonationState {
  const WalletSponsorshipDonationSuccess(this.donation);

  final WalletSponsorshipDonationModel donation;
}

final class WalletSponsorshipDonationFailure
    extends WalletSponsorshipDonationState {
  const WalletSponsorshipDonationFailure({
    required this.message,
    required this.type,
  });

  final String message;
  final WalletSponsorshipDonationErrorType type;
}
