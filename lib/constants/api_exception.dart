import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiException {
  static String getMessage(DioException error) {
    debugPrint('ApiException.getMessage called');
    debugPrint('Dio error type: ${error.type}');
    debugPrint(
      'Status code: ${error.response?.statusCode}',
    );
    debugPrint(
      'Response data: ${error.response?.data}',
    );

    if (error.type ==
            DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type ==
            DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال بالخادم';
    }

    if (error.type ==
        DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم، تأكد من الإنترنت وعنوان الخادم';
    }

    if (error.type ==
        DioExceptionType.badCertificate) {
      return 'تعذر التحقق من أمان الاتصال بالخادم';
    }

    if (error.type == DioExceptionType.cancel) {
      return 'تم إلغاء الطلب';
    }

    final responseData = error.response?.data;

    if (responseData is Map) {
      final message = responseData['message'];

      if (message is String &&
          message.trim().isNotEmpty) {
        return message;
      }

      if (message is List) {
        return message
            .map((item) => item.toString())
            .join('\n');
      }

      final errorMessage = responseData['error'];

      if (errorMessage is String &&
          errorMessage.trim().isNotEmpty) {
        return errorMessage;
      }
    }

    switch (error.response?.statusCode) {
      case 400:
        return 'البيانات المدخلة غير صحيحة';

      case 401:
        return 'انتهت جلسة تسجيل الدخول، يرجى تسجيل الدخول مجدداً';

      case 403:
        return 'لا تملك صلاحية لتنفيذ هذه العملية';

      case 404:
        return 'المسار المطلوب غير موجود';

      case 409:
        return 'يوجد تعارض في البيانات المرسلة';

      case 413:
        return 'حجم الملفات المرفقة كبير جداً';

      case 415:
        return 'نوع الملف المرفق غير مدعوم';

      case 422:
        return 'بعض البيانات المرسلة غير صالحة';

      case 500:
        return 'حدث خطأ داخلي في الخادم';

      case 502:
      case 503:
        return 'الخادم غير متاح حالياً، يرجى المحاولة لاحقاً';

      default:
        return error.message ??
            'حدث خطأ غير متوقع';
    }
  }
}