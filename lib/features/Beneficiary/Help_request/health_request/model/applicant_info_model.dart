class ApplicantInfoModel {
  const ApplicantInfoModel({
    required this.firstName,
    required this.fatherName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.socialStatus,
    required this.phoneNumber,
    required this.address,
    required this.isUnemployed,
  });

  final String firstName;
  final String fatherName;
  final String lastName;
  final int age;
  final String gender;
  final String socialStatus;
  final String phoneNumber;
  final String address;
  final bool isUnemployed;
}
