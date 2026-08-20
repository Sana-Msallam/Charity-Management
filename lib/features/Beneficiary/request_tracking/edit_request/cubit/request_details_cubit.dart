import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/request_details_model.dart';
import '../../service/request_tracking_service.dart';
import 'request_details_state.dart';

class RequestDetailsCubit
    extends Cubit<RequestDetailsState> {
  RequestDetailsCubit(
    this._requestTrackingService,
  ) : super(
          const RequestDetailsInitial(),
        );

  final RequestTrackingService
      _requestTrackingService;

  Future<void> getRequestDetails({
    required int requestId,
    required AppLocalizations localizations,
  }) async {
    if (state is RequestDetailsLoading) {
      return;
    }

    debugPrint(
      '======================================',
    );

    debugPrint(
      'RequestDetailsCubit: getRequestDetails',
    );

    debugPrint(
      'Request id: $requestId',
    );

    debugPrint(
      '======================================',
    );

    emit(
      const RequestDetailsLoading(),
    );

    try {
      final RequestDetailsModel request =
          await _requestTrackingService
              .getRequestDetails(
        requestId: requestId,
      );

      debugPrint(
        'RequestDetailsCubit success',
      );

      debugPrint(
        'Request id: ${request.id}',
      );

      debugPrint(
        'Category: ${request.category.name}',
      );

      debugPrint(
        'Aid details: ${request.aidDetails}',
      );

      emit(
        RequestDetailsSuccess(
          request: request,
        ),
      );
    } on FormatException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'RequestDetailsCubit FormatException: '
        '${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        RequestDetailsFailure(
          message:
              localizations.requestDetailsLoadFailed,
        ),
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'RequestDetailsCubit DioException: '
        '${error.message}',
      );

      debugPrint(
        'Status code: '
        '${error.response?.statusCode}',
      );

      debugPrint(
        'Response: '
        '${error.response?.data}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        RequestDetailsFailure(
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
        'RequestDetailsCubit unexpected error: '
        '$error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        RequestDetailsFailure(
          message:
              localizations.unexpectedError,
        ),
      );
    }
  }

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
            .requestDetailsLoadFailed;
    }
  }

  void reset() {
    emit(
      const RequestDetailsInitial(),
    );
  }
}