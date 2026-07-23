
import 'package:charity_management/Donor/model/aid_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'aid_request_state.dart';
import 'package:dio/dio.dart';
class AidRequestCubit extends Cubit<AidRequestState> {
  AidRequestCubit() : super(AidRequestInitialState());

  final Dio _dio = Dio();

  void fetchAidRequests() async {
    // خبري الشاشة إنه بلشنا تحميل
    emit(AidRequestLoadingState());

    try {
      // طلبي البيانات من الباك إند
      final response = await _dio.get('https://YOUR_DOMAIN.com/donor/public/aid-requests');

      // حولي قائمة الـ JSON لقائمة من الـ Models
      List<AidRequestModel> requests = (response.data as List)
          .map((item) => AidRequestModel.fromJson(item))
          .toList();

      // خبري الشاشة إنه نجحنا وابعتيلها البيانات
      emit(AidRequestSuccessState(requests));
    } catch (e) {
      // خبري الشاشة إنه صار خطأ
      emit(AidRequestErrorState(e.toString()));
    }
  }
}