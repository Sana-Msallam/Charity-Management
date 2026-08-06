import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:file_picker/file_picker.dart';

class SmallProjectRequestModel {
  const SmallProjectRequestModel({
    required this.applicantInfo,
    required this.projectNameAr,
    required this.projectNameEn,
    required this.projectCategoryAr,
    required this.projectCategoryEn,
    required this.numberOfPeopleSupported,
    required this.detailsAr,
    required this.detailsEn,
    required this.cost,
    required this.media,
  });

  final ApplicantInfoModel applicantInfo;

  final String projectNameAr;
  final String projectNameEn;

  final String projectCategoryAr;
  final String projectCategoryEn;

  final int numberOfPeopleSupported;

  final String detailsAr;
  final String detailsEn;

  final double cost;

  final List<PlatformFile> media;
}