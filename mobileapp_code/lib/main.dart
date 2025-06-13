import 'package:flutter/material.dart';
import 'package:mobileapp_code/screens/home_screen.dart';
import 'package:mobileapp_code/screens/lock_screen.dart';
import 'package:mobileapp_code/screens/setpasscode_screen.dart';
import 'package:mobileapp_code/screens/settings_screen.dart';
import 'package:mobileapp_code/screens/splash_screen.dart';
import 'package:mobileapp_code/screens/verifypasscode_screen.dart';
import 'package:mobileapp_code/services/local_storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7F7), // Slightly off-white
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E), // Slightly lighter than pure black
          foregroundColor: Colors.white,
          elevation: 0.5,
        ),
      ),
      themeMode: themeService.currentThemeMode,
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/lock': (context) => LockScreen(),
        '/settings': (context) => SettingsScreen(),
        '/verify' : (context) => VerifyPasscodeScreen(),
        '/change' : (context) => SetPasscodeScreen(),
      },
    );
  }
}

