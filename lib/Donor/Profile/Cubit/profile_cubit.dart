import 'package:charity_management/Donor/Profile/profile_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';


class ProfileCubit extends Cubit<ProfileState> {

  ProfileCubit()
      : super(ProfileInitialState());


  void fetchProfile() async {

    emit(ProfileLoadingState());


    try {

print(
  'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjE4LCJlbWFpbCI6ImltYW4wQGV4YW1wbGUuY29tIiwidXNlclR5cGUiOiJET05PUiIsImlhdCI6MTc4NTI1MjgwOSwiZXhwIjoxNzg1ODU3NjA5fQ.I_unSxHKfZ1uahdAK5WFZ1FTztKAuPC-rFwmeh5gXwQ',
);
      final response = await DioClient.dio.get(
        ApiConstants.profile,

        options: Options(
      headers: {
  'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjE4LCJlbWFpbCI6ImltYW4wQGV4YW1wbGUuY29tIiwidXNlclR5cGUiOiJET05PUiIsImlhdCI6MTc4NTI1MjgwOSwiZXhwIjoxNzg1ODU3NjA5fQ.I_unSxHKfZ1uahdAK5WFZ1FTztKAuPC-rFwmeh5gXwQ',
},
        ),

      );


      final profile =
      ProfileModel.fromJson(response.data);


      emit(
        ProfileSuccessState(profile),
      );


    } catch(e) {

      emit(
        ProfileErrorState(
          e.toString(),
        ),
      );

    }

  }

}