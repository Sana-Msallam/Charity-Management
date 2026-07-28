class ProfileModel {
  final String fullName;
  final int age;
  final String socialStatus;
  final Map<String, dynamic> address;
  final String number;
  final String gender;
  final bool isUnemployed;
  final String? personalPhoto;

  ProfileModel({
    required this.fullName,
    required this.age,
    required this.socialStatus,
    required this.address,
    required this.number,
    required this.gender,
    required this.isUnemployed,
    this.personalPhoto,
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
    );

  }
}