sealed class HousingState {
  const HousingState();
}

final class HousingInitial extends HousingState {
  const HousingInitial();
}

final class HousingLoading extends HousingState {
  const HousingLoading();
}

final class HousingSuccess extends HousingState {
  const HousingSuccess({
    required this.message,
  });

  final String message;
}

final class HousingFailure extends HousingState {
  const HousingFailure({
    required this.message,
  });

  final String message;
}