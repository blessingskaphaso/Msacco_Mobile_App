import 'package:flutter/material.dart';
import 'package:msacco/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart'; // Add this import
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();

  // Wrap the app with MultiProvider instead of single ChangeNotifierProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (_) => AuthProvider()), // Add AuthProvider
      ],
      child: const MyApp(),
    ),
  );
}

// Define Army Green color used throughout the app
const Color armyGreen = Color.fromRGBO(15, 65, 36, 1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme settings using the ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MSACCO App',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: armyGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: armyGreen,
          brightness: Brightness.light,
          primary: armyGreen,
          onPrimary: Colors.white,
          secondary: Colors.grey[600],
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        // Add elevation settings for Material 3
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: armyGreen,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        // Add input decoration theme for consistent text fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: armyGreen),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: armyGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: armyGreen,
          brightness: Brightness.dark,
          primary: armyGreen,
          onPrimary: Colors.white,
          secondary: Colors.grey[300],
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        // Add elevation settings for Material 3 in dark mode
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: armyGreen,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        // Add input decoration theme for consistent text fields in dark mode
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: armyGreen),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
