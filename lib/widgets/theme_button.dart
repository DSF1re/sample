import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/theme/theme_provider.dart';

class ThemeButton extends ConsumerWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;
    return IconButton(
      onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
    );
  }
}
