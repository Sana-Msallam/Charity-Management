class ProfileModel {
  final String fullName;
  final int age;
  final String socialStatus;
  final Map<String, dynamic> address;
  final String number;
  final String gender;
  final bool isUnemployed;
  final String? personalPhoto;
  final bool? isSponsor;
  final String? walletBalance;

  ProfileModel({
    required this.fullName,
    required this.age,
    required this.socialStatus,
    required this.address,
    required this.number,
    required this.gender,
    required this.isUnemployed,
    this.personalPhoto,
    this.isSponsor,
    this.walletBalance,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'] ?? '',
      age: json['age'] ?? 0,
      socialStatus: json['socialStatus'] ?? '',
      address: json['address'] ?? {},
      number: json['number'] ?? '',
      gender: json['gender'] ?? '',
      isUnemployed: json['isUnemployed'] ?? false,
      personalPhoto: json['personalPhoto'],
      isSponsor: _parseBool(json['isSponsor']),
      walletBalance: json['walletBalance']?.toString(),
    );
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return null;
  }
}
