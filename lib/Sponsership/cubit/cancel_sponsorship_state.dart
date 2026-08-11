import '../model/cancel_sponsorship_model.dart';

abstract class CancelSponsorshipState {}

class CancelSponsorshipInitial extends CancelSponsorshipState {}

class CancelSponsorshipLoading extends CancelSponsorshipState {}

class CancelSponsorshipSuccess extends CancelSponsorshipState {
  final CancelSponsorshipResponse response;

  CancelSponsorshipSuccess(this.response);
}

class CancelSponsorshipError extends CancelSponsorshipState {
  final String message;

  CancelSponsorshipError(this.message);
}