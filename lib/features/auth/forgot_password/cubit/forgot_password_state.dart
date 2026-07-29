abstract class ForgotPasswordState {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

class ForgotPasswordOtpSent extends ForgotPasswordState {
  final String message;

  const ForgotPasswordOtpSent({required this.message});
}

class ForgotPasswordResetSuccess extends ForgotPasswordState {
  final String message;

  const ForgotPasswordResetSuccess({required this.message});
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;

  const ForgotPasswordFailure({required this.message});
}
