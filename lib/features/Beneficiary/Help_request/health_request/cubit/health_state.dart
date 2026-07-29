sealed class HealthState {
  const HealthState();
}

final class HealthInitial extends HealthState {
  const HealthInitial();
}

final class HealthLoading extends HealthState {
  const HealthLoading();
}

final class HealthSuccess extends HealthState {
  const HealthSuccess(this.message);

  final String message;
}

final class HealthFailure extends HealthState {
  const HealthFailure(this.message);

  final String message;
}
