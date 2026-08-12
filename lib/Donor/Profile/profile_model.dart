class ProfileModel {
  final String fullName;


 
  final String gender;
  // final bool isUnemployed;
  // final String? personalPhoto;
  final bool? isSponsor;
  final String? walletBalance;
 final String? totalDonated;
  ProfileModel({
    required this.fullName,
    required this.gender,
    // required this.isUnemployed,
    this.isSponsor,
    this.walletBalance,
    this.totalDonated,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'] ?? '',
     
    
      gender: json['gender'] ?? '',
      // isUnemployed: json['isUnemployed'] ?? false,
      // personalPhoto: json['personalPhoto'],
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
