import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/model/small_project_request_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/service/small_project_service.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'small_project_state.dart';

class SmallProjectCubit extends Cubit<SmallProjectState> {
  SmallProjectCubit(this._smallProjectRequestService)
    : super(const SmallProjectInitial());

  final SmallProjectRequestService _smallProjectRequestService;

  Future<void> submitSmallProjectRequest(
    SmallProjectRequestModel request,
    AppLocalizations localizations,
  ) async {
    if (state is SmallProjectLoading) {
      debugPrint('Small project submit ignored: request is already loading');
      return;
    }

    debugPrint('======================================');
    debugPrint('SmallProjectCubit submit started');
    debugPrint('======================================');

    emit(const SmallProjectLoading());

    try {
      final String message = await _smallProjectRequestService
          .submitSmallProjectRequest(request);

      debugPrint('SmallProjectCubit success: $message');

      emit(SmallProjectSuccess(message));
    } on DioException catch (error, stackTrace) {
      debugPrint('SmallProjectCubit DioException: ${error.message}');

      debugPrint('Response: ${error.response?.data}');

      debugPrint('Stack trace: $stackTrace');

      final String message = ApiException.getMessage(error, localizations);

      emit(SmallProjectFailure(message));
    } on FormatException catch (error, stackTrace) {
      debugPrint('SmallProjectCubit FormatException: ${error.message}');

      debugPrint('Stack trace: $stackTrace');

      emit(SmallProjectFailure(error.message));
    } catch (error, stackTrace) {
      debugPrint('SmallProjectCubit unexpected error: $error');

      debugPrint('Stack trace: $stackTrace');

      emit(SmallProjectFailure(localizations.unexpectedError));
    }
  }

  Future<void> updateSmallProjectRequest({
    required int requestId,
    required SmallProjectRequestModel request,
    required AppLocalizations localizations,
  }) async {
    if (state is SmallProjectLoading) {
      debugPrint('Small project update ignored: request is already loading');
      return;
    }

    debugPrint('======================================');
    debugPrint('SmallProjectCubit update started');
    debugPrint('Request id: $requestId');
    debugPrint('======================================');

    emit(const SmallProjectLoading());

    try {
      final String message = await _smallProjectRequestService
          .updateSmallProjectRequest(requestId: requestId, request: request);

      debugPrint('SmallProjectCubit update success: $message');

      emit(SmallProjectSuccess(message));
    } on DioException catch (error, stackTrace) {
      debugPrint('SmallProjectCubit update DioException: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      final String message = ApiException.getMessage(error, localizations);

      emit(SmallProjectFailure(message));
    } on FormatException catch (error, stackTrace) {
      debugPrint('SmallProjectCubit update FormatException: ${error.message}');
      debugPrint('Stack trace: $stackTrace');

      emit(SmallProjectFailure(error.message));
    } catch (error, stackTrace) {
      debugPrint('SmallProjectCubit update unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');

      emit(SmallProjectFailure(localizations.unexpectedError));
    }
  }
}
