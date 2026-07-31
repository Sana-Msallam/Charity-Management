import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../model/aid_request_model.dart';
import 'aid_request_state.dart';

class AidRequestCubit extends Cubit<AidRequestState> {
  AidRequestCubit() : super(AidRequestInitialState());

  void fetchAidRequests({int? categoryId}) async {
    emit(AidRequestLoadingState());

  try {
  final response = await DioClient.dio.get(
    ApiConstants.aidRequests,
    queryParameters: {
      if (categoryId != null) 'categoryId': categoryId,
    },
  );

  print("STATUS: ${response.statusCode}");
  print("DATA: ${response.data}");

  final List<AidRequestModel> requests =
      (response.data as List)
          .map((item) => AidRequestModel.fromJson(item))
          .toList();

  emit(AidRequestSuccessState(requests));

} catch (e) {
      emit(AidRequestErrorState(e.toString()));
    }
  }
}