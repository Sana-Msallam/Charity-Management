class ZakatResultModel {
  const ZakatResultModel({
    required this.type,
    required this.eligible,
    required this.amount,
    required this.amountUnit,
    required this.nisabAmount,
    required this.nisabUnit,
    required this.gramPrice,
    required this.assetValue,
    required this.zakatRate,
    required this.zakatDue,
    required this.currency,
    required this.message,
  });

  final String type;
  final bool eligible;
  final double amount;
  final String amountUnit;
  final double nisabAmount;
  final String nisabUnit;
  final double gramPrice;
  final double assetValue;
  final double zakatRate;
  final double zakatDue;
  final String currency;
  final String message;

  factory ZakatResultModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ZakatResultModel(
      type: json['type']?.toString() ?? '',
      eligible: json['eligible'] == true,
      amount: _parseDouble(
        json['amount'],
      ),
      amountUnit:
          json['amountUnit']?.toString() ?? '',
      nisabAmount: _parseDouble(
        json['nisabAmount'],
      ),
      nisabUnit:
          json['nisabUnit']?.toString() ?? '',
      gramPrice: _parseDouble(
        json['gramPrice'],
      ),
      assetValue: _parseDouble(
        json['assetValue'],
      ),
      zakatRate: _parseDouble(
        json['zakatRate'],
      ),
      zakatDue: _parseDouble(
        json['zakatDue'],
      ),
      currency:
          json['currency']?.toString() ?? '',
      message:
          json['message']?.toString() ?? '',
    );
  }

  static double _parseDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  double get zakatPercentage {
    return zakatRate * 100;
  }
}