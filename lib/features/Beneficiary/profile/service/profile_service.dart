import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/profile_model.dart';

class ProfileService {
  Future<ProfileModel> getProfile() async {
    debugPrint('======================================');
    debugPrint('START GET PROFILE');
    debugPrint('======================================');

    try {
      debugPrint(
        'Sending GET request to: '
        '${ApiConstants.baseUrl}${ApiConstants.profile}',
      );

      final Response<dynamic> response =
          await DioClient.dio.get<dynamic>(
        ApiConstants.profile,
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

      final dynamic data = response.data;

      if (data is! Map) {
        debugPrint(
          'Invalid profile response format: $data',
        );

        throw const FormatException(
          'استجابة الملف الشخصي غير صالحة',
        );
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

      debugPrint('======================================');

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

      debugPrint('======================================');

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

      debugPrint('======================================');

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

      debugPrint('======================================');

      rethrow;
    }
  }
}