import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static String email = 'email';
  static String password = 'password';
  static String isCreateAdPopShowed = 'isCreateAdPopShowed';

  static Future<String> setEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(email, value);
    return value;
  }

  static Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(email);
  }

  static Future<String> setPassword(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(password, value);
    return value;
  }

  static Future<String> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(password);
  }

  static Future<bool> setIsCreateAdPopShowed(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isCreateAdPopShowed, value);
    return value;
  }

  static Future<bool> getIsCreateAdPopShowed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isCreateAdPopShowed);
  }

  static Future<bool> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
