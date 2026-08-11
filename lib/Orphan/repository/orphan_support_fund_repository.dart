import 'package:charity_management/Orphan/model/orphan_support_fund_payment_intent_model.dart';
import 'package:charity_management/Orphan/model/orphan_support_fund_wallet_donation_model.dart';
import 'package:charity_management/Orphan/service/orphan_support_fund_service.dart';
import 'package:charity_management/Payment/service/stripe_payment_sheet_service.dart';

class OrphanSupportFundRepository {
  OrphanSupportFundRepository({
    OrphanSupportFundService? service,
    StripePaymentSheetService? stripePaymentSheetService,
  }) : _service = service ?? OrphanSupportFundService(),
       _stripePaymentSheetService =
           stripePaymentSheetService ?? const StripePaymentSheetService();

  final OrphanSupportFundService _service;
  final StripePaymentSheetService _stripePaymentSheetService;

  Future<OrphanSupportFundPaymentIntentModel> createPaymentIntent({
    required double amount,
  }) {
    return _service.createPaymentIntent(amount: amount);
  }

  Future<OrphanSupportFundWalletDonationModel> donateFromWallet({
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
