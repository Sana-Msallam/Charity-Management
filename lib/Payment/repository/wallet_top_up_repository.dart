import 'package:charity_management/Payment/model/aid_request_payment_intent_model.dart';
import 'package:charity_management/Payment/model/wallet_balance_model.dart';
import 'package:charity_management/Payment/service/stripe_payment_sheet_service.dart';
import 'package:charity_management/Payment/service/wallet_top_up_service.dart';

class WalletTopUpRepository {
  WalletTopUpRepository({
    WalletTopUpService? walletTopUpService,
    StripePaymentSheetService? stripePaymentSheetService,
  }) : _walletTopUpService = walletTopUpService ?? WalletTopUpService(),
       _stripePaymentSheetService =
           stripePaymentSheetService ?? const StripePaymentSheetService();

  final WalletTopUpService _walletTopUpService;
  final StripePaymentSheetService _stripePaymentSheetService;

  Future<AidRequestPaymentIntentModel> createPaymentIntent({
    required double amount,
  }) {
    return _walletTopUpService.createPaymentIntent(amount: amount);
  }

  Future<WalletBalanceModel> fetchBalance() {
    return _walletTopUpService.fetchBalance();
  }

  Future<void> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) {
    return _stripePaymentSheetService.initAndPresentPaymentSheet(
      clientSecret: clientSecret,
      merchantDisplayName: merchantDisplayName,
    );
  }
}
