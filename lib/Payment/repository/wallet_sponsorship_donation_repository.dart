import 'package:charity_management/Payment/model/wallet_sponsorship_donation_model.dart';
import 'package:charity_management/Payment/service/wallet_sponsorship_donation_service.dart';

class WalletSponsorshipDonationRepository {
  WalletSponsorshipDonationRepository({
    WalletSponsorshipDonationService? service,
  }) : _service = service ?? WalletSponsorshipDonationService();

  final WalletSponsorshipDonationService _service;

  Future<WalletSponsorshipDonationModel> donate({required int sponsorshipId}) {
    return _service.donate(sponsorshipId: sponsorshipId);
  }
}
