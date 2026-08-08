import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeConfig {
  const StripeConfig({String? publishableKey})
    : _publishableKey =
          publishableKey ?? const String.fromEnvironment(_publishableKeyName);

  static const String _publishableKeyName = 'STRIPE_PUBLISHABLE_KEY';

  final String _publishableKey;

  bool get isConfigured =>
      _publishableKey.isNotEmpty && _publishableKey.startsWith('pk_test_');

  String? validationMessage(AppLocalizations localizations) {
    if (_publishableKey.isEmpty) {
      return localizations.stripePublishableKeyMissing;
    }

    if (!_publishableKey.startsWith('pk_test_')) {
      return localizations.stripePublishableKeyInvalid;
    }

    return null;
  }

  Future<void> initialize() async {
    if (_publishableKey.isEmpty) {
      debugPrint('Stripe is not initialized: $_publishableKeyName is missing.');
      return;
    }

    if (!_publishableKey.startsWith('pk_test_')) {
      debugPrint(
        'Stripe is not initialized: $_publishableKeyName must start with pk_test_.',
      );
      return;
    }

    try {
      Stripe.publishableKey = _publishableKey;
      await Stripe.instance.applySettings();
      debugPrint('Stripe initialized with a pk_test publishable key.');
    } catch (error, stackTrace) {
      debugPrint('Stripe initialization failed: $error');
      debugPrint('Stripe initialization stack trace: $stackTrace');
    }
  }
}
