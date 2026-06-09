import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const storage= FlutterSecureStorage();



  static Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  static Future<void> saveUserId(String userId) async {

    await storage.write(
      key: 'user_id',
      value: userId,
    );
  }

  static Future<String?> getUserId()
  async {
    return await storage.read(
      key: 'user_id',
    );
  }

  static Future<void> clear() async {
    await storage.deleteAll();
  }
}