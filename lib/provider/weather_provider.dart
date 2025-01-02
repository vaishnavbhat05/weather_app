import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const _cityKey = 'city';

  // Save city name to shared preferences
  static Future<void> saveCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityKey, cityName);
  }

  // Get city name from shared preferences
  static Future<String?> getCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cityKey);
  }
}
