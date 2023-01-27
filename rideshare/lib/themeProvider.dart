import 'package:flutter/material.dart';
import 'package:rideshare/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  String currentTheme = 'system';
  ThemeMode get themeMode {
    if (currentTheme == 'light') {
      return ThemeMode.light;
    } else if (currentTheme == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  bool get isSystem {
    if (currentTheme == 'system') {
      return true;
    } else {
      return false;
    }
  }

  bool get isDark {
    if (currentTheme == 'dark') {
      return true;
    } else {
      return false;
    }
  }

  changeSystemTheme(bool isOn) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (isOn == true) {
      currentTheme = 'system';
    } else {
      currentTheme = 'light';
    }
    await _prefs.setString('theme', currentTheme);
    notifyListeners();
  }

  changeDarkTheme(bool isOn) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (isOn == true) {
      currentTheme = 'dark';
    } else {
      currentTheme = 'light';
    }
    await _prefs.setString('theme', currentTheme);
    notifyListeners();
  }

  initialze() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    currentTheme = _prefs.getString('theme') ?? 'system';
    notifyListeners();
  }
}
