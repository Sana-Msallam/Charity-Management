import '../models/login_response_model.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  final LoginResponseModel response;

  const LoginSuccess(this.response);
}

final class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);
}
