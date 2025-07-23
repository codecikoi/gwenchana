import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String languageKey = 'selected_language';
  static const String authTokenKey = 'auth_token';
  static const String userNameKey = 'user_name';

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<void> clearUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, language);
  }

  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageKey);
  }

  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(authTokenKey, token);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenKey);
  }

  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(authTokenKey);
  }

  Future<void> saveToken(String token) async {
    await setAuthToken(token);
  }
}
