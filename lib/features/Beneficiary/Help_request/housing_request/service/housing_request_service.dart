import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/housing_request_model.dart';
import '../model/housing_sub_category.dart';

class HousingRequestService {
  Future<String> submitHousingRequest(
    HousingRequestModel request,
  ) async {
    debugPrint('======================================');
    debugPrint('START SUBMIT HOUSING REQUEST');
    debugPrint('======================================');

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

    debugPrint('Housing request values:');
    debugPrint('categoryId: 3');

    debugPrint(
      'subCategoryId: ${request.subCategory.apiId}',
    );

    debugPrint(
      'subCategory: ${request.subCategory.arabicLabel}',
    );

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
      'addressAr: ${applicant.addressAr}',
    );

    debugPrint(
      'addressEn: ${applicant.addressEn}',
    );

    debugPrint(
      'address JSON: $addressJson',
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
      'detailsAr: ${request.detailsAr}',
    );

    debugPrint(
      'detailsEn: ${request.detailsEn}',
    );

    debugPrint(
      'details JSON: $detailsJson',
    );

    debugPrint(
      'cost: ${request.cost}',
    );

    debugPrint(
      'attachments count: ${request.media.length}',
    );

    final FormData formData = FormData();

    formData.fields.addAll([
      const MapEntry(
        'categoryId',
        '3',
      ),
      MapEntry(
        'subCategoryId',
        request.subCategory.apiId.toString(),
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
    ]);

    _addSubCategoryFields(
      formData: formData,
      request: request,
    );

    for (final PlatformFile file
        in request.media) {
      await _addFileToFormData(
        formData: formData,
        file: file,
      );
    }

    _printFormData(
      formData,
    );

    try {
      debugPrint(
        'Sending POST request to: '
        '${ApiConstants.baseUrl}'
        '${ApiConstants.housingRequest}',
      );

      final Response<dynamic> response =
          await DioClient.dio.post<dynamic>(
        ApiConstants.housingRequest,
        data: formData,
        options: Options(
          contentType:
              Headers.multipartFormDataContentType,
        ),
      );

      debugPrint(
        'Housing request response received',
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
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'DIO ERROR WHILE SUBMITTING HOUSING REQUEST',
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
        'UNEXPECTED HOUSING REQUEST ERROR',
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

  void _addSubCategoryFields({
    required FormData formData,
    required HousingRequestModel request,
  }) {
    switch (request.subCategory) {
      case HousingSubCategory.homeProvision:
        _addHomeProvisionFields(
          formData: formData,
          request: request,
        );
        break;

      case HousingSubCategory.rentAssistance:
        _addRentAssistanceFields(
          formData: formData,
          request: request,
        );
        break;

      case HousingSubCategory.homeRepairs:
        _addHomeRepairsFields(
          formData: formData,
          request: request,
        );
        break;
    }
  }

  void _addHomeProvisionFields({
    required FormData formData,
    required HousingRequestModel request,
  }) {
    final String currentPlaceAr =
        request.currentPlaceOfResidenceAr?.trim() ?? '';
    final String currentPlaceEn =
        request.currentPlaceOfResidenceEn?.trim() ?? '';

    final String reasonAr =
        request.reasonForLockAr?.trim() ?? '';
    final String reasonEn =
        request.reasonForLockEn?.trim() ?? '';

    final String specificationsAr =
        request.housingSpecificationsAr?.trim() ?? '';
    final String specificationsEn =
        request.housingSpecificationsEn?.trim() ?? '';

    _requireLocalizedPair(
      ar: currentPlaceAr,
      en: currentPlaceEn,
      fieldName: 'مكان الإقامة الحالي',
    );

    _requireLocalizedPair(
      ar: reasonAr,
      en: reasonEn,
      fieldName: 'سبب طلب تأمين المنزل',
    );

    _requireLocalizedPair(
      ar: specificationsAr,
      en: specificationsEn,
      fieldName: 'مواصفات السكن المطلوب',
    );

    final String currentPlaceJson = _encodeLocalizedText(
      ar: currentPlaceAr,
      en: currentPlaceEn,
    );

    final String reasonJson = _encodeLocalizedText(
      ar: reasonAr,
      en: reasonEn,
    );

    final String specificationsJson = _encodeLocalizedText(
      ar: specificationsAr,
      en: specificationsEn,
    );

    formData.fields.addAll([
      MapEntry('currentPlaceOfResidence', currentPlaceJson),
      MapEntry('reasonForLock', reasonJson),
      MapEntry('housingSpecifications', specificationsJson),
    ]);

    debugPrint('currentPlaceOfResidence: $currentPlaceJson');
    debugPrint('reasonForLock: $reasonJson');
    debugPrint('housingSpecifications: $specificationsJson');
  }

  void _addRentAssistanceFields({
    required FormData formData,
    required HousingRequestModel request,
  }) {
    final double? currentRent =
        request.currentRent;

    if (currentRent == null ||
        currentRent <= 0) {
      throw const FormatException(
        'يرجى إدخال قيمة الإيجار الحالي بشكل صحيح',
      );
    }

    formData.fields.add(
      MapEntry(
        'currentRent',
        currentRent.toString(),
      ),
    );

    debugPrint(
      'currentRent: $currentRent',
    );
  }

  void _addHomeRepairsFields({
    required FormData formData,
    required HousingRequestModel request,
  }) {
    final String situationAr =
        request.currentHousingSituationAr?.trim() ?? '';
    final String situationEn =
        request.currentHousingSituationEn?.trim() ?? '';

    _requireLocalizedPair(
      ar: situationAr,
      en: situationEn,
      fieldName: 'وصف حالة المنزل والإصلاحات المطلوبة',
    );

    final String situationJson = _encodeLocalizedText(
      ar: situationAr,
      en: situationEn,
    );

    formData.fields.add(
      MapEntry(
        'currentHousingSituation',
        situationJson,
      ),
    );

    debugPrint(
      'currentHousingSituation: $situationJson',
    );
  }

  Future<void> _addFileToFormData({
    required FormData formData,
    required PlatformFile file,
  }) async {
    debugPrint(
      '--------------------------------------',
    );

    debugPrint(
      'Checking housing attachment: ${file.name}',
    );

    debugPrint(
      'Attachment size: ${file.size} bytes',
    );

    MultipartFile multipartFile;

    if (kIsWeb) {
      final Uint8List? bytes =
          file.bytes;

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
      final String? path =
          file.path;

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
      'Housing attachment added successfully: '
      '${file.name}',
    );

    debugPrint(
      '--------------------------------------',
    );
  }

  void _requireLocalizedPair({
    required String ar,
    required String en,
    required String fieldName,
  }) {
    if (ar.trim().isEmpty || en.trim().isEmpty) {
      throw FormatException(
        'يجب إدخال $fieldName باللغتين العربية والإنجليزية',
      );
    }
  }

  String _encodeLocalizedText({
    required String ar,
    required String en,
  }) {
    return jsonEncode({
      'ar': ar.trim(),
      'en': en.trim(),
    });
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
      'Invalid housing response format: $data',
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
      '----------- HOUSING FORM DATA -----------',
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
      '-----------------------------------------',
    );
  }

}