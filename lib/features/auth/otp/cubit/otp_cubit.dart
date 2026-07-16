import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


import '../../services/auth_service.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit({
    AuthService? authService,
  })  : _authService = authService ?? AuthService(),
        super(const OtpInitial());

  final AuthService _authService;

  Future<void> verifyOtp({
    required String countryCode,
    required String phoneNumber,
    required String code,
  }) async {
    emit(const OtpLoading());
      debugPrint('OTP Cubit: request started');
    debugPrint('countryCode: $countryCode');
    debugPrint('phoneNumber: $phoneNumber');
    debugPrint('code: $code');

    try {
      final result = await _authService.verifyOtp(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        code: code,
      );

      emit(
        OtpSuccess(
          userId: result.userId,
          message: result.message,
        ),
      );
    } on DioException catch (error) {
      emit(
        OtpFailure(
          _extractErrorMessage(error),
        ),
      );
    } catch (error) {
      emit(
        OtpFailure(
          error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      if (message is List) {
        return message.join('\n');
      }
    }

    return 'حدث خطأ أثناء التحقق من الرمز';
  }
}