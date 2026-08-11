

import '../model/completed_aid_request_model.dart';

abstract class CompletedAidRequestsState {}

class CompletedAidRequestsInitial
    extends CompletedAidRequestsState {}

class CompletedAidRequestsLoading
    extends CompletedAidRequestsState {}

class CompletedAidRequestsSuccess
    extends CompletedAidRequestsState {
  final List<CompletedAidRequestModel> requests;

  CompletedAidRequestsSuccess(this.requests);
}

class CompletedAidRequestsError
    extends CompletedAidRequestsState {
  final String message;

  CompletedAidRequestsError(this.message);
}
