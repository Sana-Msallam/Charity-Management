import 'package:dio/dio.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/dio_client.dart';
import '../login/models/login_request_model.dart';
import '../login/models/login_response_model.dart';
import '../register_donor/models/register_donor_request_model.dart';
import '../register_donor/models/register_donor_response_model.dart';
import '../otp/models/verify_otp_response_model.dart';
import '../register_beneficiary/models/register_beneficiary_request_model.dart';
import '../register_beneficiary/models/register_beneficiary_response_model.dart';
import '../storage/auth_local_storage.dart';

class AuthService {
  final Dio _dio;
  final AuthLocalStorage _localStorage;

  AuthService({Dio? dio, AuthLocalStorage? localStorage})
    : _dio = dio ?? DioClient.dio,
      _localStorage = localStorage ?? AuthLocalStorage();

  Future<LoginResponseModel> login({
    required String phoneNumber,
    required String password,
    required String invalidResponseMessage,
    required String missingTokenMessage,
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
      throw FormatException(invalidResponseMessage);
    }

    final loginResponse = LoginResponseModel.fromJson(responseData);

    if (loginResponse.accessToken.isEmpty) {
      throw FormatException(missingTokenMessage);
    }

    if (!AuthLocalStorage.isSupportedUserType(loginResponse.user.type)) {
      throw FormatException(invalidResponseMessage);
    }

    await _localStorage.saveSession(
      token: loginResponse.accessToken,
      userType: loginResponse.user.type,
    );

    return loginResponse;
  }

  Future<RegisterDonorResponseModel> registerDonor({
    required RegisterDonorRequestModel request,
    required String fallbackMessage,
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
      return RegisterDonorResponseModel(message: data);
    }

    return RegisterDonorResponseModel(message: fallbackMessage);
  }

  Future<VerifyOtpResponseModel> verifyOtp({
    required String countryCode,
    required String phoneNumber,
    required String code,
    required String invalidResponseMessage,
    required String verificationFailedMessage,
  }) async {
    final response = await _dio.post(
      ApiConstants.verifyOtp,
      data: {'countryCode': countryCode, 'number': phoneNumber, 'code': code},
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw FormatException(invalidResponseMessage);
    }

    final result = VerifyOtpResponseModel.fromJson(data);

    if (!result.success) {
      throw Exception(
        result.message.isNotEmpty ? result.message : verificationFailedMessage,
      );
    }

    return result;
  }

  Future<RegisterBeneficiaryResponseModel> registerBeneficiary({
    required RegisterBeneficiaryRequestModel request,
    required String fallbackMessage,
  }) async {
    final formData = await request.toFormData();

    final response = await _dio.post(
      ApiConstants.registerBeneficiary,
      data: formData,
      options: Options(
        contentType: Headers.multipartFormDataContentType,
        headers: {'Accept': 'application/json'},
      ),
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return RegisterBeneficiaryResponseModel.fromJson(data);
    }

    if (data is String) {
      return RegisterBeneficiaryResponseModel(message: data);
    }

    return RegisterBeneficiaryResponseModel(message: fallbackMessage);
  }

  Future<String> requestPasswordResetOtp({
    required String phoneNumber,
    required String fallbackMessage,
  }) async {
    final response = await _dio.post(
      ApiConstants.requestPasswordResetOtp,
      data: {'phoneNumber': phoneNumber},
    );

    return _extractMessage(response.data, fallbackMessage);
  }

  Future<String> resetPassword({
    required String code,
    required String newPassword,
    required String fallbackMessage,
  }) async {
    final response = await _dio.post(
      ApiConstants.resetPassword,
      data: {'code': code, 'newPassword': newPassword},
    );

    return _extractMessage(response.data, fallbackMessage);
  }

  String _extractMessage(dynamic data, String fallbackMessage) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return fallbackMessage;
  }
  Future<void> logout() async {
  try {
    await _dio.post(
      ApiConstants.logout,
    );
  } finally {
    await _localStorage.deleteSession();
  }
}
}
