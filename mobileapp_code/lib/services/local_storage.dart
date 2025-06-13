import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplockService {
  static const String _appLockKey = 'app_lock_enabled';
  static const String _passcodeKey = 'app_lock_passcode';
  static const String _secretKey = 'recovery_secret_key';


  /// --------------- current app lock status
  static Future<bool> isAppLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_appLockKey) ?? false;
  }

  /// ---------------  enable/disable app lock
  static Future<void> setAppLockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_appLockKey, value);

    // If disabling app lock, clear passcode
    if (!value) {
      await prefs.remove(_passcodeKey);
    }
  }

  /// ---------------  Save the new passcode
  static Future<void> savePasscode(String passcode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passcodeKey, passcode);
  }

  /// --------------- fetch saved passcode
  static Future<String?> getPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passcodeKey);
  }

  ///  --------------- remove passcode manually
  static Future<void> clearPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_passcodeKey);
  }

  /// ---------------  Save the secret key
  static Future<void> setSecretKey(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_secretKey, value);
  }

  /// ---------------  get the saved secret key
  static Future<String?> getSecretKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_secretKey);
  }

  /// ---------------  Delete the saved secret key
  static Future<void> clearSecretKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_secretKey);
  }
}

/// --------------- for the theme

class ThemeService extends ChangeNotifier {
  static const _themeKey = 'is_dark_theme';
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeService() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkTheme);
    notifyListeners();
  }

  ThemeMode get currentThemeMode => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;
}