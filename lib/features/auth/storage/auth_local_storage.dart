import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalStorage {
  AuthLocalStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String accessTokenKey = 'access_token';
  static const String userTypeKey = 'user_type';

  final FlutterSecureStorage _secureStorage;

  Future<void> saveToken(String token) {
    return _secureStorage.write(key: accessTokenKey, value: token.trim());
  }

  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: accessTokenKey);
    final trimmedToken = token?.trim();

    if (trimmedToken == null || trimmedToken.isEmpty) {
      return null;
    }

    return trimmedToken;
  }

  Future<void> deleteToken() {
    return _secureStorage.delete(key: accessTokenKey);
  }

  Future<void> saveUserType(String userType) {
    return _secureStorage.write(
      key: userTypeKey,
      value: normalizeUserType(userType),
    );
  }

  Future<String?> getUserType() async {
    final userType = await _secureStorage.read(key: userTypeKey);
    final normalizedUserType = normalizeUserType(userType ?? '');

    if (!isSupportedUserType(normalizedUserType)) {
      return null;
    }

    return normalizedUserType;
  }

  Future<void> deleteUserType() {
    return _secureStorage.delete(key: userTypeKey);
  }

  Future<void> saveSession({
    required String token,
    required String userType,
  }) async {
    await saveToken(token);
    await saveUserType(userType);
  }

  Future<void> deleteSession() async {
    await deleteToken();
    await deleteUserType();
  }

  static String normalizeUserType(String userType) {
    return userType.trim().toUpperCase();
  }

  static bool isSupportedUserType(String userType) {
    final normalizedUserType = normalizeUserType(userType);
    return normalizedUserType == 'DONOR' || normalizedUserType == 'BENEFICIARY';
  }
}
