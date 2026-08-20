import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/cancel_request_service.dart';
import 'cancel_request_state.dart';

class CancelRequestCubit
    extends Cubit<CancelRequestState> {
  CancelRequestCubit(
    this._cancelRequestService,
  ) : super(
          const CancelRequestInitial(),
        );

  final CancelRequestService
      _cancelRequestService;

  Future<void> cancelRequest({
    required int requestId,
    required AppLocalizations localizations,
  }) async {
    if (state
        is CancelRequestLoading) {
      return;
    }

    debugPrint(
      'CancelRequestCubit: cancelRequest',
    );

    debugPrint(
      'Request id: $requestId',
    );

    emit(
      const CancelRequestLoading(),
    );

    try {
      final String message =
          await _cancelRequestService
              .cancelRequest(
        requestId: requestId,
      );

      debugPrint(
        'Cancel request succeeded',
      );

      debugPrint(
        'Message: $message',
      );

      emit(
        CancelRequestSuccess(
          message: message,
          requestId:
              requestId,
        ),
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'CancelRequestCubit DioException: '
        '${error.message}',
      );

      debugPrint(
        'Response: '
        '${error.response?.data}',
      );

      debugPrint(
        'Status code: '
        '${error.response?.statusCode}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        CancelRequestFailure(
          message:
              _extractDioMessage(
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
        'CancelRequestCubit unexpected error: '
        '$error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        CancelRequestFailure(
          message:
              localizations
                  .unexpectedError,
        ),
      );
    }
  }

  String _extractDioMessage(
    DioException error, {
    required AppLocalizations
        localizations,
  }) {
    final dynamic data =
        error.response?.data;

    // إذا الباك رجّع message
    // منعرضها مباشرة.
    if (data is Map) {
      final dynamic message =
          data['message'];

      if (message is String &&
          message
              .trim()
              .isNotEmpty) {
        return message;
      }

      if (message is List &&
          message.isNotEmpty) {
        return message.join(
          '\n',
        );
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
            .unexpectedError;
    }
  }

  void reset() {
    emit(
      const CancelRequestInitial(),
    );
  }
}