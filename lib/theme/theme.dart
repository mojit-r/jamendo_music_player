import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// 1. RIVERPOD THEME STATE & NOTIFIER
// ==========================================

class ThemeState {
  final ThemeMode themeMode;
  final IconData themeIcon;

  const ThemeState({required this.themeMode, required this.themeIcon});
}

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return const ThemeState(
      themeMode: ThemeMode.light,
      themeIcon: Icons.dark_mode_outlined,
    );
  }

  void themeChanger() {
    if (state.themeMode == ThemeMode.light) {
      state = const ThemeState(
        themeMode: ThemeMode.dark,
        themeIcon: Icons.light_mode_outlined,
      );
    } else {
      state = const ThemeState(
        themeMode: ThemeMode.light,
        themeIcon: Icons.dark_mode_outlined,
      );
    }
  }
}

// Global provider to read and watch theme states
final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(() {
  return ThemeNotifier();
});

// ==========================================
// 2. THEME DATA CONFIGURATION
// ==========================================

final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.red,
  brightness: Brightness.light,
);

final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.red,
  brightness: Brightness.dark,
);

final ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
  ),
);

final ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.primary,
    foregroundColor: darkColorScheme.onPrimary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkColorScheme.primary,
    foregroundColor: darkColorScheme.onPrimary,
  ),
);
