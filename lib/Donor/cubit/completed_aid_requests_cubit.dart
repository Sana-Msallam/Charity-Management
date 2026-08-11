
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/completed_aid_request_model.dart';
import 'completed_aid_requests_state.dart';

class CompletedAidRequestsCubit
    extends Cubit<CompletedAidRequestsState> {
  CompletedAidRequestsCubit()
      : super(CompletedAidRequestsInitial());

  Future<void> fetchCompletedAidRequests({
    int? categoryId,
  }) async {
    emit(CompletedAidRequestsLoading());

    try {
      final response = await DioClient.dio.get(
        '${ApiConstants.baseUrl}/donor/public/aid-requests/completed',
        queryParameters: categoryId != null
            ? {
                'categoryId': categoryId,
              }
            : null,
      );

      final data = response.data;

      final List<dynamic> requestsJson =
          data is List ? data : (data['data'] ?? []);

      final requests = requestsJson
          .map(
            (json) =>
                CompletedAidRequestModel.fromJson(json),
          )
          .toList();

      emit(
        CompletedAidRequestsSuccess(requests),
      );
    } catch (e) {
      emit(
        CompletedAidRequestsError(
          e.toString(),
        ),
      );
    }
  }
}

