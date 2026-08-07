enum FoodAidType {
  foodBasket(
    arabicLabel: 'سلة غذائية',
    apiValue: 'FOOD_BASKET',
  ),

  babyMilk(
    arabicLabel: 'حليب أطفال',
    apiValue: 'BABY_MILK',
  );

  const FoodAidType({
    required this.arabicLabel,
    required this.apiValue,
  });

  final String arabicLabel;
  final String apiValue;
}