import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/health_request_model.dart';

class HealthRequestService {
  Future<String> submitHealthRequest(HealthRequestModel request) async {
    debugPrint('======================================');
    debugPrint('START SUBMIT HEALTH REQUEST');
    debugPrint('======================================');

    final applicant = request.applicantInfo;

    final String genderApiValue = _mapGender(applicant.gender);

    final String socialStatusApiValue = _mapSocialStatus(
      applicant.socialStatus,
    );

    final String addressJson = jsonEncode({'ar': applicant.address, 'en': ''});

    final String detailsJson = jsonEncode({
      'ar': request.description,
      'en': '',
    });

    debugPrint('Health request values:');
    debugPrint('categoryId: 1');

    debugPrint('firstName: ${applicant.firstName}');

    debugPrint('lastName: ${applicant.lastName}');

    debugPrint('fatherName: ${applicant.fatherName}');

    debugPrint('gender original: ${applicant.gender}');

    debugPrint('gender API value: $genderApiValue');

    debugPrint(
      'socialStatus original: '
      '${applicant.socialStatus}',
    );

    debugPrint(
      'socialStatus API value: '
      '$socialStatusApiValue',
    );

    debugPrint('address: $addressJson');

    debugPrint('age: ${applicant.age}');

    debugPrint('isUnemployed: ${applicant.isUnemployed}');

    debugPrint('number: ${applicant.phoneNumber}');

    debugPrint('details: $detailsJson');

    debugPrint('cost: ${request.cost}');

    debugPrint('typeAid: ${request.typeAid.apiValue}');

    debugPrint('attachments count: ${request.media.length}');

    final FormData formData = FormData();

    formData.fields.addAll([
      const MapEntry('categoryId', '1'),
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
    ]);

    for (final PlatformFile file in request.media) {
      await _addFileToFormData(formData: formData, file: file);
    }

    _printFormData(formData);

    try {
      debugPrint(
        'Sending POST request to: '
        '${ApiConstants.baseUrl}'
        '${ApiConstants.healthRequest}',
      );

      final Response<dynamic> response = await DioClient.dio.post<dynamic>(
        ApiConstants.healthRequest,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      debugPrint('Health request response received');

      debugPrint('Status code: ${response.statusCode}');

      debugPrint('Response data: ${response.data}');

      debugPrint('======================================');

      return _extractSuccessMessage(response.data);
    } on DioException catch (error, stackTrace) {
      debugPrint('DIO ERROR WHILE SUBMITTING HEALTH REQUEST');

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
      debugPrint('UNEXPECTED HEALTH REQUEST ERROR');

      debugPrint('Error: $error');

      debugPrint('Stack trace: $stackTrace');

      debugPrint('======================================');

      rethrow;
    }
  }

  Future<void> _addFileToFormData({
    required FormData formData,
    required PlatformFile file,
  }) async {
    debugPrint('--------------------------------------');

    debugPrint('Checking attachment: ${file.name}');

    debugPrint(
      'Attachment declared size: '
      '${file.size} bytes',
    );

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

      debugPrint('Platform: Web');

      debugPrint('Adding attachment using bytes');

      debugPrint('Attachment name: ${file.name}');

      debugPrint(
        'Attachment bytes size: '
        '${bytes.length} bytes',
      );

      multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);
    } else {
      final String? path = file.path;

      if (path == null || path.trim().isEmpty) {
        debugPrint(
          'Mobile attachment path is missing: '
          '${file.name}',
        );

        throw const FormatException('تعذر الوصول إلى أحد الملفات المرفقة');
      }

      debugPrint('Platform: Mobile or Desktop');

      debugPrint('Adding attachment using path');

      debugPrint('Attachment name: ${file.name}');

      debugPrint('Attachment path: $path');

      multipartFile = await MultipartFile.fromFile(path, filename: file.name);
    }

    formData.files.add(MapEntry('media', multipartFile));

    debugPrint(
      'Attachment added successfully: '
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

    debugPrint('Invalid server response format: $data');

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

    debugPrint('------------- FORM DATA -------------');

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

    debugPrint('-------------------------------------');
  }
}
