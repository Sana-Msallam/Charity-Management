class ProfileModel {
  final String fullName;
  final String email;
  final String number;
  final String countryCode;
  final String gender;
  final bool isSponsor;
  final int totalDonated;
  final int walletBalance;

  ProfileModel({
    required this.fullName,
    required this.email,
    required this.number,
    required this.countryCode,
    required this.gender,
    required this.isSponsor,
    required this.totalDonated,
    required this.walletBalance,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
      countryCode: json['countryCode'] ?? '',
      gender: json['gender'] ?? '',
      isSponsor: json['isSponsor'] ?? false,
      totalDonated: json['totalDonated'] ?? 0,
      walletBalance: json['walletBalance'] ?? 0,
    );
  }
}