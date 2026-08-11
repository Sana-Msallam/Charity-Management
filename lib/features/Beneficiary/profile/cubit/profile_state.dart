import '../model/profile_model.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  const ProfileSuccess(
    this.profile,
  );

  final ProfileModel profile;
}

class ProfileFailure extends ProfileState {
  const ProfileFailure(
    this.message,
  );

  final String message;
}