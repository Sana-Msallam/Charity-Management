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
    this.currentHousingSituationAr,
    this.currentHousingSituationEn,
    this.currentRent,
    this.currentPlaceOfResidenceAr,
    this.currentPlaceOfResidenceEn,
    this.reasonForLockAr,
    this.reasonForLockEn,
    this.housingSpecificationsAr,
    this.housingSpecificationsEn,
  });

  final ApplicantInfoModel applicantInfo;
  final HousingSubCategory subCategory;

  // الحقول المشتركة
  final String detailsAr;
  final String detailsEn;
  final double cost;
  final List<PlatformFile> media;

  // subCategoryId = 3
  final String? currentHousingSituationAr;
  final String? currentHousingSituationEn;

  // subCategoryId = 2
  final double? currentRent;

  // subCategoryId = 1
  final String? currentPlaceOfResidenceAr;
  final String? currentPlaceOfResidenceEn;

  final String? reasonForLockAr;
  final String? reasonForLockEn;

  final String? housingSpecificationsAr;
  final String? housingSpecificationsEn;
}
