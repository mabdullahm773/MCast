import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 3 seconds
    Timer(Duration(seconds: 3), () {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (_) => HomeScreen()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Brand color background
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Your logo image (add your logo to assets and update pubspec.yaml)
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}