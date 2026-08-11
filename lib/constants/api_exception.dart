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
        return _formatMessageList(message);
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

  static String _formatMessageList(List<dynamic> messages) {
    final formattedMessages = <String>[];

    for (final message in messages) {
      if (message is String) {
        formattedMessages.add(message);
        continue;
      }

      if (message is Map<String, dynamic>) {
        final constraints = message['constraints'];

        if (constraints is Map) {
          formattedMessages.addAll(
            constraints.values.whereType<String>().where(
              (value) => value.trim().isNotEmpty,
            ),
          );
          continue;
        }

        final nestedMessages = message['children'];
        if (nestedMessages is List && nestedMessages.isNotEmpty) {
          formattedMessages.add(_formatMessageList(nestedMessages));
          continue;
        }
      }

      formattedMessages.add(message.toString());
    }

    final uniqueMessages = formattedMessages
        .map((message) => message.trim())
        .where((message) => message.isNotEmpty)
        .toSet()
        .toList();

    return uniqueMessages.join('\n');
  }
}
