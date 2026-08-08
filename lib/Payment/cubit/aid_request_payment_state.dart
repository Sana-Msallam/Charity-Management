import 'package:charity_management/Payment/model/aid_request_payment_intent_model.dart';

enum AidRequestPaymentErrorType {
  validation,
  network,
  backend,
  unauthorized,
  stripe,
  stripeConfiguration,
  unexpected,
}

sealed class AidRequestPaymentState {
  const AidRequestPaymentState();
}

final class AidRequestPaymentInitial extends AidRequestPaymentState {
  const AidRequestPaymentInitial();
}

final class AidRequestPaymentLoading extends AidRequestPaymentState {
  const AidRequestPaymentLoading();
}

final class AidRequestPaymentSuccess extends AidRequestPaymentState {
  const AidRequestPaymentSuccess(this.paymentIntent);

  final AidRequestPaymentIntentModel paymentIntent;
}

final class AidRequestPaymentCanceled extends AidRequestPaymentState {
  const AidRequestPaymentCanceled(this.message);

  final String message;
}

final class AidRequestPaymentFailure extends AidRequestPaymentState {
  const AidRequestPaymentFailure({required this.message, required this.type});

  final String message;
  final AidRequestPaymentErrorType type;
}
