sealed class ChangePasswordState {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  const ChangePasswordInitial();
}

class ChangePasswordLoading extends ChangePasswordState {
  const ChangePasswordLoading();
}

class ChangePasswordSuccess extends ChangePasswordState {
  const ChangePasswordSuccess(this.message);

  final String message;
}

class ChangePasswordFailure extends ChangePasswordState {
  const ChangePasswordFailure(this.message);

  final String message;
}
