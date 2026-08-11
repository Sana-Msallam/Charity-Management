import 'package:charity_management/Payment/model/wallet_aid_request_donation_model.dart';
import 'package:charity_management/Payment/service/wallet_aid_request_donation_service.dart';

class WalletAidRequestDonationRepository {
  WalletAidRequestDonationRepository({WalletAidRequestDonationService? service})
    : _service = service ?? WalletAidRequestDonationService();

  final WalletAidRequestDonationService _service;

  Future<WalletAidRequestDonationModel> donate({
    required int requestId,
    required double amount,
  }) {
    return _service.donate(requestId: requestId, amount: amount);
  }
}
