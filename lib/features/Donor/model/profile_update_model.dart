class ProfileUpdateModel {
 final String firstName;
final String lastName;
  final String email;
  final String countryCode;
  final String number;
  final String gender;

  const ProfileUpdateModel({
    required this.firstName ,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.number,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'countryCode': countryCode,
      'number': number,
      'gender': gender,
    };
  }
}