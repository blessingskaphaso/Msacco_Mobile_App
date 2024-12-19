import 'package:flutter/material.dart';
import 'package:msacco/config/config.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = AppConfig.isDarkMode;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    await AppConfig.saveTheme(value);
    notifyListeners();
  }

  ThemeData get theme => _isDarkMode ? _darkTheme : _lightTheme;

  // Define Army Green color used throughout the app
  static const Color armyGreen = Color.fromRGBO(15, 65, 36, 1);

  // Light theme
  static final _lightTheme = ThemeData(
    primaryColor: armyGreen,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: armyGreen,
      elevation: 0,
    ),
  );

  // Dark theme
  static final _darkTheme = ThemeData(
    primaryColor: armyGreen,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: armyGreen,
      elevation: 0,
    ),
  );
}
