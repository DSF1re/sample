import 'package:flutter/material.dart';

abstract class SettingsRepository {
  bool get isDarkMode;
  ThemeMode toggleThemeMode();
}
