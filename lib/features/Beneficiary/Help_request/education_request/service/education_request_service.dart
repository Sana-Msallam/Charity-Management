import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/education_request_model.dart';

class EducationRequestService {
  Future<String> submitEducationRequest(
    EducationRequestModel request,
  ) async {
    debugPrint('======================================');
    debugPrint('START SUBMIT EDUCATION REQUEST');
    debugPrint('======================================');

    final applicant = request.applicantInfo;

    final String genderApiValue = _mapGender(
      applicant.gender,
    );

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

    final String institutionNameJson = jsonEncode({
      'ar': request.institutionNameAr.trim(),
      'en': request.institutionNameEn.trim(),
    });

    debugPrint('Education request values:');

    debugPrint('categoryId: 4');

    debugPrint(
      'firstName: ${applicant.firstName}',
    );

    debugPrint(
      'lastName: ${applicant.lastName}',
    );

    debugPrint(
      'fatherName: ${applicant.fatherName}',
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
      'academicAchievement: '
      '${request.academicAchievement.apiValue}',
    );

    debugPrint(
      'institutionName: $institutionNameJson',
    );

    debugPrint(
      'year: ${request.year}',
    );

    debugPrint(
      'attachments count: ${request.media.length}',
    );

    final FormData formData = FormData();

    formData.fields.addAll([
      const MapEntry(
        'categoryId',
        '4',
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
        'academicAchievement',
        request.academicAchievement.apiValue,
      ),
      MapEntry(
        'institutionName',
        institutionNameJson,
      ),
      MapEntry(
        'year',
        request.year,
      ),
    ]);

    for (final PlatformFile file in request.media) {
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
        '${ApiConstants.educationRequest}',
      );

      final Response<dynamic> response =
          await DioClient.dio.post<dynamic>(
        ApiConstants.educationRequest,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      debugPrint('Education response received');

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
        'DIO ERROR WHILE SUBMITTING EDUCATION REQUEST',
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
        'UNEXPECTED EDUCATION REQUEST ERROR',
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
      'Checking attachment: ${file.name}',
    );

    debugPrint(
      'Attachment size: ${file.size} bytes',
    );

    MultipartFile multipartFile;

    if (kIsWeb) {
      final Uint8List? bytes = file.bytes;

      if (bytes == null || bytes.isEmpty) {
        debugPrint(
          'Web attachment bytes missing: ${file.name}',
        );

        throw const FormatException(
          'تعذر قراءة أحد الملفات المرفقة',
        );
      }

      multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: file.name,
      );

      debugPrint(
        'Web attachment added using bytes',
      );
    } else {
      final String? path = file.path;

      if (path == null || path.trim().isEmpty) {
        debugPrint(
          'Mobile attachment path missing: ${file.name}',
        );

        throw const FormatException(
          'تعذر الوصول إلى أحد الملفات المرفقة',
        );
      }

      multipartFile = await MultipartFile.fromFile(
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
      'Attachment added successfully: ${file.name}',
    );

    debugPrint('--------------------------------------');
  }

  String _extractSuccessMessage(
    dynamic data,
  ) {
    if (data is Map) {
      final dynamic message = data['message'];

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
      'Invalid education response format: $data',
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
          'Unsupported social status value: $socialStatus',
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
      '--------- EDUCATION FORM DATA ---------',
    );

    for (final field in formData.fields) {
      debugPrint(
        '${field.key}: ${field.value}',
      );
    }

    for (final file in formData.files) {
      debugPrint(
        '${file.key}: '
        '${file.value.filename} - '
        '${file.value.length} bytes',
      );
    }

    debugPrint(
      '---------------------------------------',
    );
  }
}