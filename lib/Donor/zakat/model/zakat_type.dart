enum ZakatType {
  money('MONEY'),
  gold('GOLD'),
  silver('SILVER');

  const ZakatType(
    this.apiValue,
  );

  final String apiValue;
}