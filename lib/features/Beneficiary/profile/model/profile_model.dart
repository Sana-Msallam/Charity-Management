class ProfileModel {
  const ProfileModel({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.dateOfBirth,
    required this.age,
    required this.socialStatus,
    required this.address,
    required this.number,
    required this.gender,
    required this.isUnemployed,
    required this.personalPhoto,
  });

  final String fullName;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String? dateOfBirth;
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
    final String firstName =
        json['firstName']?.toString().trim() ?? '';

    final String lastName =
        json['lastName']?.toString().trim() ?? '';

    final String responseFullName =
        json['fullName']?.toString().trim() ?? '';

    final String derivedFullName = [
      firstName,
      lastName,
    ].where(
      (String part) => part.isNotEmpty,
    ).join(' ');

    final String dateOfBirthValue =
        json['dateOfBirth']?.toString().trim() ?? '';

    final String personalPhotoValue =
        json['personalPhoto']?.toString().trim() ?? '';

    return ProfileModel(
      fullName: responseFullName.isNotEmpty
          ? responseFullName
          : derivedFullName,

      firstName: firstName,

      lastName: lastName,

      email:
          json['email']?.toString().trim() ?? '',

      countryCode:
          json['countryCode']?.toString().trim() ?? '',

      dateOfBirth: dateOfBirthValue.isEmpty
          ? null
          : dateOfBirthValue,

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

      personalPhoto: personalPhotoValue.isEmpty
          ? null
          : personalPhotoValue,
    );
  }

  // ==========================================
  // Normalized values
  // ==========================================

  String get normalizedGender {
    return gender
        .trim()
        .toUpperCase();
  }

  String get normalizedSocialStatus {
    return socialStatus
        .trim()
        .toUpperCase();
  }

  // ==========================================
  // Gender helpers
  // ==========================================

  bool get isMale {
    return normalizedGender == 'MALE';
  }

  bool get isFemale {
    return normalizedGender == 'FEMALE';
  }

  // ==========================================
  // Social status helpers
  // ==========================================

  bool get isSingle {
    return normalizedSocialStatus == 'SINGLE';
  }

  bool get isMarried {
    return normalizedSocialStatus == 'MARRIED';
  }

  bool get isWidowed {
    return normalizedSocialStatus == 'WIDOWED';
  }

  bool get isDivorced {
    return normalizedSocialStatus == 'DIVORCED';
  }

  // ==========================================
  // Employment helpers
  // ==========================================

  bool get isEmployed {
    return !isUnemployed;
  }
}