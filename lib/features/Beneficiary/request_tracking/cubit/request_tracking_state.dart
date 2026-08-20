import 'package:charity_management/features/Beneficiary/request_tracking/model/request_tracking_model.dart';
abstract class RequestTrackingState {
  const RequestTrackingState();
}

class RequestTrackingInitial extends RequestTrackingState {
  const RequestTrackingInitial();
}

class RequestTrackingLoading extends RequestTrackingState {
  const RequestTrackingLoading();
}

class RequestTrackingSuccess extends RequestTrackingState {
  const RequestTrackingSuccess({
    required this.requests,
    required this.selectedStatus,
  });

  final List<RequestTrackingModel> requests;

  // null معناها "الكل"
  final String? selectedStatus;
}

class RequestTrackingFailure extends RequestTrackingState {
  const RequestTrackingFailure({
    required this.message,
  });

  final String message;
}