class RegisterDonorResponseModel {
  final String message;

  const RegisterDonorResponseModel({
    required this.message,
  });

  factory RegisterDonorResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegisterDonorResponseModel(
      message: json['message']?.toString() ?? '',
    );
  }
}