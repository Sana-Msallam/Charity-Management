import 'package:charity_management/features/Beneficiary/Help_request/housing_request/service/housing_request_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/housing_request_model.dart';
import 'housing_state.dart';

class HousingCubit extends Cubit<HousingState> {
  HousingCubit(
    this._housingRequestService,
  ) : super(const HousingInitial());

  final HousingRequestService
      _housingRequestService;

  Future<void> submitHousingRequest(
    HousingRequestModel request,
  ) async {
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
      final String message =
          await _housingRequestService
              .submitHousingRequest(request);

      emit(
        HousingSuccess(
          message: message,
        ),
      );
    } on FormatException catch (error, stackTrace) {
      debugPrint(
        'HousingCubit FormatException',
      );
      debugPrint(
        'Error: ${error.message}',
      );
      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        HousingFailure(
          message: error.message,
        ),
      );
    } on DioException catch (error, stackTrace) {
      debugPrint(
        'HousingCubit DioException',
      );
      debugPrint(
        'Type: ${error.type}',
      );
      debugPrint(
        'Message: ${error.message}',
      );
      debugPrint(
        'Response: ${error.response?.data}',
      );
      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        HousingFailure(
          message: _extractDioMessage(error),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'HousingCubit unexpected error',
      );
      debugPrint(
        'Error: $error',
      );
      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        const HousingFailure(
          message:
              'حدث خطأ غير متوقع، يرجى المحاولة مجدداً',
        ),
      );
    }
  }

  String _extractDioMessage(
    DioException error,
  ) {
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
        return 'تعذر إرسال الطلب السكني';
    }
  }

  void reset() {
    emit(const HousingInitial());
  }
}