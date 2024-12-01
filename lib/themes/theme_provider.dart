import 'package:delivery_app_emilio_puigcerver/themes/dark_mode.dart';
import 'package:delivery_app_emilio_puigcerver/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode; 
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
