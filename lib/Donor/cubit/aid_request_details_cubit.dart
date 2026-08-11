import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/aid_request_details_model.dart';
import 'aid_request_details_state.dart';

class AidRequestDetailsCubit extends Cubit<AidRequestDetailsState> {
  AidRequestDetailsCubit({Dio? dio})
    : _dio = dio ?? DioClient.dio,
      super(AidRequestDetailsInitialState());

  final Dio _dio;

  void fetchDetails(int id) async {
    emit(AidRequestDetailsLoadingState());

    try {
      final data = await _fetchDetailsData(id);
      emit(AidRequestDetailsSuccessState(data));
    } catch (e) {
      emit(AidRequestDetailsErrorState(e.toString()));
    }
  }

  Future<void> refreshDetailsAfterPayment(int id) async {
    emit(AidRequestDetailsLoadingState());

    try {
      final data = await _fetchDetailsData(id);
      emit(AidRequestDetailsSuccessState(data));
    } catch (e) {
      emit(AidRequestDetailsErrorState(e.toString()));
    }
  }

  Future<AidRequestDetailsModel> _fetchDetailsData(int id) async {
    final response = await _dio.get('${ApiConstants.aidRequests}/$id');

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid aid request details response');
    }

    return AidRequestDetailsModel.fromJson(data);
  }
}
