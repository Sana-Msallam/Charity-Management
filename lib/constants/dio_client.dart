import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';

class DioClient {
  DioClient._();

  static const String _defaultLanguageCode = 'en';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'accept-language': _defaultLanguageCode,
      },
    ),
  )..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );

  static void setLanguage(String languageCode) {
    final normalizedLanguageCode = languageCode == 'ar' ? 'ar' : 'en';
    dio.options.headers['accept-language'] = normalizedLanguageCode;
  }
}
