import 'package:shared_preferences/shared_preferences.dart';

class ApplockService {
  static const String _appLockKey = 'app_lock_enabled';

  /// Get the stored value (or return false if not set yet)
  static Future<bool> isAppLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_appLockKey) ?? false;
  }

  /// Save the app lock value
  static Future<void> setAppLockEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_appLockKey, value);
  }
}
