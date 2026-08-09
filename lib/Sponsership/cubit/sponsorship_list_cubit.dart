import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';

import '../model/sponsorship_list_model.dart';
import 'sponsorship_list_state.dart';

class SponsorshipListCubit extends Cubit<SponsorshipListState> {
  SponsorshipListCubit() : super(SponsorshipListInitial());

  Future<void> getSponsorships() async {
    emit(SponsorshipListLoading());

    try {
      final response = await DioClient.dio.get(
        ApiConstants.sponsorships,
      );

      final List<dynamic> data = response.data['data'] ?? [];

      final sponsorships = data
          .map(
            (json) => SponsorshipListModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();

      emit(
        SponsorshipListSuccess(sponsorships),
      );
    } on DioException catch (e) {
      print('STATUS CODE: ${e.response?.statusCode}');
      print('RESPONSE DATA: ${e.response?.data}');
      print('REQUEST URL: ${e.requestOptions.uri}');

      emit(
        SponsorshipListError(
          e.response?.data?['message']?.toString() ??
              'حدث خطأ أثناء جلب الكفالات',
        ),
      );
    } catch (e) {
      print('ERROR: $e');

      emit(
        SponsorshipListError(
          e.toString(),
        ),
      );
    }
  }
}