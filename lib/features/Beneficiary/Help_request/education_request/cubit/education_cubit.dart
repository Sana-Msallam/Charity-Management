import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/education_request_model.dart';
import '../service/education_request_service.dart';
import 'education_state.dart';

class EducationCubit extends Cubit<EducationState> {
  EducationCubit(
    this._educationRequestService,
  ) : super(
          const EducationInitial(),
        );

  final EducationRequestService
      _educationRequestService;

  // =================================================
  // CREATE EDUCATION REQUEST
  // =================================================

  Future<void> submitEducationRequest(
    EducationRequestModel request,
  ) async {
    if (state is EducationLoading) {
      debugPrint(
        'Education request ignored: '
        'another request is already loading',
      );

      return;
    }

    debugPrint(
      '======================================',
    );

    debugPrint(
      'EducationCubit: submit started',
    );

    debugPrint(
      '======================================',
    );

    emit(
      const EducationLoading(),
    );

    try {
      final String message =
          await _educationRequestService
              .submitEducationRequest(
        request,
      );

      debugPrint(
        'EducationCubit submit success: '
        '$message',
      );

      emit(
        EducationSuccess(
          message: message,
        ),
      );
    } on FormatException catch (
      error,
      stackTrace
    ) {
      _handleFormatException(
        error,
        stackTrace,
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      _handleDioException(
        error,
        stackTrace,
        fallbackMessage:
            'تعذر إرسال الطلب التعليمي',
      );
    } catch (
      error,
      stackTrace
    ) {
      _handleUnexpectedException(
        error,
        stackTrace,
      );
    }
  }

  // =================================================
  // UPDATE EDUCATION REQUEST
  // =================================================

  Future<void> updateEducationRequest({
    required int requestId,
    required EducationRequestModel request,
  }) async {
    if (state is EducationLoading) {
      debugPrint(
        'Education update ignored: '
        'another request is already loading',
      );

      return;
    }

    debugPrint(
      '======================================',
    );

    debugPrint(
      'EducationCubit: update started',
    );

    debugPrint(
      'Request id: $requestId',
    );

    debugPrint(
      '======================================',
    );

    emit(
      const EducationLoading(),
    );

    try {
      final String message =
          await _educationRequestService
              .updateEducationRequest(
        requestId: requestId,
        request: request,
      );

      debugPrint(
        'EducationCubit update success: '
        '$message',
      );

      emit(
        EducationSuccess(
          message: message,
        ),
      );
    } on FormatException catch (
      error,
      stackTrace
    ) {
      _handleFormatException(
        error,
        stackTrace,
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      _handleDioException(
        error,
        stackTrace,
        fallbackMessage:
            'تعذر تعديل الطلب التعليمي',
      );
    } catch (
      error,
      stackTrace
    ) {
      _handleUnexpectedException(
        error,
        stackTrace,
      );
    }
  }

  // =================================================
  // FORMAT ERROR
  // =================================================

  void _handleFormatException(
    FormatException error,
    StackTrace stackTrace,
  ) {
    debugPrint(
      'EducationCubit FormatException',
    );

    debugPrint(
      'Error: ${error.message}',
    );

    debugPrint(
      'Stack trace: $stackTrace',
    );

    emit(
      EducationFailure(
        message: error.message,
      ),
    );
  }

  // =================================================
  // DIO ERROR
  // =================================================

  void _handleDioException(
    DioException error,
    StackTrace stackTrace, {
    required String fallbackMessage,
  }) {
    debugPrint(
      'EducationCubit DioException',
    );

    debugPrint(
      'Type: ${error.type}',
    );

    debugPrint(
      'Message: ${error.message}',
    );

    debugPrint(
      'Status code: '
      '${error.response?.statusCode}',
    );

    debugPrint(
      'Response: ${error.response?.data}',
    );

    debugPrint(
      'Stack trace: $stackTrace',
    );

    emit(
      EducationFailure(
        message: _extractDioMessage(
          error,
          fallbackMessage:
              fallbackMessage,
        ),
      ),
    );
  }

  // =================================================
  // UNEXPECTED ERROR
  // =================================================

  void _handleUnexpectedException(
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint(
      'EducationCubit unexpected error',
    );

    debugPrint(
      'Error: $error',
    );

    debugPrint(
      'Stack trace: $stackTrace',
    );

    emit(
      const EducationFailure(
        message:
            'حدث خطأ غير متوقع، يرجى المحاولة مجدداً',
      ),
    );
  }

  // =================================================
  // DIO MESSAGE
  // =================================================

  String _extractDioMessage(
    DioException error, {
    required String fallbackMessage,
  }) {
    final dynamic responseData =
        error.response?.data;

    if (responseData is Map) {
      final dynamic message =
          responseData['message'];

      if (message is String &&
          message.trim().isNotEmpty) {
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
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم، تأكد من تشغيل الباك إند';

      default:
        return fallbackMessage;
    }
  }

  // =================================================
  // RESET
  // =================================================

  void reset() {
    emit(
      const EducationInitial(),
    );
  }
}