import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:convert';

class RegisterBeneficiaryRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String number;
  final String countryName;
  final String countryCode;
  final String gender;

  final File personalPhoto;
  final File familyStatement;

  final String address;
  final String socialStatus;
  final bool isUnemployed;
  final double monthlyIncome;
  final int numberOfChildren;

  const RegisterBeneficiaryRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.number,
    required this.countryName,
    required this.countryCode,
    required this.gender,
    required this.personalPhoto,
    required this.familyStatement,
    required this.address,
    required this.socialStatus,
    required this.isUnemployed,
    required this.monthlyIncome,
    required this.numberOfChildren,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'number': number,
      'countryName': countryName,
      'countryCode': countryCode,
      'gender': gender,

      'personalPhoto': await MultipartFile.fromFile(personalPhoto.path),

      'familyStatement': await MultipartFile.fromFile(familyStatement.path),

      'address': jsonEncode({'area': address}),
      'socialStatus': socialStatus,
      'isUnemployed': isUnemployed,
      'monthlyIncome': monthlyIncome,
      'numberOfChildren': numberOfChildren,
    });
  }
}
