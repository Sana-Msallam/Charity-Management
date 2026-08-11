class WalletBalanceModel {
  const WalletBalanceModel({required this.balance, required this.currency});

  final String balance;
  final String currency;

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    final balance = json['balance'];
    final currency = json['currency'];

    if (balance == null || currency == null) {
      throw const FormatException('Invalid wallet balance response');
    }

    return WalletBalanceModel(
      balance: balance.toString(),
      currency: currency.toString(),
    );
  }
}
