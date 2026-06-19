import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/repository/theme/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.prefs});
  final SharedPreferences prefs;

  @override
  bool get isDarkMode => prefs.getBool('is_dark_mode') ?? false;

  @override
  ThemeMode toggleThemeMode() {
    final newValue = !isDarkMode;
    prefs.setBool('is_dark_mode', newValue);
    return newValue ? ThemeMode.dark : ThemeMode.light;
  }
}
