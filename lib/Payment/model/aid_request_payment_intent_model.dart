class AidRequestPaymentIntentModel {
  const AidRequestPaymentIntentModel({
    required this.transactionId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
  });

  final int transactionId;
  final String clientSecret;
  final String amount;
  final String currency;

  factory AidRequestPaymentIntentModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<String, dynamic> ? data : json;

    final transactionId = source['transactionId'];
    final clientSecret = source['clientSecret'];
    final amount = source['amount'];
    final currency = source['currency'];

    if (transactionId == null ||
        clientSecret == null ||
        amount == null ||
        currency == null) {
      throw const FormatException('Invalid payment intent response');
    }

    return AidRequestPaymentIntentModel(
      transactionId: transactionId is int
          ? transactionId
          : int.parse(transactionId.toString()),
      clientSecret: clientSecret.toString(),
      amount: amount.toString(),
      currency: currency.toString(),
    );
  }
}
