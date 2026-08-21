import 'package:charity_management/Donor/model/quick_donation_fund_payment_intent_model.dart';
import 'package:charity_management/Donor/model/quick_donation_fund_wallet_donation_model.dart';
import 'package:charity_management/Donor/service/quick_donation_fund_service.dart';
import 'package:charity_management/Payment/service/stripe_payment_sheet_service.dart';

class QuickDonationFundRepository {
  QuickDonationFundRepository({
    QuickDonationFundService? service,
    StripePaymentSheetService? stripePaymentSheetService,
  }) : _service = service ?? QuickDonationFundService(),
       _stripePaymentSheetService =
           stripePaymentSheetService ?? const StripePaymentSheetService();

  final QuickDonationFundService _service;
  final StripePaymentSheetService _stripePaymentSheetService;

  Future<QuickDonationFundPaymentIntentModel> createPaymentIntent({
    required double amount,
  }) {
    return _service.createPaymentIntent(amount: amount);
  }

  Future<QuickDonationFundWalletDonationModel> donateFromWallet({
    required double amount,
  }) {
    return _service.donateFromWallet(amount: amount);
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
