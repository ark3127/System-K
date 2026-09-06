import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _apiKeyStorageKey = 'nvidia_api_key';

  final _storage = const FlutterSecureStorage();

  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyStorageKey, value: apiKey);
  }

  Future<String?> getApiKey() async {
    return await _storage.read(key: _apiKeyStorageKey);
  }

  Future<void> deleteApiKey() async {
    await _storage.delete(key: _apiKeyStorageKey);
  }
}
