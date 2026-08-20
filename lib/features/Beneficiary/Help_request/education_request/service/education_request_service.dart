import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/education_request_model.dart';

class EducationRequestService {
  // =================================================
  // CREATE
  // =================================================

  Future<String> submitEducationRequest(
    EducationRequestModel request,
  ) async {
    debugPrint(
      '======================================',
    );

    debugPrint(
      'START SUBMIT EDUCATION REQUEST',
    );

    debugPrint(
      '======================================',
    );

    try {
      final FormData formData =
          await _buildEducationFormData(
        request: request,
        includeCategoryId: true,
      );

      _printFormData(
        formData,
      );

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
          contentType:
              Headers
                  .multipartFormDataContentType,
        ),
      );

      debugPrint(
        'Education response received',
      );

      debugPrint(
        'Status code: '
        '${response.statusCode}',
      );

      debugPrint(
        'Response data: '
        '${response.data}',
      );

      debugPrint(
        '======================================',
      );

      return _extractSuccessMessage(
        response.data,
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      _printDioError(
        title:
            'DIO ERROR WHILE SUBMITTING EDUCATION REQUEST',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'UNEXPECTED EDUCATION REQUEST ERROR',
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

  // =================================================
  // UPDATE
  // =================================================

  Future<String> updateEducationRequest({
    required int requestId,
    required EducationRequestModel request,
  }) async {
    debugPrint(
      '======================================',
    );

    debugPrint(
      'START UPDATE EDUCATION REQUEST',
    );

    debugPrint(
      'Request id: $requestId',
    );

    debugPrint(
      '======================================',
    );

    try {
      final FormData formData =
          await _buildEducationFormData(
        request: request,

        // بالـ PATCH نوع الطلب موجود أصلاً.
        includeCategoryId: false,
      );

      _printFormData(
        formData,
      );

      final String endpoint =
          '/requests/$requestId';

      debugPrint(
        'Sending PATCH request to: '
        '${ApiConstants.baseUrl}'
        '$endpoint',
      );

      final Response<dynamic> response =
          await DioClient.dio.patch<dynamic>(
        endpoint,
        data: formData,
        options: Options(
          contentType:
              Headers
                  .multipartFormDataContentType,
          headers: {
            'accept-language': 'ar',
          },
        ),
      );

      debugPrint(
        'Education update response received',
      );

      debugPrint(
        'Status code: '
        '${response.statusCode}',
      );

      debugPrint(
        'Response data: '
        '${response.data}',
      );

      debugPrint(
        '======================================',
      );

      return _extractSuccessMessage(
        response.data,
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      _printDioError(
        title:
            'DIO ERROR WHILE UPDATING EDUCATION REQUEST',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'UNEXPECTED EDUCATION UPDATE ERROR',
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

  // =================================================
  // BUILD FORM DATA
  // =================================================

  Future<FormData> _buildEducationFormData({
    required EducationRequestModel request,
    required bool includeCategoryId,
  }) async {
    final applicant =
        request.applicantInfo;

    final String genderApiValue =
        _mapGender(
      applicant.gender,
    );

    final String socialStatusApiValue =
        _mapSocialStatus(
      applicant.socialStatus,
    );

    final String addressJson =
        jsonEncode(
      {
        'ar':
            applicant.addressAr.trim(),
        'en':
            applicant.addressEn.trim(),
      },
    );

    final String detailsJson =
        jsonEncode(
      {
        'ar':
            request.detailsAr.trim(),
        'en':
            request.detailsEn.trim(),
      },
    );

    final String institutionNameJson =
        jsonEncode(
      {
        'ar':
            request.institutionNameAr
                .trim(),
        'en':
            request.institutionNameEn
                .trim(),
      },
    );

    final FormData formData =
        FormData();

    if (includeCategoryId) {
      formData.fields.add(
        const MapEntry(
          'categoryId',
          '4',
        ),
      );
    }

    formData.fields.addAll(
      [
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
          request
              .academicAchievement
              .apiValue,
        ),

        MapEntry(
          'institutionName',
          institutionNameJson,
        ),

        MapEntry(
          'year',
          request.year,
        ),
      ],
    );

    // إذا المستخدم اختار ملفات جديدة فقط
    // منضيف media.
    //
    // في Edit Mode وإذا ما اختار ملفات جديدة،
    // ما منرسل media إطلاقاً.
    for (final PlatformFile file
        in request.media) {
      await _addFileToFormData(
        formData: formData,
        file: file,
      );
    }

    return formData;
  }

  // =================================================
  // ADD FILE
  // =================================================

  Future<void> _addFileToFormData({
    required FormData formData,
    required PlatformFile file,
  }) async {
    debugPrint(
      '--------------------------------------',
    );

    debugPrint(
      'Checking attachment: '
      '${file.name}',
    );

    debugPrint(
      'Attachment size: '
      '${file.size} bytes',
    );

    MultipartFile multipartFile;

    if (kIsWeb) {
      final Uint8List? bytes =
          file.bytes;

      if (bytes == null ||
          bytes.isEmpty) {
        debugPrint(
          'Web attachment bytes missing: '
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
      final String? path =
          file.path;

      if (path == null ||
          path.trim().isEmpty) {
        debugPrint(
          'Mobile attachment path missing: '
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
        'Mobile attachment added using path: '
        '$path',
      );
    }

    formData.files.add(
      MapEntry(
        'media',
        multipartFile,
      ),
    );

    debugPrint(
      'Attachment added successfully: '
      '${file.name}',
    );

    debugPrint(
      '--------------------------------------',
    );
  }

  // =================================================
  // SUCCESS MESSAGE
  // =================================================

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
      'Invalid education response format: '
      '$data',
    );

    throw const FormatException(
      'استجابة الخادم غير صالحة',
    );
  }

  // =================================================
  // GENDER
  // =================================================

  String _mapGender(
    String gender,
  ) {
    switch (
        gender.trim().toUpperCase()) {
      case 'ذكر':
      case 'MALE':
        return 'MALE';

      case 'أنثى':
      case 'انثى':
      case 'FEMALE':
        return 'FEMALE';

      default:
        debugPrint(
          'Unsupported gender value: '
          '$gender',
        );

        throw const FormatException(
          'قيمة الجنس غير صحيحة',
        );
    }
  }

  // =================================================
  // SOCIAL STATUS
  // =================================================

  String _mapSocialStatus(
    String socialStatus,
  ) {
    switch (
        socialStatus.trim().toUpperCase()) {
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

  // =================================================
  // PRINT FORM DATA
  // =================================================

  void _printFormData(
    FormData formData,
  ) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '--------- EDUCATION FORM DATA ---------',
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
      '---------------------------------------',
    );
  }

  // =================================================
  // PRINT DIO ERROR
  // =================================================

  void _printDioError({
    required String title,
    required DioException error,
    required StackTrace stackTrace,
  }) {
    debugPrint(
      title,
    );

    debugPrint(
      'Error type: ${error.type}',
    );

    debugPrint(
      'Error message: ${error.message}',
    );

    debugPrint(
      'Status code: '
      '${error.response?.statusCode}',
    );

    debugPrint(
      'Response data: '
      '${error.response?.data}',
    );

    debugPrint(
      'Request URL: '
      '${error.requestOptions.uri}',
    );

    debugPrint(
      'Request method: '
      '${error.requestOptions.method}',
    );

    debugPrint(
      'Stack trace: $stackTrace',
    );

    debugPrint(
      '======================================',
    );
  }
}