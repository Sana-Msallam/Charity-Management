import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/completed_aid_cases_model.dart';
import 'completed_aid_cases_state.dart';

class CompletedAidCasesCubit
    extends Cubit<CompletedAidCasesState> {
  CompletedAidCasesCubit()
      : super(CompletedAidCasesInitialState());

  Future<void> fetchCompletedAidCases() async {
    emit(CompletedAidCasesLoadingState());

    try {
      final response = await DioClient.dio.get(
        ApiConstants.completedAidCases,
      );

      print("COMPLETED CASES STATUS: ${response.statusCode}");
      print("COMPLETED CASES DATA: ${response.data}");

      final data = CompletedAidCasesModel.fromJson(
        response.data is Map<String, dynamic>
            ? response.data
            : {},
      );

      emit(CompletedAidCasesSuccessState(data));
    } catch (e) {
      print("COMPLETED CASES ERROR: $e");

      emit(
        CompletedAidCasesErrorState(
          e.toString(),
        ),
      );
    }
  }
}