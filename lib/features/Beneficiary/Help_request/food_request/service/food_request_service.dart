import 'dart:convert';
import 'dart:typed_data';

import 'package:charity_management/features/auth/storage/auth_local_storage.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/food_request_model.dart';

class FoodRequestService {
  Future<String> submitFoodRequest(FoodRequestModel request) async {
    debugPrint('======================================');
    debugPrint('START SUBMIT FOOD REQUEST');
    debugPrint('======================================');

    final String accessToken = await _getAccessToken();

    final FormData formData = await _buildFoodFormData(
      request: request,
      includeCategoryId: true,
    );

    _printFormData(formData);

    try {
      debugPrint(
        'Sending POST request to: '
        '${ApiConstants.baseUrl}'
        '${ApiConstants.foodRequest}',
      );

      final Response<dynamic> response = await DioClient.dio.post<dynamic>(
        ApiConstants.foodRequest,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      debugPrint('Food request response received');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');
      debugPrint('======================================');

      return _extractSuccessMessage(response.data);
    } on DioException catch (error, stackTrace) {
      debugPrint('DIO ERROR WHILE SUBMITTING FOOD REQUEST');
      debugPrint('Error type: ${error.type}');
      debugPrint('Error message: ${error.message}');
      debugPrint('Status code: ${error.response?.statusCode}');
      debugPrint('Response data: ${error.response?.data}');
      debugPrint('Request URL: ${error.requestOptions.uri}');
      debugPrint('Request method: ${error.requestOptions.method}');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');

      rethrow;
    } catch (error, stackTrace) {
      debugPrint('UNEXPECTED FOOD REQUEST ERROR');
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');

      rethrow;
    }
  }

  Future<String> updateFoodRequest({
    required int requestId,
    required FoodRequestModel request,
  }) async {
    debugPrint('======================================');
    debugPrint('START UPDATE FOOD REQUEST');
    debugPrint('Request id: $requestId');
    debugPrint('======================================');

    final String accessToken = await _getAccessToken();

    final FormData formData = await _buildFoodFormData(
      request: request,
      includeCategoryId: false,
    );

    _printFormData(formData);

    final String endpoint = '/requests/$requestId';

    try {
      debugPrint('Sending PATCH request to: ${ApiConstants.baseUrl}$endpoint');

      final Response<dynamic> response = await DioClient.dio.patch<dynamic>(
        endpoint,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'accept-language': 'ar',
          },
        ),
      );

      debugPrint('Food update response received');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');
      debugPrint('======================================');

      return _extractSuccessMessage(response.data);
    } on DioException catch (error, stackTrace) {
      debugPrint('DIO ERROR WHILE UPDATING FOOD REQUEST');
      debugPrint('Error type: ${error.type}');
      debugPrint('Error message: ${error.message}');
      debugPrint('Status code: ${error.response?.statusCode}');
      debugPrint('Response data: ${error.response?.data}');
      debugPrint('Request URL: ${error.requestOptions.uri}');
      debugPrint('Request method: ${error.requestOptions.method}');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('UNEXPECTED FOOD UPDATE ERROR');
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');
      rethrow;
    }
  }

  Future<FormData> _buildFoodFormData({
    required FoodRequestModel request,
    required bool includeCategoryId,
  }) async {
    final applicant = request.applicantInfo;

    final String genderApiValue = _mapGender(applicant.gender);
    final String socialStatusApiValue = _mapSocialStatus(
      applicant.socialStatus,
    );

    final String addressJson = jsonEncode({
      'ar': applicant.addressAr.trim(),
      'en': applicant.addressEn.trim(),
    });

    final String detailsJson = jsonEncode({
      'ar': request.detailsAr.trim(),
      'en': request.detailsEn.trim(),
    });

    final FormData formData = FormData();

    if (includeCategoryId) {
      formData.fields.add(const MapEntry('categoryId', '2'));
    }

    formData.fields.addAll([
      MapEntry('firstName', applicant.firstName),
      MapEntry('lastName', applicant.lastName),
      MapEntry('beneficiaryFatherName', applicant.fatherName),
      MapEntry('socialStatus', socialStatusApiValue),
      MapEntry('address', addressJson),
      MapEntry('age', applicant.age.toString()),
      MapEntry('isUnemployed', applicant.isUnemployed.toString()),
      MapEntry('gender', genderApiValue),
      MapEntry('number', applicant.phoneNumber),
      MapEntry('details', detailsJson),
      MapEntry('cost', request.cost.toString()),
      MapEntry('typeAid', request.typeAid.apiValue),
      MapEntry('numberIndividuals', request.numberIndividuals.toString()),
    ]);

    for (final PlatformFile file in request.media) {
      await _addFileToFormData(formData: formData, file: file);
    }

    return formData;
  }

  Future<String> _getAccessToken() async {
    final AuthLocalStorage authLocalStorage = AuthLocalStorage();
    final String? accessToken = await authLocalStorage.getToken();
    final bool tokenExists =
        accessToken != null && accessToken.trim().isNotEmpty;

    debugPrint('Token exists: $tokenExists');

    if (!tokenExists) {
      debugPrint('Food request stopped: Access token not found');

      throw const FormatException('يرجى تسجيل الدخول قبل إرسال الطلب');
    }

    debugPrint('Token preview: ${_maskToken(accessToken)}');

    return accessToken;
  }

  Future<void> _addFileToFormData({
    required FormData formData,
    required PlatformFile file,
  }) async {
    debugPrint('--------------------------------------');
    debugPrint('Checking food attachment: ${file.name}');
    debugPrint('Attachment size: ${file.size} bytes');

    MultipartFile multipartFile;

    if (kIsWeb) {
      final Uint8List? bytes = file.bytes;

      if (bytes == null || bytes.isEmpty) {
        debugPrint(
          'Web attachment bytes are missing: '
          '${file.name}',
        );

        throw const FormatException('تعذر قراءة أحد الملفات المرفقة');
      }

      multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);

      debugPrint('Web attachment added using bytes');
    } else {
      final String? path = file.path;

      if (path == null || path.trim().isEmpty) {
        debugPrint(
          'Mobile attachment path is missing: '
          '${file.name}',
        );

        throw const FormatException('تعذر الوصول إلى أحد الملفات المرفقة');
      }

      multipartFile = await MultipartFile.fromFile(path, filename: file.name);

      debugPrint('Mobile attachment added using path: $path');
    }

    formData.files.add(MapEntry('media', multipartFile));

    debugPrint(
      'Food attachment added successfully: '
      '${file.name}',
    );
    debugPrint('--------------------------------------');
  }

  String _extractSuccessMessage(dynamic data) {
    if (data is Map) {
      final dynamic message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    debugPrint('Invalid food response format: $data');

    throw const FormatException('استجابة الخادم غير صالحة');
  }

  String _mapGender(String gender) {
    switch (gender.trim()) {
      case 'ذكر':
      case 'MALE':
        return 'MALE';

      case 'أنثى':
      case 'انثى':
      case 'FEMALE':
        return 'FEMALE';

      default:
        debugPrint('Unsupported gender value: $gender');

        throw const FormatException('قيمة الجنس غير صحيحة');
    }
  }

  String _mapSocialStatus(String socialStatus) {
    switch (socialStatus.trim()) {
      case 'أعزب':
      case 'عازب':
      case 'SINGLE':
        return 'SINGLE';

      case 'متزوج':
      case 'متزوجة':
      case 'MARRIED':
        return 'MARRIED';

      case 'أرمل':
      case 'أرملة':
      case 'WIDOWED':
        return 'WIDOWED';

      case 'مطلق':
      case 'مطلقة':
      case 'DIVORCED':
        return 'DIVORCED';

      default:
        debugPrint(
          'Unsupported social status value: '
          '$socialStatus',
        );

        throw const FormatException('قيمة الحالة الاجتماعية غير صحيحة');
    }
  }

  void _printFormData(FormData formData) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('------------- FOOD FORM DATA -------------');

    for (final field in formData.fields) {
      debugPrint('${field.key}: ${field.value}');
    }

    for (final file in formData.files) {
      debugPrint(
        '${file.key}: '
        '${file.value.filename} - '
        '${file.value.length} bytes',
      );
    }

    debugPrint('------------------------------------------');
  }

  String _maskToken(String token) {
    if (token.length <= 12) {
      return '***';
    }

    return '${token.substring(0, 6)}'
        '...'
        '${token.substring(token.length - 6)}';
  }
}
