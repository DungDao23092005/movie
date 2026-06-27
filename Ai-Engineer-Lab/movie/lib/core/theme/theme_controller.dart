import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.system);

  static const String _themeKey = "app_theme_mode";

  AppThemeMode _currentMode = AppThemeMode.system;

  AppThemeMode get currentMode => _currentMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final value = prefs.getString(_themeKey);

    switch (value) {
      case "light":
        _currentMode = AppThemeMode.light;
        this.value = ThemeMode.light;
        break;

      case "dark":
        _currentMode = AppThemeMode.dark;
        this.value = ThemeMode.dark;
        break;

      default:
        _currentMode = AppThemeMode.system;
        this.value = ThemeMode.system;
        break;
    }
  }

  Future<void> setTheme(
    AppThemeMode mode,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    _currentMode = mode;

    switch (mode) {
      case AppThemeMode.light:
        value = ThemeMode.light;
        await prefs.setString(
          _themeKey,
          "light",
        );
        break;

      case AppThemeMode.dark:
        value = ThemeMode.dark;
        await prefs.setString(
          _themeKey,
          "dark",
        );
        break;

      case AppThemeMode.system:
        value = ThemeMode.system;
        await prefs.setString(
          _themeKey,
          "system",
        );
        break;
    }
  }
}

final themeController = ThemeController();