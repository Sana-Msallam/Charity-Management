import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentSheetService {
  const StripePaymentSheetService();

  Future<void> initAndPresentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    final paymentIntentId = clientSecret.split('_secret_').first;
    var stage = 'initialize PaymentSheet';

    try {
      debugPrint('Stripe PaymentSheet: init started for $paymentIntentId.');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: merchantDisplayName,
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.light,
          allowsDelayedPaymentMethods: false,
          linkDisplayParams: const LinkDisplayParams(
            linkDisplay: LinkDisplay.never,
          ),
          paymentMethodOrder: const ['card'],
        ),
      );

      stage = 'present PaymentSheet';
      debugPrint('Stripe PaymentSheet: present started.');
      await Stripe.instance.presentPaymentSheet();
      debugPrint('Stripe PaymentSheet: completed.');
    } on StripeException catch (error) {
      debugPrint('Stripe failed during: $stage.');
      _logStripeException(error);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('Stripe unexpected error during $stage: $error');
      debugPrint('Stripe stack trace: $stackTrace');
      rethrow;
    }
  }

  void _logStripeException(StripeException error) {
    debugPrint('Stripe PaymentSheet exception:');
    debugPrint('  code: ${error.error.code}');
    debugPrint('  localizedMessage: ${error.error.localizedMessage}');
    debugPrint('  message: ${error.error.message}');
    debugPrint('  stripeErrorCode: ${error.error.stripeErrorCode}');
    debugPrint('  declineCode: ${error.error.declineCode}');
    debugPrint('  type: ${error.error.type}');
  }
}
