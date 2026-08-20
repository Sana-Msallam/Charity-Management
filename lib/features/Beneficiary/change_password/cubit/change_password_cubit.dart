import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/change_password_service.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._changePasswordService)
    : super(const ChangePasswordInitial());

  final ChangePasswordService _changePasswordService;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required AppLocalizations localizations,
  }) async {
    if (state is ChangePasswordLoading) {
      return;
    }

    emit(const ChangePasswordLoading());

    try {
      final String message = await _changePasswordService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        fallbackMessage: localizations.operationSuccessful,
      );

      emit(ChangePasswordSuccess(message));
    } on DioException catch (error, stackTrace) {
      debugPrint('ChangePasswordCubit DioException: ${error.type}');
      debugPrint('Stack trace: $stackTrace');

      emit(
        ChangePasswordFailure(ApiException.getMessage(error, localizations)),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'ChangePasswordCubit unexpected error type: ${error.runtimeType}',
      );
      debugPrint('Stack trace: $stackTrace');
      emit(ChangePasswordFailure(localizations.unexpectedError));
    }
  }
}
