class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String countryCode;
  final String number;
  final String type;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.number,
    required this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      firstName:
          json['firstName']?.toString() ?? json['firstNama']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      type: json['type']?.toString().trim().toUpperCase() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'countryCode': countryCode,
      'number': number,
      'type': type,
    };
  }

  String get fullName => '$firstName $lastName';

  String get fullPhoneNumber => '$countryCode$number';

  bool get isDonor => type == 'DONOR';

  bool get isBeneficiary => type == 'BENEFICIARY';
}
