import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelperMyRequest {
  // 🔹 Call this on login to clear all previously saved API data
  static Future<void> clearApiCacheOnLogin() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ Remove all saved API-related data keys
    await prefs.remove('lastApiCallDateMyRequest');
    await prefs.remove('calendarDataMyRequest');
    await prefs.remove('calendarMonthMyRequest');

  }
}