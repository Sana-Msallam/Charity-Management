import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/api_exception.dart';
import '../../services/auth_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService authService;

  LoginCubit({
    required this.authService,
  }) : super(const LoginInitial());

  Future<void> login({
    required String countryCode,
    required String phoneNumber,
    required String password,
  }) async {
    if (state is LoginLoading) return;

    emit(const LoginLoading());

    try {
      final fullPhoneNumber = _buildFullPhoneNumber(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
      );

      final response = await authService.login(
        phoneNumber: fullPhoneNumber,
        password: password,
      );

      emit(LoginSuccess(response));
    } on DioException catch (error) {
      emit(
        LoginFailure(
          ApiException.getMessage(error),
        ),
      );
    } on FormatException catch (error) {
      emit(
        LoginFailure(error.message),
      );
    } catch (error) {
      emit(
        const LoginFailure(
          'حدث خطأ غير متوقع أثناء تسجيل الدخول',
        ),
      );
    }
  }

  String _buildFullPhoneNumber({
    required String countryCode,
    required String phoneNumber,
  }) {
    final cleanCountryCode = countryCode.trim();

    String cleanPhoneNumber = phoneNumber
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '');

    if (cleanPhoneNumber.startsWith('+')) {
      return cleanPhoneNumber;
    }

    if (cleanPhoneNumber.startsWith('0')) {
      cleanPhoneNumber = cleanPhoneNumber.substring(1);
    }

    return '$cleanCountryCode$cleanPhoneNumber';
  }
}