enum HousingSubCategory {
  homeProvision(
    arabicLabel: 'تأمين منزل',
    apiId: 1,
  ),

  rentAssistance(
    arabicLabel: 'مساعدة في إيجار البيت',
    apiId: 2,
  ),

  homeRepairs(
    arabicLabel: 'إصلاحات منزلية',
    apiId: 3,
  );

  const HousingSubCategory({
    required this.arabicLabel,
    required this.apiId,
  });

  final String arabicLabel;
  final int apiId;
}