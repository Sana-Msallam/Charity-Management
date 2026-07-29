class RegisterDonorRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String number;
  final String countryName;
  final String countryCode;
  final String gender;

  const RegisterDonorRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.number,
    required this.countryName,
    required this.countryCode,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'number': number,
      'countryName': countryName,
      'countryCode': countryCode,
      'gender': gender,
    };
  }
}
