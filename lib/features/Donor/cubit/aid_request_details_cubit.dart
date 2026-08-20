import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../model/aid_request_details_model.dart';
import 'aid_request_details_state.dart';

class AidRequestDetailsCubit extends Cubit<AidRequestDetailsState> {
  AidRequestDetailsCubit()
      : super(AidRequestDetailsInitialState());

  void fetchDetails(int id) async {
    emit(AidRequestDetailsLoadingState());

    try {
      final response = await DioClient.dio.get(
'${ApiConstants.aidRequests}/$id',      );

      final data = AidRequestDetailsModel.fromJson(response.data);

      emit(
        AidRequestDetailsSuccessState(data),
      );
    } catch (e) {
      emit(
        AidRequestDetailsErrorState(
          e.toString(),
        ),
      );
    }
  }
}