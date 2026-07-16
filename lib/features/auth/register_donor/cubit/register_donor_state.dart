import '../models/register_donor_response_model.dart';

sealed class RegisterDonorState {
  const RegisterDonorState();
}

final class RegisterDonorInitial extends RegisterDonorState {
  const RegisterDonorInitial();
}

final class RegisterDonorLoading extends RegisterDonorState {
  const RegisterDonorLoading();
}

final class RegisterDonorSuccess extends RegisterDonorState {
  final RegisterDonorResponseModel response;

  const RegisterDonorSuccess(this.response);
}

final class RegisterDonorFailure extends RegisterDonorState {
  final String message;

  const RegisterDonorFailure(this.message);
}