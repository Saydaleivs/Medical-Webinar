import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? _cachedToken;
  static String? _cachedRole;

  static Future<String?> getToken() async {
    // Check if token is already cached
    if (_cachedToken != null) {
      return _cachedToken;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString('token');
    return _cachedToken;
  }

  static Future<String?> getRole() async {
    // Check if role is already cached
    if (_cachedRole != null) {
      return _cachedRole;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedRole = prefs.getString('role');
    return _cachedRole;
  }

  // Method to clear cached token and role
  static void clearCache() {
    _cachedToken = null;
    _cachedRole = null;

    // then clear it from cookies
    clearUserData();
  }

  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
  }
}
