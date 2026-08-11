class ProfileModel {
  const ProfileModel({
    required this.fullName,
    required this.age,
    required this.socialStatus,
    required this.address,
    required this.number,
    required this.gender,
    required this.isUnemployed,
    required this.personalPhoto,
  });

  final String fullName;

  final int? age;

  final String socialStatus;

  final String address;

  final String number;

  final String gender;

  final bool isUnemployed;

  final String? personalPhoto;

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      fullName:
          json['fullName']?.toString() ?? '',

      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(
              json['age']?.toString() ?? '',
            ),

      socialStatus:
          json['socialStatus']?.toString() ?? '',

      address:
          json['address']?.toString() ?? '',

      number:
          json['number']?.toString() ?? '',

      gender:
          json['gender']?.toString() ?? '',

      isUnemployed:
          json['isUnemployed'] == true,

      personalPhoto:
          json['personalPhoto']?.toString(),
    );
  }

  String get genderArabic {
    switch (gender) {
      case 'MALE':
        return 'ذكر';

      case 'FEMALE':
        return 'أنثى';

      default:
        return gender;
    }
  }

  String get socialStatusArabic {
    switch (socialStatus) {
      case 'SINGLE':
        return 'أعزب';

      case 'MARRIED':
        return 'متزوج';

      case 'WIDOWED':
        return 'أرمل';

      case 'DIVORCED':
        return 'مطلق';

      default:
        return socialStatus;
    }
  }

  String get employmentStatusArabic {
    return isUnemployed
        ? 'عاطل عن العمل'
        : 'يعمل';
  }
}