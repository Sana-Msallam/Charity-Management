import 'package:file_picker/file_picker.dart';

import 'applicant_info_model.dart';
import 'health_aid_type.dart';

class HealthRequestModel {
  const HealthRequestModel({
    required this.applicantInfo,
    required this.typeAid,
    required this.description,
    required this.cost,
    required this.media,
  });

  final ApplicantInfoModel applicantInfo;
  final HealthAidType typeAid;
  final String description;
  final double cost;

  // PlatformFile يعمل على Web وAndroid معاً
  final List<PlatformFile> media;
}
