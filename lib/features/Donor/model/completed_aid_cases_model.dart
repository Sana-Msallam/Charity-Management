class CompletedAidCasesModel {
  final int completedAidCasesCount;

  CompletedAidCasesModel({
    required this.completedAidCasesCount,
  });

  factory CompletedAidCasesModel.fromJson(Map<String, dynamic> json) {
    return CompletedAidCasesModel(
      completedAidCasesCount:
          json['completed_aid_cases_count'] ?? 0,
    );
  }
}