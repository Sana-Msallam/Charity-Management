import 'dart:convert';
import 'dart:typed_data';

import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/model/small_project_request_model.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class SmallProjectRequestService {
  Future<String> submitSmallProjectRequest(
    SmallProjectRequestModel request,
  ) async {
    debugPrint('======================================');
    debugPrint('START SUBMIT SMALL PROJECT REQUEST');
    debugPrint('======================================');

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

    final String projectNameJson = jsonEncode({
      'ar': request.projectNameAr.trim(),
      'en': request.projectNameEn.trim(),
    });

    final String projectCategoryJson = jsonEncode({
      'ar': request.projectCategoryAr.trim(),
      'en': request.projectCategoryEn.trim(),
    });

    debugPrint('Small project request values:');
    debugPrint('categoryId: 5');
    debugPrint('firstName: ${applicant.firstName}');
    debugPrint('lastName: ${applicant.lastName}');
    debugPrint('beneficiaryFatherName: ${applicant.fatherName}');
    debugPrint('socialStatus: $socialStatusApiValue');
    debugPrint('addressAr: ${applicant.addressAr}');
    debugPrint('addressEn: ${applicant.addressEn}');
    debugPrint('address JSON: $addressJson');
    debugPrint('age: ${applicant.age}');
    debugPrint('isUnemployed: ${applicant.isUnemployed}');
    debugPrint('gender: $genderApiValue');
    debugPrint('number: ${applicant.phoneNumber}');
    debugPrint('detailsAr: ${request.detailsAr}');
    debugPrint('detailsEn: ${request.detailsEn}');
    debugPrint('details JSON: $detailsJson');
    debugPrint('cost: ${request.cost}');
    debugPrint('projectNameAr: ${request.projectNameAr}');
    debugPrint('projectNameEn: ${request.projectNameEn}');
    debugPrint('projectName JSON: $projectNameJson');
    debugPrint('projectCategoryAr: ${request.projectCategoryAr}');
    debugPrint('projectCategoryEn: ${request.projectCategoryEn}');
    debugPrint('projectCategory JSON: $projectCategoryJson');
    debugPrint(
      'numberOfPeopleSupported: '
      '${request.numberOfPeopleSupported}',
    );
    debugPrint('attachments count: ${request.media.length}');

    final FormData formData = await _buildSmallProjectFormData(
      request: request,
      includeCategoryId: true,
    );

    _printFormData(formData);

    try {
      debugPrint(
        'Sending POST request to: '
        '${ApiConstants.baseUrl}'
        '${ApiConstants.smallProjectRequest}',
      );

      final Response<dynamic> response = await DioClient.dio.post<dynamic>(
        ApiConstants.smallProjectRequest,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      debugPrint('Small project response received');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');
      debugPrint('======================================');

      return _extractSuccessMessage(response.data);
    } on DioException catch (error, stackTrace) {
      debugPrint('DIO ERROR WHILE SUBMITTING SMALL PROJECT REQUEST');
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
      debugPrint('UNEXPECTED SMALL PROJECT REQUEST ERROR');
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');

      rethrow;
    }
  }

  Future<String> updateSmallProjectRequest({
    required int requestId,
    required SmallProjectRequestModel request,
  }) async {
    debugPrint('======================================');
    debugPrint('START UPDATE SMALL PROJECT REQUEST');
    debugPrint('Request id: $requestId');
    debugPrint('======================================');

    final FormData formData = await _buildSmallProjectFormData(
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
          headers: const {'accept-language': 'ar'},
        ),
      );

      debugPrint('Small project update response received');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');
      debugPrint('======================================');

      return _extractSuccessMessage(response.data);
    } on DioException catch (error, stackTrace) {
      debugPrint('DIO ERROR WHILE UPDATING SMALL PROJECT REQUEST');
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
      debugPrint('UNEXPECTED SMALL PROJECT UPDATE ERROR');
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');
      rethrow;
    }
  }

  Future<FormData> _buildSmallProjectFormData({
    required SmallProjectRequestModel request,
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

    final String projectNameJson = jsonEncode({
      'ar': request.projectNameAr.trim(),
      'en': request.projectNameEn.trim(),
    });

    final String projectCategoryJson = jsonEncode({
      'ar': request.projectCategoryAr.trim(),
      'en': request.projectCategoryEn.trim(),
    });

    final FormData formData = FormData();

    if (includeCategoryId) {
      formData.fields.add(const MapEntry('categoryId', '5'));
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
      MapEntry('projectName', projectNameJson),
      MapEntry('projectCategory', projectCategoryJson),
      MapEntry(
        'numberOfPeopleSupported',
        request.numberOfPeopleSupported.toString(),
      ),
    ]);

    for (final PlatformFile file in request.media) {
      await _addFileToFormData(formData: formData, file: file);
    }

    return formData;
  }

  Future<void> _addFileToFormData({
    required FormData formData,
    required PlatformFile file,
  }) async {
    debugPrint('--------------------------------------');
    debugPrint('Checking small project attachment: ${file.name}');
    debugPrint('Attachment size: ${file.size} bytes');

    MultipartFile multipartFile;

    if (kIsWeb) {
      final Uint8List? bytes = file.bytes;

      if (bytes == null || bytes.isEmpty) {
        debugPrint('Web attachment bytes are missing: ${file.name}');

        throw const FormatException('تعذر قراءة أحد الملفات المرفقة');
      }

      multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);

      debugPrint('Web attachment added using bytes');
    } else {
      final String? path = file.path;

      if (path == null || path.trim().isEmpty) {
        debugPrint('Mobile attachment path is missing: ${file.name}');

        throw const FormatException('تعذر الوصول إلى أحد الملفات المرفقة');
      }

      multipartFile = await MultipartFile.fromFile(path, filename: file.name);

      debugPrint('Mobile attachment added using path: $path');
    }

    formData.files.add(MapEntry('media', multipartFile));

    debugPrint(
      'Small project attachment added successfully: '
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

    debugPrint('Invalid small project response format: $data');

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
        debugPrint('Unsupported social status value: $socialStatus');

        throw const FormatException('قيمة الحالة الاجتماعية غير صحيحة');
    }
  }

  void _printFormData(FormData formData) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('------- SMALL PROJECT FORM DATA -------');

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

    debugPrint('---------------------------------------');
  }
}
