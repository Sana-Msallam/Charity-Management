import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';

class ChangePasswordService {
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String fallbackMessage,
  }) async {
    debugPrint('======================================');
    debugPrint('START CHANGE PASSWORD');
    debugPrint('Endpoint: ${ApiConstants.profilePassword}');
    debugPrint('Request method: PATCH');

    try {
      final _RedactedPasswordPayload payload =
          _RedactedPasswordPayload(<String, dynamic>{
            'currentPassword': currentPassword,
            'newPassword': newPassword,
            'confirmPassword': confirmPassword,
          });

      final Response<dynamic> response = await DioClient.dio.patch<dynamic>(
        ApiConstants.profilePassword,
        data: payload,
        options: Options(contentType: Headers.jsonContentType),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.data}');
      debugPrint('======================================');

      final dynamic data = response.data;
      if (data is Map) {
        final dynamic message = data['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }

      return fallbackMessage;
    } on DioException catch (error, stackTrace) {
      debugPrint('CHANGE PASSWORD DIO ERROR');
      debugPrint('Dio error type: ${error.type}');
      debugPrint('Backend error response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('UNEXPECTED CHANGE PASSWORD ERROR');
      debugPrint('Error type: ${error.runtimeType}');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');
      rethrow;
    }
  }
}

class _RedactedPasswordPayload extends MapBase<String, dynamic> {
  _RedactedPasswordPayload(this._values);

  final Map<String, dynamic> _values;

  @override
  dynamic operator [](Object? key) => _values[key];

  @override
  void operator []=(String key, dynamic value) {
    _values[key] = value;
  }

  @override
  void clear() {
    _values.clear();
  }

  @override
  Iterable<String> get keys => _values.keys;

  @override
  dynamic remove(Object? key) => _values.remove(key);

  @override
  String toString() => '{password fields: [REDACTED]}';
}
