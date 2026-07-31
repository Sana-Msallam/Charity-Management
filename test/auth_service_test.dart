import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:charity_management/features/auth/storage/auth_local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('login saves access token and normalized user type securely', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<dynamic>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'access_token': 'secure-token',
                  'user': {
                    'id': 7,
                    'firstName': 'Sara',
                    'lastName': 'Ahmad',
                    'countryCode': '+963',
                    'number': '999999999',
                    'type': 'donor',
                  },
                },
              ),
            );
          },
        ),
      );
    final storage = AuthLocalStorage();
    final service = AuthService(dio: dio, localStorage: storage);

    final response = await service.login(
      phoneNumber: '+963999999999',
      password: 'password',
      invalidResponseMessage: 'Invalid response',
      missingTokenMessage: 'Missing token',
    );

    expect(response.accessToken, 'secure-token');
    expect(response.user.type, 'DONOR');
    expect(await storage.getToken(), 'secure-token');
    expect(await storage.getUserType(), 'DONOR');
  });
}
