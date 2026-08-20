enum AcademicAchievement {
  highSchool('HIGH_SCHOOL'),
  diploma('DIPLOMA'),
  bachelor('BACHELOR'),
  master('MASTER');

  const AcademicAchievement(
    this.apiValue,
  );

  final String apiValue;
}