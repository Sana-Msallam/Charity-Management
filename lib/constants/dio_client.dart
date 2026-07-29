import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';

class DioClient {
  DioClient._();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'accept-language': 'ar',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint('======================================');
            debugPrint('DIO REQUEST');
            debugPrint(
              '${options.method} ${options.uri}',
            );
            debugPrint(
              'Content-Type: ${options.contentType}',
            );

            final authorization =
                options.headers['Authorization'];

            debugPrint(
              'Authorization exists: '
              '${authorization != null}',
            );

            // لا نطبع التوكن كاملًا.
            final safeHeaders =
                Map<String, dynamic>.from(
              options.headers,
            );

            if (safeHeaders.containsKey(
              'Authorization',
            )) {
              safeHeaders['Authorization'] =
                  'Bearer ***';
            }

            debugPrint(
              'Headers: $safeHeaders',
            );

            if (options.data is FormData) {
              final formData =
                  options.data as FormData;

              debugPrint('FormData fields:');

              for (final field
                  in formData.fields) {
                debugPrint(
                  '${field.key}: ${field.value}',
                );
              }

              debugPrint('FormData files:');

              for (final file in formData.files) {
                debugPrint(
                  '${file.key}: '
                  '${file.value.filename}, '
                  '${file.value.length} bytes',
                );
              }
            } else {
              debugPrint(
                'Request data: ${options.data}',
              );
            }

            debugPrint('======================================');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('======================================');
            debugPrint('DIO RESPONSE');
            debugPrint(
              'URL: ${response.requestOptions.uri}',
            );
            debugPrint(
              'Status code: ${response.statusCode}',
            );
            debugPrint(
              'Response data: ${response.data}',
            );
            debugPrint('======================================');
          }

          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint('======================================');
            debugPrint('DIO ERROR');
            debugPrint(
              'URL: ${error.requestOptions.uri}',
            );
            debugPrint(
              'Method: ${error.requestOptions.method}',
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
            debugPrint('======================================');
          }

          handler.next(error);
        },
      ),
    );
}