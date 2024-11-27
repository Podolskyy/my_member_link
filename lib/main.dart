import 'package:flutter/material.dart';
import 'views/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Member Link',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E1E1E), // Darker primary base
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF0844F4),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFF4D73FF),
          secondary: Colors.blue[600]!,
          onSecondary: Colors.white,
          background: const Color(0xFFF1F1F1), // Light background for contrast
          onBackground: Colors.black87,
          surface: const Color(0xFFE0E0E0), // Light surface color
          onSurface: Colors.black87,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0844F4), // Base color for dark mode
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF4D73FF),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFF0844F4),
          secondary: Colors.blue[200]!,
          onSecondary: Colors.black,
          background: const Color(0xFF121212), // Dark background color
          onBackground: Colors.white,
          surface: const Color(0xFF1E1E1E), // Darker surface color
          onSurface: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system, // Automatically switch based on system mode
      home: const SplashScreen(),
    );
  }
}
