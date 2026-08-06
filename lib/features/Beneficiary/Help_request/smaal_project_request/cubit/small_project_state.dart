sealed class SmallProjectState {
  const SmallProjectState();
}

final class SmallProjectInitial extends SmallProjectState {
  const SmallProjectInitial();
}

final class SmallProjectLoading extends SmallProjectState {
  const SmallProjectLoading();
}

final class SmallProjectSuccess extends SmallProjectState {
  const SmallProjectSuccess(this.message);

  final String message;
}

final class SmallProjectFailure extends SmallProjectState {
  const SmallProjectFailure(this.message);

  final String message;
}
