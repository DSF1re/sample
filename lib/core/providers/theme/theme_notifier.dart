import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';
import 'package:todo/core/repository/theme/settings_repository.dart';
import 'package:todo/core/repository/theme/settings_repository_impl.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs: prefs);
});

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final repo = ref.read(settingsRepositoryProvider);
    state = repo.toggleThemeMode();
  }
}
