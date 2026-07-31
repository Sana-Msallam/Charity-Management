import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';

class ApiException {
  static String getMessage(DioException error, AppLocalizations localizations) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return localizations.connectionTimeout;
    }

    if (error.type == DioExceptionType.connectionError) {
      return localizations.connectionError;
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
        return localizations.badRequest;
      case 401:
        return localizations.unauthorized;
      case 403:
        return localizations.forbidden;
      case 404:
        return localizations.notFound;
      case 500:
        return localizations.serverError;
      default:
        return localizations.unexpectedError;
    }
  }
}
