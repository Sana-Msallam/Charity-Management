class OrphanSupportFundPaymentIntentModel {
  const OrphanSupportFundPaymentIntentModel({
    required this.transactionId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
  });

  final int transactionId;
  final String clientSecret;
  final String amount;
  final String currency;

  factory OrphanSupportFundPaymentIntentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final transactionId = json['transactionId'];
    final clientSecret = json['clientSecret'];
    final amount = json['amount'];
    final currency = json['currency'];

    if (transactionId == null ||
        clientSecret == null ||
        amount == null ||
        currency == null) {
      throw const FormatException(
        'Invalid orphan support fund payment intent response',
      );
    }

    return OrphanSupportFundPaymentIntentModel(
      transactionId: transactionId is int
          ? transactionId
          : int.parse(transactionId.toString()),
      clientSecret: clientSecret.toString(),
      amount: amount.toString(),
      currency: currency.toString(),
    );
  }
}
