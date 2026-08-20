import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/housing_request_model.dart';
import '../service/housing_request_service.dart';
import 'housing_state.dart';

class HousingCubit extends Cubit<HousingState> {
  HousingCubit(this._housingRequestService) : super(const HousingInitial());

  final HousingRequestService _housingRequestService;

  Future<void> submitHousingRequest(HousingRequestModel request) async {
    if (state is HousingLoading) {
      debugPrint(
        'Housing request ignored: '
        'another request is already loading',
      );

      return;
    }

    debugPrint('======================================');
    debugPrint('HousingCubit: submit started');
    debugPrint('======================================');

    emit(const HousingLoading());

    try {
      final String message = await _housingRequestService.submitHousingRequest(
        request,
      );

      emit(HousingSuccess(message: message));
    } on FormatException catch (error, stackTrace) {
      debugPrint('HousingCubit FormatException');
      debugPrint('Error: ${error.message}');
      debugPrint('Stack trace: $stackTrace');

      emit(HousingFailure(message: error.message));
    } on DioException catch (error, stackTrace) {
      debugPrint('HousingCubit DioException');
      debugPrint('Type: ${error.type}');
      debugPrint('Message: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      emit(HousingFailure(message: _extractDioMessage(error)));
    } catch (error, stackTrace) {
      debugPrint('HousingCubit unexpected error');
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');

      emit(
        const HousingFailure(
          message: 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً',
        ),
      );
    }
  }

  Future<void> updateHousingRequest({
    required int requestId,
    required HousingRequestModel request,
  }) async {
    if (state is HousingLoading) {
      debugPrint(
        'Housing update ignored: '
        'another request is already loading',
      );
      return;
    }

    debugPrint('======================================');
    debugPrint('HousingCubit: update started');
    debugPrint('Request id: $requestId');
    debugPrint('======================================');

    emit(const HousingLoading());

    try {
      final String message = await _housingRequestService.updateHousingRequest(
        requestId: requestId,
        request: request,
      );

      emit(HousingSuccess(message: message));
    } on FormatException catch (error, stackTrace) {
      debugPrint('HousingCubit update FormatException');
      debugPrint('Error: ${error.message}');
      debugPrint('Stack trace: $stackTrace');

      emit(HousingFailure(message: error.message));
    } on DioException catch (error, stackTrace) {
      debugPrint('HousingCubit update DioException');
      debugPrint('Type: ${error.type}');
      debugPrint('Message: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      emit(
        HousingFailure(
          message: _extractDioMessage(
            error,
            fallbackMessage: 'تعذر تعديل الطلب السكني',
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('HousingCubit update unexpected error');
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');

      emit(
        const HousingFailure(
          message: 'حدث خطأ غير متوقع، يرجى المحاولة مجدداً',
        ),
      );
    }
  }

  String _extractDioMessage(
    DioException error, {
    String fallbackMessage = 'تعذر إرسال الطلب السكني',
  }) {
    final dynamic responseData = error.response?.data;

    if (responseData is Map) {
      final dynamic message = responseData['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      if (message is List && message.isNotEmpty) {
        return message.join('\n');
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

  void reset() {
    emit(const HousingInitial());
  }
}
