import 'package:file_picker/file_picker.dart';

import '../../applicantInfo/model/applicant_info_model.dart';
import 'food_aid_type.dart';

class FoodRequestModel {
  const FoodRequestModel({
    required this.applicantInfo,
    required this.typeAid,
    required this.numberIndividuals,
    required this.detailsAr,
    required this.detailsEn,
    required this.cost,
    required this.media,
  });

  final ApplicantInfoModel applicantInfo;
  final FoodAidType typeAid;
  final int numberIndividuals;
  final String detailsAr;
final String detailsEn;
  final double cost;
  final List<PlatformFile> media;
}