import '../models/register_beneficiary_response_model.dart';

sealed class RegisterBeneficiaryState {
  const RegisterBeneficiaryState();
}

final class RegisterBeneficiaryInitial extends RegisterBeneficiaryState {
  const RegisterBeneficiaryInitial();
}

final class RegisterBeneficiaryLoading extends RegisterBeneficiaryState {
  const RegisterBeneficiaryLoading();
}

final class RegisterBeneficiarySuccess extends RegisterBeneficiaryState {
  final RegisterBeneficiaryResponseModel response;

  const RegisterBeneficiarySuccess(this.response);
}

final class RegisterBeneficiaryFailure extends RegisterBeneficiaryState {
  final String message;

  const RegisterBeneficiaryFailure(this.message);
}
