import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/dio_client.dart';
import '../login/models/login_request_model.dart';
import '../login/models/login_response_model.dart';
import '../register_donor/models/register_donor_request_model.dart';
import '../register_donor/models/register_donor_response_model.dart';
import 'package:flutter/foundation.dart';
import '../otp/models/verify_otp_response_model.dart';

class AuthService {
  final Dio _dio;

  AuthService({
    Dio? dio,
  }) : _dio = dio ?? DioClient.dio;

  Future<LoginResponseModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    final requestModel = LoginRequestModel(
      phoneNumber: phoneNumber,
      password: password,
    );

    final response = await _dio.post(
      ApiConstants.login,
      data: requestModel.toJson(),
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw const FormatException(
        'صيغة استجابة الخادم غير صحيحة',
      );
    }

    final loginResponse = LoginResponseModel.fromJson(responseData);

    if (loginResponse.accessToken.isEmpty) {
      throw const FormatException(
        'لم يتم استلام رمز تسجيل الدخول',
      );
    }

    await _saveLoginData(loginResponse);

    return loginResponse;
  }

  Future<void> _saveLoginData(
    LoginResponseModel response,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      'access_token',
      response.accessToken,
    );

    await preferences.setString(
      'user_type',
      response.user.type,
    );

    await preferences.setInt(
      'user_id',
      response.user.id,
    );

    await preferences.setString(
      'user_data',
      jsonEncode(response.user.toJson()),
    );
    final savedToken = preferences.getString('access_token');
  final savedUserType = preferences.getString('user_type');
  final savedUserId = preferences.getInt('user_id');

  debugPrint('Saved token: $savedToken');
  debugPrint('Saved user type: $savedUserType');
  debugPrint('Saved user id: $savedUserId');
  }
  Future<RegisterDonorResponseModel> registerDonor({
  required RegisterDonorRequestModel request,
}) async {
  final response = await _dio.post(
    ApiConstants.registerDonor,
    data: request.toJson(),
  );

  final data = response.data;

  if (data is Map<String, dynamic>) {
    return RegisterDonorResponseModel.fromJson(data);
  }

  if (data is String) {
    return RegisterDonorResponseModel(
      message: data,
    );
  }

  return const RegisterDonorResponseModel(
    message: 'تم إرسال رمز التحقق بنجاح',
  );
}
Future<VerifyOtpResponseModel> verifyOtp({
  required String countryCode,
  required String phoneNumber,
  required String code,
}) async {
  final response = await _dio.post(
    ApiConstants.verifyOtp,
    data: {
      'countryCode': countryCode,
      'number': phoneNumber,
      'code': code,
    },
  );

  final data = response.data;

  if (data is! Map<String, dynamic>) {
    throw const FormatException(
      'صيغة استجابة الخادم غير صحيحة',
    );
  }

  final result = VerifyOtpResponseModel.fromJson(data);

  if (!result.success) {
    throw Exception(
      result.message.isNotEmpty
          ? result.message
          : 'فشل التحقق من الرمز',
    );
  }

  return result;
}
}