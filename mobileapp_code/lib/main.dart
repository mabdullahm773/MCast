import 'package:flutter/material.dart';
import 'package:mobileapp_code/screens/home_screen.dart';
import 'package:mobileapp_code/screens/splash_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
         '/home': (context) => HomeScreen(),
        // '/lock': (context) => LockScreen(),
        // '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

