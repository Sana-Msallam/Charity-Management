import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';

import '../../../../constants/api_exception.dart';
import '../../services/auth_service.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthService authService;

  ForgotPasswordCubit({required this.authService})
    : super(const ForgotPasswordInitial());

  Future<void> requestOtp({
    required String phoneNumber,
    required AppLocalizations localizations,
  }) async {
    if (state is ForgotPasswordLoading) return;

    emit(const ForgotPasswordLoading());

    try {
      final message = await authService.requestPasswordResetOtp(
        phoneNumber: phoneNumber,
        fallbackMessage: localizations.otpSent,
      );

      emit(ForgotPasswordOtpSent(message: message));
    } on DioException catch (error) {
      emit(
        ForgotPasswordFailure(
          message: ApiException.getMessage(error, localizations),
        ),
      );
    } catch (_) {
      emit(ForgotPasswordFailure(message: localizations.unexpectedError));
    }
  }

  Future<void> resetPassword({
    required String code,
    required String newPassword,
    required AppLocalizations localizations,
  }) async {
    if (state is ForgotPasswordLoading) return;

    emit(const ForgotPasswordLoading());

    try {
      final message = await authService.resetPassword(
        code: code,
        newPassword: newPassword,
        fallbackMessage: localizations.operationSuccessful,
      );

      emit(ForgotPasswordResetSuccess(message: message));
    } on DioException catch (error) {
      emit(
        ForgotPasswordFailure(
          message: ApiException.getMessage(error, localizations),
        ),
      );
    } catch (_) {
      emit(ForgotPasswordFailure(message: localizations.unexpectedError));
    }
  }
}
