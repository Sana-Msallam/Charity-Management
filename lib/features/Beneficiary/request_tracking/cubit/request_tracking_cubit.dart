import 'package:charity_management/features/Beneficiary/request_tracking/model/request_tracking_model.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/request_tracking_service.dart';
import 'request_tracking_state.dart';

class RequestTrackingCubit
    extends Cubit<RequestTrackingState> {
  RequestTrackingCubit(
    this._requestTrackingService,
  ) : super(
          const RequestTrackingInitial(),
        );

  final RequestTrackingService
      _requestTrackingService;

  // ==========================================
  // GET MY REQUESTS
  // ==========================================

  Future<void> getMyRequests({
    String? status,
    required AppLocalizations localizations,
  }) async {
    if (state is RequestTrackingLoading) {
      return;
    }

    debugPrint(
      '======================================',
    );

    debugPrint(
      'RequestTrackingCubit: getMyRequests',
    );

    debugPrint(
      'Selected status: ${status ?? 'ALL'}',
    );

    debugPrint(
      '======================================',
    );

    emit(
      const RequestTrackingLoading(),
    );

    try {
      final List<RequestTrackingModel> requests =
          await _requestTrackingService.getMyRequests(
        status: status,
      );

      debugPrint(
        'RequestTrackingCubit success',
      );

      debugPrint(
        'Requests count: ${requests.length}',
      );

      emit(
        RequestTrackingSuccess(
          requests: requests,
          selectedStatus: status,
        ),
      );
    } on FormatException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'RequestTrackingCubit FormatException: '
        '${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        RequestTrackingFailure(
          message:
              localizations.requestsLoadError,
        ),
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'RequestTrackingCubit DioException: '
        '${error.message}',
      );

      debugPrint(
        'Response: ${error.response?.data}',
      );

      debugPrint(
        'Status code: '
        '${error.response?.statusCode}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        RequestTrackingFailure(
          message: _extractDioMessage(
            error,
            localizations:
                localizations,
          ),
        ),
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'RequestTrackingCubit unexpected error: '
        '$error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        RequestTrackingFailure(
          message:
              localizations.unexpectedError,
        ),
      );
    }
  }

  // ==========================================
  // FILTERS
  // ==========================================

  Future<void> filterAll({
    required AppLocalizations localizations,
  }) async {
    await getMyRequests(
      localizations: localizations,
    );
  }

  Future<void> filterPending({
    required AppLocalizations localizations,
  }) async {
    await getMyRequests(
      status: 'PENDING',
      localizations: localizations,
    );
  }

  Future<void> filterAccepted({
    required AppLocalizations localizations,
  }) async {
    await getMyRequests(
      status: 'ACCEPTED',
      localizations: localizations,
    );
  }

  Future<void> filterRejected({
    required AppLocalizations localizations,
  }) async {
    await getMyRequests(
      status: 'REJECTED',
      localizations: localizations,
    );
  }

  Future<void> filterCancelled({
    required AppLocalizations localizations,
  }) async {
    await getMyRequests(
      status: 'CANCELLED',
      localizations: localizations,
    );
  }

  // ==========================================
  // RETRY
  // ==========================================

  Future<void> retry({
    required AppLocalizations localizations,
  }) async {
    String? previousStatus;

    final currentState = state;

    if (currentState
        is RequestTrackingSuccess) {
      previousStatus =
          currentState.selectedStatus;
    }

    await getMyRequests(
      status: previousStatus,
      localizations: localizations,
    );
  }

  // ==========================================
  // DIO ERROR MESSAGE
  // ==========================================

  String _extractDioMessage(
    DioException error, {
    required AppLocalizations localizations,
  }) {
    final dynamic data =
        error.response?.data;

    if (data is Map) {
      final dynamic message =
          data['message'];

      if (message is String &&
          message.trim().isNotEmpty) {
        return message;
      }

      if (message is List &&
          message.isNotEmpty) {
        return message.join('\n');
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return localizations
            .connectionTimeout;

      case DioExceptionType.connectionError:
        return localizations
            .connectionError;

      default:
        break;
    }

    switch (
        error.response?.statusCode) {
      case 400:
        return localizations
            .badRequest;

      case 401:
        return localizations
            .unauthorized;

      case 403:
        return localizations
            .forbidden;

      case 404:
        return localizations
            .notFound;

      case 500:
        return localizations
            .serverError;

      default:
        return localizations
            .requestsLoadError;
    }
  }

  // ==========================================
  // RESET
  // ==========================================

  void reset() {
    emit(
      const RequestTrackingInitial(),
    );
  }
}