import 'package:charity_management/Donor/model/aid_request_details_model.dart';

class WalletAidRequestDonationModel {
  const WalletAidRequestDonationModel({
    required this.balanceAfter,
    this.amount,
    this.currency,
    this.request,
  });

  final String balanceAfter;
  final String? amount;
  final String? currency;
  final AidRequestDetailsModel? request;

  factory WalletAidRequestDonationModel.fromJson(Map<String, dynamic> json) {
    final payload = _unwrapPayload(json);
    final balanceAfter =
        payload['balanceAfter'] ??
        payload['walletBalance'] ??
        payload['balance'];

    if (balanceAfter == null) {
      throw const FormatException('Invalid wallet donation response');
    }

    return WalletAidRequestDonationModel(
      balanceAfter: balanceAfter.toString(),
      amount: payload['amount']?.toString(),
      currency: payload['currency']?.toString(),
      request: _parseRequest(payload),
    );
  }

  static Map<String, dynamic> _unwrapPayload(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }

    return json;
  }

  static AidRequestDetailsModel? _parseRequest(Map<String, dynamic> payload) {
    final request = payload['aidRequest'] ?? payload['request'];
    if (request is Map<String, dynamic>) {
      return AidRequestDetailsModel.fromJson(request);
    }

    return null;
  }
}
