enum FoodAidType {
  foodBasket(
    apiValue: 'FOOD_BASKET',
  ),

  babyMilk(
    apiValue: 'BABY_MILK',
  );

  const FoodAidType({
    required this.apiValue,
  });

  final String apiValue;
}