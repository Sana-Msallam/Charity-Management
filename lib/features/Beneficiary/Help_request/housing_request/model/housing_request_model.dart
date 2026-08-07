import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:file_picker/file_picker.dart';

import 'housing_sub_category.dart';

class HousingRequestModel {
  const HousingRequestModel({
    required this.applicantInfo,
    required this.subCategory,
    required this.detailsAr,
    required this.detailsEn,
    required this.cost,
    required this.media,
    this.currentHousingSituation,
    this.currentRent,
    this.currentPlaceOfResidence,
    this.reasonForLock,
    this.housingSpecifications,
  });

  final ApplicantInfoModel applicantInfo;

  final HousingSubCategory subCategory;

  // الحقول المشتركة
  final String detailsAr;

  final String detailsEn;

  final double cost;

  final List<PlatformFile> media;

  // الحقول الخاصة حسب نوع الطلب
  final String? currentHousingSituation;

  final double? currentRent;

  final String? currentPlaceOfResidence;

  final String? reasonForLock;

  final String? housingSpecifications;
}