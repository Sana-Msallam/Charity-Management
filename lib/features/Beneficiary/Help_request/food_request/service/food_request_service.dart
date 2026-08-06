import 'dart:convert';
import 'dart:typed_data';

import 'package:charity_management/constants/debug_token.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/food_request_model.dart';

class FoodRequestService {
  Future<String> submitFoodRequest(
    FoodRequestModel request,
  ) async {
    debugPrint('======================================');
    debugPrint('START SUBMIT FOOD REQUEST');
    debugPrint('======================================');

    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    String? accessToken =
        preferences.getString('access_token');
        accessToken ??= DebugToken.token;

    final bool tokenExists =
        accessToken != null &&
        accessToken.trim().isNotEmpty;

    debugPrint('Token exists: $tokenExists');

    if (!tokenExists) {
      debugPrint(
        'Food request stopped: Access token not found',
      );

      throw const FormatException(
        'يرجى تسجيل الدخول قبل إرسال الطلب',
      );
    }

    debugPrint(
      'Token preview: ${_maskToken(accessToken)}',
    );

    final applicant = request.applicantInfo;

    final String genderApiValue =
        _mapGender(applicant.gender);

    final String socialStatusApiValue =
        _mapSocialStatus(
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

    

    debugPrint('Food request values:');
    debugPrint('categoryId: 2');
    debugPrint(
      'firstName: ${applicant.firstName}',
    );
    debugPrint(
      'lastName: ${applicant.lastName}',
    );
    debugPrint(
      'beneficiaryFatherName: ${applicant.fatherName}',
    );
    debugPrint(
      'socialStatus: $socialStatusApiValue',
    );
    debugPrint(
      'address: $addressJson',
    );
    debugPrint(
      'age: ${applicant.age}',
    );
    debugPrint(
      'isUnemployed: ${applicant.isUnemployed}',
    );
    debugPrint(
      'gender: $genderApiValue',
    );
    debugPrint(
      'number: ${applicant.phoneNumber}',
    );
    debugPrint(
      'details: $detailsJson',
    );
    debugPrint(
      'cost: ${request.cost}',
    );
    debugPrint(
      'typeAid: ${request.typeAid.apiValue}',
    );
    debugPrint(
      'numberIndividuals: '
      '${request.numberIndividuals}',
    );
    debugPrint(
      'attachments count: ${request.media.length}',
    );

    final FormData formData = FormData();

    formData.fields.addAll([
      const MapEntry(
        'categoryId',
        '2',
      ),
      MapEntry(
        'firstName',
        applicant.firstName,
      ),
      MapEntry(
        'lastName',
        applicant.lastName,
      ),
      MapEntry(
        'beneficiaryFatherName',
        applicant.fatherName,
      ),
      MapEntry(
        'socialStatus',
        socialStatusApiValue,
      ),
      MapEntry(
        'address',
        addressJson,
      ),
      MapEntry(
        'age',
        applicant.age.toString(),
      ),
      MapEntry(
        'isUnemployed',
        applicant.isUnemployed.toString(),
      ),
      MapEntry(
        'gender',
        genderApiValue,
      ),
      MapEntry(
        'number',
        applicant.phoneNumber,
      ),
      MapEntry(
        'details',
        detailsJson,
      ),
      MapEntry(
        'cost',
        request.cost.toString(),
      ),
      MapEntry(
        'typeAid',
        request.typeAid.apiValue,
      ),
      MapEntry(
        'numberIndividuals',
        request.numberIndividuals.toString(),
      ),
    ]);

    for (final PlatformFile file
        in request.media) {
      await _addFileToFormData(
        formData: formData,
        file: file,
      );
    }

    _printFormData(formData);

    try {
      debugPrint(
        'Sending POST request to: '
        '${ApiConstants.baseUrl}'
        '${ApiConstants.foodRequest}',
      );

      final Response<dynamic> response =
          await DioClient.dio.post<dynamic>(
        ApiConstants.foodRequest,
        data: formData,
        options: Options(
          contentType:
              Headers.multipartFormDataContentType,
          headers: {
            'Authorization':
                'Bearer $accessToken',
          },
        ),
      );

      debugPrint(
        'Food request response received',
      );
      debugPrint(
        'Status code: ${response.statusCode}',
      );
      debugPrint(
        'Response data: ${response.data}',
      );
      debugPrint('======================================');

      return _extractSuccessMessage(
        response.data,
      );
    } on DioException catch (error, stackTrace) {
      debugPrint(
        'DIO ERROR WHILE SUBMITTING FOOD REQUEST',
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
    } catch (error, stackTrace) {
      debugPrint(
        'UNEXPECTED FOOD REQUEST ERROR',
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

  Future<void> _addFileToFormData({
    required FormData formData,
    required PlatformFile file,
  }) async {
    debugPrint('--------------------------------------');
    debugPrint(
      'Checking food attachment: ${file.name}',
    );
    debugPrint(
      'Attachment size: ${file.size} bytes',
    );

    MultipartFile multipartFile;

    if (kIsWeb) {
      final Uint8List? bytes = file.bytes;

      if (bytes == null ||
          bytes.isEmpty) {
        debugPrint(
          'Web attachment bytes are missing: '
          '${file.name}',
        );

        throw const FormatException(
          'تعذر قراءة أحد الملفات المرفقة',
        );
      }

      multipartFile =
          MultipartFile.fromBytes(
        bytes,
        filename: file.name,
      );

      debugPrint(
        'Web attachment added using bytes',
      );
    } else {
      final String? path = file.path;

      if (path == null ||
          path.trim().isEmpty) {
        debugPrint(
          'Mobile attachment path is missing: '
          '${file.name}',
        );

        throw const FormatException(
          'تعذر الوصول إلى أحد الملفات المرفقة',
        );
      }

      multipartFile =
          await MultipartFile.fromFile(
        path,
        filename: file.name,
      );

      debugPrint(
        'Mobile attachment added using path: $path',
      );
    }

    formData.files.add(
      MapEntry(
        'media',
        multipartFile,
      ),
    );

    debugPrint(
      'Food attachment added successfully: '
      '${file.name}',
    );
    debugPrint('--------------------------------------');
  }
  



  String _extractSuccessMessage(
    dynamic data,
  ) {
    if (data is Map) {
      final dynamic message =
          data['message'];

      if (message is String &&
          message.trim().isNotEmpty) {
        return message;
      }
    }

    if (data is String &&
        data.trim().isNotEmpty) {
      return data;
    }

    debugPrint(
      'Invalid food response format: $data',
    );

    throw const FormatException(
      'استجابة الخادم غير صالحة',
    );
  }

  String _mapGender(
    String gender,
  ) {
    switch (gender.trim()) {
      case 'ذكر':
      case 'MALE':
        return 'MALE';

      case 'أنثى':
      case 'انثى':
      case 'FEMALE':
        return 'FEMALE';

      default:
        debugPrint(
          'Unsupported gender value: $gender',
        );

        throw const FormatException(
          'قيمة الجنس غير صحيحة',
        );
    }
  }

  String _mapSocialStatus(
    String socialStatus,
  ) {
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

        throw const FormatException(
          'قيمة الحالة الاجتماعية غير صحيحة',
        );
    }
  }

  void _printFormData(
    FormData formData,
  ) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '------------- FOOD FORM DATA -------------',
    );

    for (final field
        in formData.fields) {
      debugPrint(
        '${field.key}: ${field.value}',
      );
    }

    for (final file
        in formData.files) {
      debugPrint(
        '${file.key}: '
        '${file.value.filename} - '
        '${file.value.length} bytes',
      );
    }

    debugPrint(
      '------------------------------------------',
    );
  }

  String _maskToken(
    String token,
  ) {
    if (token.length <= 12) {
      return '***';
    }

    return '${token.substring(0, 6)}'
        '...'
        '${token.substring(token.length - 6)}';
  }
}