import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';

import '../model/cancel_sponsorship_model.dart';
import 'cancel_sponsorship_state.dart';

class CancelSponsorshipCubit
    extends Cubit<CancelSponsorshipState> {
  CancelSponsorshipCubit()
      : super(CancelSponsorshipInitial());

  Future<void> cancelSponsorship(int id) async {
    emit(CancelSponsorshipLoading());

    try {
      final response = await DioClient.dio.patch(
        '${ApiConstants.sponsorships}/$id/cancel',
      );

      final result =
          CancelSponsorshipResponse.fromJson(
        response.data,
      );

      emit(
        CancelSponsorshipSuccess(result),
      );
    } on DioException catch (e) {
      print('STATUS CODE: ${e.response?.statusCode}');
      print('RESPONSE DATA: ${e.response?.data}');
      print('REQUEST URL: ${e.requestOptions.uri}');

      emit(
        CancelSponsorshipError(
          e.response?.data?['message']?.toString() ??
              'حدث خطأ أثناء إلغاء الكفالة',
        ),
      );
    } catch (e) {
      print('ERROR: $e');

      emit(
        CancelSponsorshipError(
          'حدث خطأ أثناء إلغاء الكفالة',
        ),
      );
    }
  }
}