import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../constants/dio_client.dart';

class CancelRequestService {
  Future<String> cancelRequest({
    required int requestId,
  }) async {
    debugPrint('======================================');
    debugPrint('START CANCEL REQUEST');
    debugPrint('Request id: $requestId');
    debugPrint('======================================');

    try {
      final Response<dynamic> response =
          await DioClient.dio.delete<dynamic>(
        '/requests/cancel/$requestId',
      );

      debugPrint(
        'Cancel request response received',
      );

      debugPrint(
        'Status code: ${response.statusCode}',
      );

      debugPrint(
        'Response data: ${response.data}',
      );

      final dynamic data = response.data;

      if (data is Map) {
        final dynamic message = data['message'];

        if (message is String &&
            message.trim().isNotEmpty) {
          return message;
        }
      }

      return 'تم إلغاء الطلب بنجاح';
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'DIO ERROR WHILE CANCELLING REQUEST',
      );

      debugPrint(
        'Error type: ${error.type}',
      );

      debugPrint(
        'Error message: ${error.message}',
      );

      debugPrint(
        'Status code: ${error.response?.statusCode}',
      );

      debugPrint(
        'Response data: ${error.response?.data}',
      );

      debugPrint(
        'Request URL: ${error.requestOptions.uri}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint('======================================');

      rethrow;
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'UNEXPECTED CANCEL REQUEST ERROR',
      );

      debugPrint(
        'Error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint('======================================');

      rethrow;
    }
  }
}