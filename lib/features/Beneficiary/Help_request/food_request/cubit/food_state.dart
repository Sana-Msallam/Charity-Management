sealed class FoodState {
  const FoodState();
}

final class FoodInitial extends FoodState {
  const FoodInitial();
}

final class FoodLoading extends FoodState {
  const FoodLoading();
}

final class FoodSuccess extends FoodState {
  const FoodSuccess({
    required this.message,
  });

  final String message;
}

final class FoodFailure extends FoodState {
  const FoodFailure({
    required this.message,
  });

  final String message;
}