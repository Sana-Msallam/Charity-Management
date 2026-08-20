enum HousingSubCategory {
  homeProvision(
    apiId: 1,
  ),

  rentAssistance(
    apiId: 2,
  ),

  homeRepairs(
    apiId: 3,
  );

  const HousingSubCategory({
    required this.apiId,
  });

  final int apiId;
}