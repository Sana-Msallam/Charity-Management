// import 'package:charity_management/Sponsership/Model/sponsership_model.dart';
import 'package:charity_management/Sponsership/model/sponsership_request_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
// import 'package:charity_management/core/network/api_constants.dart';
// import 'package:charity_management/core/network/dio_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

part 'sponsership_state.dart';

class SponsorshipCubit extends Cubit<SponsorshipState> {
  SponsorshipCubit() : super(SponsorshipInitial());

  Future<void> createSponsorship() async {
    emit(SponsorshipLoading());

    try {
      final response = await DioClient.dio.post(
        ApiConstants.sponsorships,
      );

      final result = CreateSponsorshipResponse.fromJson(
        response.data,
      );

      emit(SponsorshipSuccess(result));
   } on DioException catch (e) {
  print('STATUS CODE: ${e.response?.statusCode}');
  print('RESPONSE DATA: ${e.response?.data}');
  print('REQUEST URL: ${e.requestOptions.uri}');

  emit(
    SponsorshipError(
      e.response?.data?['message']?.toString() ??
          'حدث خطأ أثناء تقديم طلب الكفالة',
    ),
  );
} catch (e) {
  print('ERROR: $e');

  emit(
    SponsorshipError(
      e.toString(),
    ),
  );
}
  }
}