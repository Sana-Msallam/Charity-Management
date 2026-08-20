import '../model/aid_request_details_model.dart';


abstract class AidRequestDetailsState {}


class AidRequestDetailsInitialState 
    extends AidRequestDetailsState {}


class AidRequestDetailsLoadingState 
    extends AidRequestDetailsState {}


class AidRequestDetailsSuccessState 
    extends AidRequestDetailsState {

  final AidRequestDetailsModel request;

  AidRequestDetailsSuccessState(this.request);

}



class AidRequestDetailsErrorState 
    extends AidRequestDetailsState {

  final String error;

  AidRequestDetailsErrorState(this.error);

}