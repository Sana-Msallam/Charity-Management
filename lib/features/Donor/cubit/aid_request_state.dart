// import 'package:charity_management/Donor/model/aid_request_model.dart';
import 'package:charity_management/features/Donor/model/aid_request_model.dart';

abstract class AidRequestState {}

// 1. الحالة الابتدائية
class AidRequestInitialState extends AidRequestState {}

// 2. حالة التحميل (Loading)
class AidRequestLoadingState extends AidRequestState {}

// 3. حالة النجاح (Success) - وبنرجع معها قائمة البيانات
class AidRequestSuccessState extends AidRequestState {
  final List<AidRequestModel> requests;
  AidRequestSuccessState(this.requests);
}

// 4. حالة الخطأ (Error)
class AidRequestErrorState extends AidRequestState {
  final String errorMessage;
  AidRequestErrorState(this.errorMessage);
}
