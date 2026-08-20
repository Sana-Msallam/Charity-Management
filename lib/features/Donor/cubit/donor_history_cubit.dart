import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:charity_management/features/Donor/model/donor_history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'donor_history_state.dart';

class DonorHistoryCubit extends Cubit<DonorHistoryState> {
  DonorHistoryCubit() : super(const DonorHistoryInitial());

  Future<void> getDonorHistory() async {
    emit(const DonorHistoryLoading());

    try {
      final response = await DioClient.dio.get(
        ApiConstants.donorHistory,
      );

      final responseData = response.data;

      if (responseData['success'] == true) {
        final history = DonorHistoryModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );

        emit(
          DonorHistorySuccess(
            history: history,
          ),
        );
      } else {
        emit(
          DonorHistoryFailure(
            message: responseData['message']?.toString() ??
                'donations.loadError',
          ),
        );
      }
    } catch (e) {
      emit(
        const DonorHistoryFailure(
          message: 'donations.loadError',
        ),
      );
    }
  }
}