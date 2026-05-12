import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  // Toggle theme
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  // Get current theme
  ThemeMode get themeMode {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }
}