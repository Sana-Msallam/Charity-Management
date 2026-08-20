import '../../model/request_details_model.dart';

abstract class RequestDetailsState {
  const RequestDetailsState();
}

class RequestDetailsInitial
    extends RequestDetailsState {
  const RequestDetailsInitial();
}

class RequestDetailsLoading
    extends RequestDetailsState {
  const RequestDetailsLoading();
}

class RequestDetailsSuccess
    extends RequestDetailsState {
  const RequestDetailsSuccess({
    required this.request,
  });

  final RequestDetailsModel request;
}

class RequestDetailsFailure
    extends RequestDetailsState {
  const RequestDetailsFailure({
    required this.message,
  });

  final String message;
}