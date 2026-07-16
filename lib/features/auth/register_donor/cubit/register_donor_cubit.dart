import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/api_exception.dart';
import '../models/register_donor_request_model.dart';
import '../../services/auth_service.dart';
import 'register_donor_state.dart';

class RegisterDonorCubit extends Cubit<RegisterDonorState> {
  final AuthService authService;

  RegisterDonorCubit({
    required this.authService,
  }) : super(const RegisterDonorInitial());

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String number,
    required String countryName,
    required String countryCode,
    required String gender,
  }) async {
    if (state is RegisterDonorLoading) return;

    emit(const RegisterDonorLoading());

    try {
      final request = RegisterDonorRequestModel(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        password: password,
        number: _cleanPhoneNumber(number),
        countryName: countryName.trim(),
        countryCode: countryCode.trim(),
        gender: gender,
      );

      final response = await authService.registerDonor(
        request: request,
      );

      emit(RegisterDonorSuccess(response));
    } on DioException catch (error) {
      emit(
        RegisterDonorFailure(
          ApiException.getMessage(error),
        ),
      );
    } on FormatException catch (error) {
      emit(
        RegisterDonorFailure(error.message),
      );
    } catch (_) {
      emit(
        const RegisterDonorFailure(
          'حدث خطأ غير متوقع أثناء إنشاء الحساب',
        ),
      );
    }
  }

  String _cleanPhoneNumber(String value) {
    String number = value
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '');

    if (number.startsWith('0')) {
      number = number.substring(1);
    }

    return number;
  }
}