import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  Future<void> load() async {
    final dark = await PreferencesService.loadDarkMode();
    if (dark != null) {
      _mode = dark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> toggle() async {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await PreferencesService.saveDarkMode(_mode == ThemeMode.dark);
  }
}