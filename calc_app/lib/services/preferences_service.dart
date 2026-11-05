import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _themeKey = 'dark_mode';
  static const _fromKey = 'converter_from';
  static const _toKey = 'converter_to';

  static Future<bool?> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey);
  }

  static Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }

  static Future<({String? from, String? to})> loadConverterPair() async {
    final prefs = await SharedPreferences.getInstance();
    return (from: prefs.getString(_fromKey), to: prefs.getString(_toKey));
  }

  static Future<void> saveConverterPair(String from, String to) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fromKey, from);
    await prefs.setString(_toKey, to);
  }
}