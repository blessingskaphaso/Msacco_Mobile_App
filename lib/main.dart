import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Import the splash screen

void main() {
  runApp(const MyApp());
}

// Define Army Green color
const Color armyGreen = Color.fromRGBO(15, 65, 36, 1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MSACCO App',
      themeMode:
          ThemeMode.system, // Automatically switch based on phone's theme
      theme: ThemeData(
        brightness:
            Brightness.light, // Set brightness to light for the light theme
        primaryColor: armyGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: armyGreen,
          brightness:
              Brightness.light, // Ensure the brightness matches the light theme
          primary: armyGreen,
          onPrimary: Colors.white,
          secondary: Colors.grey[600], // Secondary color for light mode
        ),
        scaffoldBackgroundColor: Colors.white, // Background for light mode
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness:
            Brightness.dark, // Set brightness to dark for the dark theme
        primaryColor: armyGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: armyGreen,
          brightness:
              Brightness.dark, // Ensure the brightness matches the dark theme
          primary: armyGreen,
          onPrimary: Colors.white,
          secondary: Colors.grey[300], // Secondary color for dark mode
        ),
        scaffoldBackgroundColor: Colors.black, // Background for dark mode
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
