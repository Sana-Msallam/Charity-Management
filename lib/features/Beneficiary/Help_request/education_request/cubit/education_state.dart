sealed class EducationState {
  const EducationState();
}

final class EducationInitial extends EducationState {
  const EducationInitial();
}

final class EducationLoading extends EducationState {
  const EducationLoading();
}

final class EducationSuccess extends EducationState {
  const EducationSuccess({
    required this.message,
  });

  final String message;
}

final class EducationFailure extends EducationState {
  const EducationFailure({
    required this.message,
  });

  final String message;
}