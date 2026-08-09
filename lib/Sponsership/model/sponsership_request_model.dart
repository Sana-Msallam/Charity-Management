class SponsorshipModel {
  final int id;
  final int donorId;
  final String monthlyAmount;
  final String status;
  final int? orphanId;
  final int? employeeId;
  final String requiredWalletBalance;
  final String walletBalance;
  final DateTime createdAt;

  SponsorshipModel({
    required this.id,
    required this.donorId,
    required this.monthlyAmount,
    required this.status,
    this.orphanId,
    this.employeeId,
    required this.requiredWalletBalance,
    required this.walletBalance,
    required this.createdAt,
  });

  factory SponsorshipModel.fromJson(Map<String, dynamic> json) {
    return SponsorshipModel(
      id: json['id'],
      donorId: json['donorId'],
      monthlyAmount: json['monthlyAmount'],
      status: json['status'],
      orphanId: json['orphanId'],
      employeeId: json['employeeId'],
      requiredWalletBalance: json['requiredWalletBalance'],
      walletBalance: json['walletBalance'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class CreateSponsorshipResponse {
  final bool success;
  final String message;
  final int id;

  CreateSponsorshipResponse({
    required this.success,
    required this.message,
    required this.id,
  });

  factory CreateSponsorshipResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateSponsorshipResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      id: json['data']['id'],
    );
  }
}