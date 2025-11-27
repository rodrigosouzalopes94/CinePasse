import 'package:flutter/material.dart';

class ThemeController with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Método auxiliar para obter o ThemeMode correto
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}