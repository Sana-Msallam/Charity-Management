import 'package:charity_management/features/Beneficiary/Help_request/food_request/service/food_request_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/food_request_model.dart';
import 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit(
    this._foodRequestService,
  ) : super(const FoodInitial());

  final FoodRequestService _foodRequestService;

  Future<void> submitFoodRequest(
    FoodRequestModel request,
  ) async {
    if (state is FoodLoading) {
      return;
    }

    emit(const FoodLoading());

    try {
      final String message =
          await _foodRequestService
              .submitFoodRequest(request);

      emit(
        FoodSuccess(
          message: message,
        ),
      );
    } on FormatException catch (error, stackTrace) {
      debugPrint(
        'FoodCubit FormatException: ${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        FoodFailure(
          message: error.message,
        ),
      );
    } on DioException catch (error, stackTrace) {
      debugPrint(
        'FoodCubit DioException: ${error.message}',
      );

      debugPrint(
        'Response: ${error.response?.data}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        FoodFailure(
          message: _extractDioMessage(error),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'FoodCubit unexpected error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        const FoodFailure(
          message:
              'حدث خطأ غير متوقع، يرجى المحاولة مجدداً',
        ),
      );
    }
  }

  String _extractDioMessage(
    DioException error,
  ) {
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
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم، تأكد من تشغيل الباك إند';

      default:
        return 'تعذر إرسال الطلب الغذائي';
    }
  }

  void reset() {
    emit(const FoodInitial());
  }
}