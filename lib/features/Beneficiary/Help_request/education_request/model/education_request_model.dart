import 'package:file_picker/file_picker.dart';

import '../../applicantInfo/model/applicant_info_model.dart';
import 'academic_achievement.dart';

class EducationRequestModel {
  const EducationRequestModel({
    required this.applicantInfo,
    required this.academicAchievement,
    required this.institutionNameAr,
    required this.institutionNameEn,
    required this.year,
    required this.detailsAr,
    required this.detailsEn,
    required this.cost,
    required this.media,
  });

  final ApplicantInfoModel applicantInfo;

  final AcademicAchievement academicAchievement;

  final String institutionNameAr;
  final String institutionNameEn;

  final String year;

  final String detailsAr;
  final String detailsEn;

  final double cost;

  final List<PlatformFile> media;
}