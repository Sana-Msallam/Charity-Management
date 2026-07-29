import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';

import '../../../../constants/api_exception.dart';
import '../../services/auth_service.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit({AuthService? authService})
    : _authService = authService ?? AuthService(),
      super(const OtpInitial());

  final AuthService _authService;

  Future<void> verifyOtp({
    required String countryCode,
    required String phoneNumber,
    required String code,
    required AppLocalizations localizations,
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
        invalidResponseMessage: localizations.invalidServerResponse,
        verificationFailedMessage: localizations.verificationFailed,
      );

      emit(OtpSuccess(userId: result.userId, message: result.message));
    } on DioException catch (error) {
      emit(OtpFailure(ApiException.getMessage(error, localizations)));
    } catch (error) {
      emit(OtpFailure(localizations.unexpectedError));
    }
  }
}
