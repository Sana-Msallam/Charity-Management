import '../model/sponsorship_list_model.dart';

abstract class SponsorshipListState {}

class SponsorshipListInitial extends SponsorshipListState {}

class SponsorshipListLoading extends SponsorshipListState {}

class SponsorshipListSuccess extends SponsorshipListState {
  final List<SponsorshipListModel> sponsorships;

  SponsorshipListSuccess(this.sponsorships);
}

class SponsorshipListError extends SponsorshipListState {
  final String message;

  SponsorshipListError(this.message);
}