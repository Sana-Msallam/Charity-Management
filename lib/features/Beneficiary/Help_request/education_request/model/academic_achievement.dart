enum AcademicAchievement {
  highSchool(
    arabicLabel: 'ثانوي',
    apiValue: 'HIGH_SCHOOL',
  ),

  diploma(
    arabicLabel: 'دبلوم',
    apiValue: 'DIPLOMA',
  ),

  bachelor(
    arabicLabel: 'بكالوريوس',
    apiValue: 'BACHELOR',
  ),

  master(
    arabicLabel: 'ماجستير',
    apiValue: 'MASTER',
  );

  const AcademicAchievement({
    required this.arabicLabel,
    required this.apiValue,
  });

  final String arabicLabel;
  final String apiValue;
}