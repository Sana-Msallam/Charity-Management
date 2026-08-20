abstract class CancelRequestState {
  const CancelRequestState();
}

class CancelRequestInitial
    extends CancelRequestState {
  const CancelRequestInitial();
}

class CancelRequestLoading
    extends CancelRequestState {
  const CancelRequestLoading();
}

class CancelRequestSuccess
    extends CancelRequestState {
  const CancelRequestSuccess({
    required this.message,
    required this.requestId,
  });

  final String message;
  final int requestId;
}

class CancelRequestFailure
    extends CancelRequestState {
  const CancelRequestFailure({
    required this.message,
  });

  final String message;
}