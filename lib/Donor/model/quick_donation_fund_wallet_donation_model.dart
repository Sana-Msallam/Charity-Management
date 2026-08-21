class QuickDonationFundWalletDonationModel {
  const QuickDonationFundWalletDonationModel({
    required this.success,
    required this.message,
    required this.walletTransactionId,
    required this.donatedAmount,
    required this.balanceAfter,
    required this.currency,
  });

  final bool success;
  final String message;
  final int walletTransactionId;
  final String donatedAmount;
  final String balanceAfter;
  final String currency;

  factory QuickDonationFundWalletDonationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final success = json['success'];
    final message = json['message'];
    final data = json['data'];

    if (success == null || message == null || data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid quick donation fund wallet response',
      );
    }

    final walletTransactionId = data['walletTransactionId'];
    final donatedAmount = data['donatedAmount'];
    final balanceAfter = data['balanceAfter'];
    final currency = data['currency'];

    if (walletTransactionId == null ||
        donatedAmount == null ||
        balanceAfter == null ||
        currency == null) {
      throw const FormatException(
        'Invalid quick donation fund wallet response',
      );
    }

    return QuickDonationFundWalletDonationModel(
      success: success == true || success.toString().toLowerCase() == 'true',
      message: message.toString(),
      walletTransactionId: walletTransactionId is int
          ? walletTransactionId
          : int.parse(walletTransactionId.toString()),
      donatedAmount: donatedAmount.toString(),
      balanceAfter: balanceAfter.toString(),
      currency: currency.toString(),
    );
  }
}
