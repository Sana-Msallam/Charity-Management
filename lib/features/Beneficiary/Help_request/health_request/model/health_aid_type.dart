enum HealthAidType {
  medicineInsurance(
    'MEDICINE_INSURANCE',
  ),

  surgery(
    'SURGERY',
  ),

  medicalDevices(
    'MEDICAL_DEVICES',
  );

  const HealthAidType(
    this.apiValue,
  );

  final String apiValue;
}