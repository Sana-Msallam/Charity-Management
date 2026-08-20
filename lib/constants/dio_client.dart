import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../features/auth/storage/auth_local_storage.dart';
import 'api_constants.dart';

class DioClient {
  DioClient._();

  static const String _defaultLanguageCode = 'en';
  static final AuthLocalStorage _authLocalStorage = AuthLocalStorage();

  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
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
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_shouldAttachToken(options)) {
            final token = await _authLocalStorage.getToken();

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: false,
          responseBody: true,
          responseHeader: false,
          error: true,
        ),
      );
    }

    return dio;
  }

  static void setLanguage(String languageCode) {
    final normalizedLanguageCode = languageCode == 'ar' ? 'ar' : 'en';
    dio.options.headers['accept-language'] = normalizedLanguageCode;
  }

  static bool _shouldAttachToken(RequestOptions options) {
    final hasAuthorizationHeader = options.headers.keys.any(
      (key) => key.toString().toLowerCase() == 'authorization',
    );

    if (hasAuthorizationHeader) {
      return false;
    }

    return !_isPublicEndpoint(options.uri.path);
  }

  static bool _isPublicEndpoint(String path) {
   final publicExactPaths = <String>{
  ApiConstants.login,
  ApiConstants.registerDonor,
  ApiConstants.registerBeneficiary,
  ApiConstants.verifyOtp,
  ApiConstants.requestPasswordResetOtp,
  ApiConstants.resetPassword,
  ApiConstants.aidRequests,
  ApiConstants.completedAidRequests,
};
    if (publicExactPaths.contains(path)) {
      return true;
    }

    return path.startsWith('${ApiConstants.aidRequests}/');
  }
  static Future<Response<dynamic>> patch(
  String path, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
}) {
  return dio.patch(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );
}
}
