abstract class OtpState {
  const OtpState();
}

class OtpInitial extends OtpState {
  const OtpInitial();
}

class OtpLoading extends OtpState {
  const OtpLoading();
}

class OtpSuccess extends OtpState {
  const OtpSuccess({
    required this.userId,
    required this.message,
  });

  final int userId;
  final String message;
}

class OtpFailure extends OtpState {
  const OtpFailure(this.message);

  final String message;
}