import 'package:charity_management/Payment/model/aid_request_payment_intent_model.dart';
import 'package:charity_management/Payment/service/aid_request_payment_service.dart';
import 'package:charity_management/Payment/service/stripe_payment_sheet_service.dart';

class AidRequestPaymentRepository {
  AidRequestPaymentRepository({
    AidRequestPaymentService? paymentService,
    StripePaymentSheetService? stripePaymentSheetService,
  }) : _paymentService = paymentService ?? AidRequestPaymentService(),
       _stripePaymentSheetService =
           stripePaymentSheetService ?? const StripePaymentSheetService();

  final AidRequestPaymentService _paymentService;
  final StripePaymentSheetService _stripePaymentSheetService;

  Future<AidRequestPaymentIntentModel> createPaymentIntent({
    required int requestId,
    required double amount,
  }) {
    return _paymentService.createPaymentIntent(
      requestId: requestId,
      amount: amount,
    );
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
