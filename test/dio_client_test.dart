import 'dart:async';

import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:charity_management/features/auth/storage/auth_local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      AuthLocalStorage.accessTokenKey: 'test-token',
    });
  });

  test('adds Authorization to protected endpoints', () async {
    final headers = await _captureHeadersFor(ApiConstants.profile);

    expect(headers['Authorization'], 'Bearer test-token');
  });

  test('does not add Authorization to public endpoints', () async {
    final headers = await _captureHeadersFor(ApiConstants.aidRequests);

    expect(headers.containsKey('Authorization'), isFalse);
  });

  test('adds Authorization to aid request payment endpoint', () async {
    final headers = await _captureHeadersFor(
      ApiConstants.aidRequestPaymentIntent(42),
    );

    expect(headers['Authorization'], 'Bearer test-token');
  });
}

Future<Map<String, dynamic>> _captureHeadersFor(String path) async {
  final completer = Completer<Map<String, dynamic>>();
  late final Interceptor interceptor;

  interceptor = InterceptorsWrapper(
    onRequest: (options, handler) {
      completer.complete(Map<String, dynamic>.from(options.headers));
      handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
          data: const {},
        ),
      );
    },
  );

  DioClient.dio.interceptors.add(interceptor);

  try {
    await DioClient.dio.get<dynamic>(path);
    return completer.future;
  } finally {
    DioClient.dio.interceptors.remove(interceptor);
  }
}
