
// import '../model/profile_model.dart';


import 'package:charity_management/features/Donor/model/profile_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileModel profile;

  ProfileSuccessState(this.profile);
}

class ProfileErrorState extends ProfileState {
  final String errorMessage;

  ProfileErrorState(this.errorMessage);
}
