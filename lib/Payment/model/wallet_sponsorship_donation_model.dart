class WalletSponsorshipDonationModel {
  const WalletSponsorshipDonationModel({
    required this.message,
    this.paidAmount,
    this.coveredMonth,
    this.balanceAfter,
    this.currency,
    this.sponsorship,
  });

  final String message;
  final String? paidAmount;
  final String? coveredMonth;
  final String? balanceAfter;
  final String? currency;
  final Map<String, dynamic>? sponsorship;

  factory WalletSponsorshipDonationModel.fromJson(Map<String, dynamic> json) {
    final payload = _unwrapPayload(json);
    final message = json['message'] ?? payload['message'];

    if (message == null) {
      throw const FormatException(
        'Invalid wallet sponsorship donation response',
      );
    }

    return WalletSponsorshipDonationModel(
      message: message.toString(),
      paidAmount: _readString(payload, const ['paidAmount', 'amount']),
      coveredMonth: _readString(payload, const ['coveredMonth', 'month']),
      balanceAfter: _readString(payload, const [
        'balanceAfter',
        'walletBalance',
        'balance',
      ]),
      currency: payload['currency']?.toString(),
      sponsorship: _parseSponsorship(payload),
    );
  }

  static Map<String, dynamic> _unwrapPayload(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }

    return json;
  }

  static String? _readString(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final value = payload[key];
      if (value != null) {
        return value.toString();
      }
    }

    return null;
  }

  static Map<String, dynamic>? _parseSponsorship(Map<String, dynamic> payload) {
    final sponsorship = payload['sponsorship'];
    if (sponsorship is Map<String, dynamic>) {
      return sponsorship;
    }

    return null;
  }
}
