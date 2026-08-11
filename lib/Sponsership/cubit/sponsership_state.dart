part of 'sponsership_cubit.dart';

abstract class SponsorshipState {}

class SponsorshipInitial extends SponsorshipState {}

class SponsorshipLoading extends SponsorshipState {}

class SponsorshipSuccess extends SponsorshipState {
  final CreateSponsorshipResponse response;

  SponsorshipSuccess(this.response);
}

class SponsorshipError extends SponsorshipState {
  final String message;

  SponsorshipError(this.message);
}