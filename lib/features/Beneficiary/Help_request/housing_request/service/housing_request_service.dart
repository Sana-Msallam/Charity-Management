import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    final String? accessToken =
        preferences.getString('access_token');

    final bool tokenExists =
        accessToken != null &&
        accessToken.trim().isNotEmpty;

    debugPrint('Token exists: $tokenExists');

    if (!tokenExists) {
      debugPrint(
        'Housing request stopped: Access token not found',
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
          headers: {
            'Authorization':
                'Bearer $accessToken',
          },
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
    final String currentPlaceOfResidence =
        request.currentPlaceOfResidence?.trim() ?? '';

    final String reasonForLock =
        request.reasonForLock?.trim() ?? '';

    final String housingSpecifications =
        request.housingSpecifications?.trim() ?? '';

    if (currentPlaceOfResidence.isEmpty) {
      throw const FormatException(
        'يرجى إدخال مكان الإقامة الحالي',
      );
    }

    if (reasonForLock.isEmpty) {
      throw const FormatException(
        'يرجى إدخال سبب طلب تأمين المنزل',
      );
    }

    if (housingSpecifications.isEmpty) {
      throw const FormatException(
        'يرجى إدخال مواصفات السكن المطلوب',
      );
    }

    final String currentPlaceJson =
        _encodeLocalizedText(
      currentPlaceOfResidence,
    );

    final String reasonForLockJson =
        _encodeLocalizedText(
      reasonForLock,
    );

    final String housingSpecificationsJson =
        _encodeLocalizedText(
      housingSpecifications,
    );

    formData.fields.addAll([
      MapEntry(
        'currentPlaceOfResidence',
        currentPlaceJson,
      ),
      MapEntry(
        'reasonForLock',
        reasonForLockJson,
      ),
      MapEntry(
        'housingSpecifications',
        housingSpecificationsJson,
      ),
    ]);

    debugPrint(
      'currentPlaceOfResidence: $currentPlaceJson',
    );

    debugPrint(
      'reasonForLock: $reasonForLockJson',
    );

    debugPrint(
      'housingSpecifications: '
      '$housingSpecificationsJson',
    );
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
    final String currentHousingSituation =
        request.currentHousingSituation?.trim() ?? '';

    if (currentHousingSituation.isEmpty) {
      throw const FormatException(
        'يرجى إدخال وصف حالة المنزل والإصلاحات المطلوبة',
      );
    }

    final String currentHousingSituationJson =
        _encodeLocalizedText(
      currentHousingSituation,
    );

    formData.fields.add(
      MapEntry(
        'currentHousingSituation',
        currentHousingSituationJson,
      ),
    );

    debugPrint(
      'currentHousingSituation: '
      '$currentHousingSituationJson',
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

  String _encodeLocalizedText(
    String text,
  ) {
    final String normalizedText =
        text.trim();

    if (normalizedText.isEmpty) {
      throw const FormatException(
        'لا يمكن إرسال حقل نصي فارغ',
      );
    }

    return jsonEncode({
      'ar': normalizedText,
      'en': normalizedText,
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