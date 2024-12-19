import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart'; // Add this import
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  debugPrint('App initialized with token: ${AppConfig.token}');

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MSACCO App',
          theme: themeProvider.theme,
          themeMode: themeProvider.themeMode,
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
                borderSide: BorderSide(color: armyGreen),
              ),
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
