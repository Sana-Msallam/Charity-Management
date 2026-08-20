import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/profile_model.dart';

class ProfileService {
  Future<ProfileModel> getProfile({
    String? languageCode,
  }) async {
    debugPrint(
      '======================================',
    );
    debugPrint(
      'START GET PROFILE',
    );
    debugPrint(
      '======================================',
    );

    try {
      debugPrint(
        'Sending GET request to: '
        '${ApiConstants.baseUrl}${ApiConstants.profile}',
      );

      final Response<dynamic> response =
          await DioClient.dio.get<dynamic>(
        ApiConstants.profile,
        options: languageCode == null
            ? null
            : Options(
                headers:
                    <String, dynamic>{
                  'accept-language':
                      languageCode == 'ar'
                          ? 'ar'
                          : 'en',
                },
              ),
      );

      debugPrint(
        'Profile response received',
      );

      debugPrint(
        'Status code: ${response.statusCode}',
      );

      debugPrint(
        'Response data: ${response.data}',
      );

      final dynamic data =
          response.data;

      if (data is! Map) {
        debugPrint(
          'Invalid profile response format: $data',
        );

        throw const FormatException();
      }

      final ProfileModel profile =
          ProfileModel.fromJson(
        Map<String, dynamic>.from(
          data,
        ),
      );

      debugPrint(
        'Profile parsed successfully',
      );

      debugPrint(
        'Full name: ${profile.fullName}',
      );

      debugPrint(
        'First name: ${profile.firstName}',
      );

      debugPrint(
        'Last name: ${profile.lastName}',
      );

      debugPrint(
        'Email: ${profile.email}',
      );

      debugPrint(
        'Country code: ${profile.countryCode}',
      );

      debugPrint(
        'Date of birth: ${profile.dateOfBirth}',
      );

      debugPrint(
        'Age: ${profile.age}',
      );

      debugPrint(
        'Social status: ${profile.socialStatus}',
      );

      debugPrint(
        'Address: ${profile.address}',
      );

      debugPrint(
        'Phone number: ${profile.number}',
      );

      debugPrint(
        'Gender: ${profile.gender}',
      );

      debugPrint(
        'Is unemployed: ${profile.isUnemployed}',
      );

      debugPrint(
        'Personal photo: ${profile.personalPhoto}',
      );

      debugPrint(
        '======================================',
      );

      return profile;
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'DIO ERROR WHILE GETTING PROFILE',
      );

      debugPrint(
        'Error type: ${error.type}',
      );

      debugPrint(
        'Error message: ${error.message}',
      );

      debugPrint(
        'Status code: ${error.response?.statusCode}',
      );

      debugPrint(
        'Response data: ${error.response?.data}',
      );

      debugPrint(
        'Request URL: ${error.requestOptions.uri}',
      );

      debugPrint(
        'Request method: ${error.requestOptions.method}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    } on FormatException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'PROFILE FORMAT ERROR',
      );

      debugPrint(
        'Message: ${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'UNEXPECTED PROFILE ERROR',
      );

      debugPrint(
        'Error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String dateOfBirth,
    required String addressAr,
    required String addressEn,
    required String socialStatus,
    required bool isUnemployed,
    XFile? personalPhoto,
  }) async {
    debugPrint(
      '======================================',
    );

    debugPrint(
      'START UPDATE PROFILE',
    );

    debugPrint(
      'PATCH endpoint: ${ApiConstants.profile}',
    );

    try {
      final Map<String, dynamic> fields =
          <String, dynamic>{
        'firstName':
            firstName.trim(),

        'lastName':
            lastName.trim(),

        'email':
            email.trim(),

        'gender':
            gender,

        'dateOfBirth':
            dateOfBirth,

        'address':
            jsonEncode(
          <String, String>{
            'ar':
                addressAr.trim(),
            'en':
                addressEn.trim(),
          },
        ),

        'socialStatus':
            socialStatus,

        'isUnemployed':
            isUnemployed,
      };

      if (personalPhoto != null) {
        fields['personalPhoto'] =
            MultipartFile.fromBytes(
          await personalPhoto.readAsBytes(),
          filename:
              personalPhoto.name,
        );
      }

      debugPrint(
        'Profile PATCH fields: '
        '${fields.keys.toList()}',
      );

      debugPrint(
        'Gender: $gender',
      );

      debugPrint(
        'Social status: $socialStatus',
      );

      debugPrint(
        'Is unemployed: $isUnemployed',
      );

      debugPrint(
        'Has new personal photo: '
        '${personalPhoto != null}',
      );

      final Response<dynamic> response =
          await DioClient.dio.patch<dynamic>(
        ApiConstants.profile,
        data:
            FormData.fromMap(
          fields,
        ),
      );

      debugPrint(
        'Profile PATCH status code: '
        '${response.statusCode}',
      );

      debugPrint(
        'Profile updated successfully',
      );

      debugPrint(
        '======================================',
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'DIO ERROR WHILE UPDATING PROFILE',
      );

      debugPrint(
        'Error type: ${error.type}',
      );

      debugPrint(
        'Error message: ${error.message}',
      );

      debugPrint(
        'Status code: ${error.response?.statusCode}',
      );

      debugPrint(
        'Response data: ${error.response?.data}',
      );

      debugPrint(
        'Request URL: ${error.requestOptions.uri}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'UNEXPECTED PROFILE UPDATE ERROR',
      );

      debugPrint(
        'Error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    }
  }
}