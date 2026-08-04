import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  // 🔹 Call this on login to clear all previously saved API data
  static Future<void> clearApiCacheOnLogin() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ Remove all saved API-related data keys
    await prefs.remove('lastApiCallDate');
    await prefs.remove('eventsListModalData');
    await prefs.remove('todayEventModalData');
    await prefs.remove('holidayData');
    await prefs.remove('calendarData');
    await prefs.remove('calendarMonth');
    await prefs.remove('dashboardData');

    print("🧹 Cleared cached API data on login");
  }
}