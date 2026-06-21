import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/theme/theme_provider.dart';
import 'package:todo/core/router/router.dart';
import 'package:todo/core/theme/colors.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final colorIndex = ref.watch(colorIndexProvider);
    final seedColor = seedColors[colorIndex];

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: seedColor,
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: 'Unbounded',
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: seedColor,
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Unbounded',
      ),
      themeMode: themeMode,
      routerConfig: router,
      title: 'TODO',
    );
  }
}
