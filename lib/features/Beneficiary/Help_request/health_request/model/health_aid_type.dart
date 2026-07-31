enum HealthAidType {
  medicineInsurance('تأمين أدوية', 'MEDICINE_INSURANCE'),
  surgery('عمل جراحي', 'SURGERY'),
  medicalDevices('أجهزة طبية', 'MEDICAL_DEVICES');

  const HealthAidType(this.arabicLabel, this.apiValue);

  final String arabicLabel;
  final String apiValue;
}
