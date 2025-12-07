import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing and retrieving the OpenAI API key
class OpenAIConfig {
  static const _storage = FlutterSecureStorage();
  static const _apiKeyKey = 'openai_api_key';

  /// Check if API key is stored
  static Future<bool> hasApiKey() async {
    final key = await _storage.read(key: _apiKeyKey);
    return key != null && key.isNotEmpty;
  }

  /// Get the stored API key
  static Future<String?> getApiKey() async {
    return await _storage.read(key: _apiKeyKey);
  }

  /// Save the API key securely
  static Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyKey, value: apiKey);
  }

  /// Delete the stored API key
  static Future<void> deleteApiKey() async {
    await _storage.delete(key: _apiKeyKey);
  }

  /// Validate API key format (basic check)
  static bool isValidKeyFormat(String key) {
    return key.startsWith('sk-') && key.length > 20;
  }
}
