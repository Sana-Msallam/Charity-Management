class RegisterBeneficiaryResponseModel {
  final String message;

  const RegisterBeneficiaryResponseModel({required this.message});

  factory RegisterBeneficiaryResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterBeneficiaryResponseModel(
      message: json['message']?.toString() ?? '',
    );
  }
}
