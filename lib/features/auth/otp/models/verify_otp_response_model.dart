class VerifyOtpResponseModel {
  const VerifyOtpResponseModel({
    required this.success,
    required this.message,
    required this.userId,
  });

  final bool success;
  final String message;
  final int userId;

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      userId: json['userId'] is int
          ? json['userId'] as int
          : int.tryParse(json['userId']?.toString() ?? '') ?? 0,
    );
  }
}
