import 'package:dio/dio.dart';

class ApiException {
  static String getMessage(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال بالخادم';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم، تأكد من الإنترنت وعنوان الخادم';
    }

    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];

      if (message is String) {
        return message;
      }

      if (message is List) {
        return message.join('\n');
      }
    }

    switch (error.response?.statusCode) {
      case 400:
        return 'البيانات المدخلة غير صحيحة';

      case 401:
        return 'رقم الهاتف أو كلمة المرور غير صحيحة';

      case 403:
        return 'لا تملك صلاحية لتنفيذ هذه العملية';

      case 404:
        return 'المستخدم غير موجود';

      case 500:
        return 'حدث خطأ في الخادم';

      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}