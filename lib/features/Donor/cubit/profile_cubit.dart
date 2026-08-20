import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:charity_management/features/Donor/model/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  void fetchProfile() async {
    emit(ProfileLoadingState());

    try {
      final response = await DioClient.dio.get(ApiConstants.profile);

      final profile = ProfileModel.fromJson(response.data);

      emit(ProfileSuccessState(profile));
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }
}
