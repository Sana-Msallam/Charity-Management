import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:charity_management/features/Donor/cubit/update_profile_state.dart';
import 'package:charity_management/features/Donor/model/profile_model.dart';
import 'package:charity_management/features/Donor/model/profile_update_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  Future<void> updateProfile(ProfileUpdateModel data) async {
    emit(UpdateProfileLoading());

    try {
      print('');
      print('==========================================');
      print('          UPDATE PROFILE REQUEST');
      print('==========================================');
      print('URL: ${ApiConstants.profile}');
      print('METHOD: PATCH');
      print('BODY: ${data.toJson()}');
      print('==========================================');

    final response = await DioClient.dio.patch(
  ApiConstants.profile,
  data: data.toJson(),
);

      print('');
      print('==========================================');
      print('          UPDATE PROFILE RESPONSE');
      print('==========================================');
      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');
      print('==========================================');

      if (response.data == null) {
        throw Exception('الخادم أعاد Response فارغ');
      }

      final Map<String, dynamic> json =
          Map<String, dynamic>.from(response.data);

      final updatedProfile = ProfileModel.fromJson(json);

      emit(UpdateProfileSuccess(updatedProfile));
    } on DioException catch (e) {
      print('');
      print('==========================================');
      print('          UPDATE PROFILE ERROR');
      print('==========================================');
      print('MESSAGE: ${e.message}');
      print('STATUS: ${e.response?.statusCode}');
      print('RESPONSE: ${e.response?.data}');
      print('==========================================');

      String message = 'تعذر تحديث معلومات الملف الشخصي';

      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        final serverMessage = responseData['message'];

        if (serverMessage is String) {
          message = serverMessage;
        } else if (serverMessage is List) {
          message = serverMessage.join('\n');
        }
      }

      emit(UpdateProfileError(message));
    } catch (e) {
      print('');
      print('==========================================');
      print('          UPDATE PROFILE ERROR');
      print('==========================================');
      print('ERROR: $e');
      print('==========================================');

      emit(
        UpdateProfileError(
          'تعذر تحديث معلومات الملف الشخصي',
        ),
      );
    }
  }
}