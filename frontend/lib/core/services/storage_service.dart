import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'accessToken';
  static const _refreshokenKey = 'refreshToken';

  // Save token after login
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Get token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshokenKey, value: token);
  }

  // Get token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshokenKey);
  }

  // Delete token on logout
  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshokenKey);
  }
}