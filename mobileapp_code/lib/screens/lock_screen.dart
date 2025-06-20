import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:local_auth/local_auth.dart';
import '../services/local_storage.dart';
import '../widgets/popup_widget.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    _authenticateBiometric();
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  Future<void> _authenticateBiometric() async {
    final localAuth = LocalAuthentication();
    final canAuth = await localAuth.canCheckBiometrics;

    if (canAuth) {
      try {
        final didAuth = await localAuth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (didAuth) {
          _goToHome();
        }
      } catch (e) {
        debugPrint('Biometric error: $e');
      }
    }
  }

  Future<void> _onPasscodeEntered(String enteredPasscode) async {
    final storedPasscode = await ApplockService.getPasscode();
    if (enteredPasscode == storedPasscode) {
      _verificationNotifier.add(true);
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacementNamed(context, '/home'); // Or your actual home screen route
      });
    } else {
      _verificationNotifier.add(false);
    }
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
      title: const Text(
        'Enter App Passcode',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      passwordDigits: 4,
      backgroundColor: Colors.teal.shade900,
      passwordEnteredCallback: _onPasscodeEntered,
      cancelButton: const Text('Cancel', style: TextStyle(color: Colors.white)),
      deleteButton: const Text('Delete', style: TextStyle(color: Colors.white)),
      shouldTriggerVerification: _verificationNotifier.stream,
      circleUIConfig: const CircleUIConfig(
        borderWidth: 1,
        borderColor: Colors.white,
        fillColor: Colors.white,
        circleSize: 15,
      ),
      keyboardUIConfig: const KeyboardUIConfig(
        digitBorderWidth: 1.2,
        digitTextStyle: TextStyle(fontSize: 22, color: Colors.white),
      ),
      cancelCallback: () => Navigator.pop(context),
      bottomWidget: Column(
        children: [
          SizedBox(height: 22,),
          TextButton.icon(
            icon: const Icon(Icons.fingerprint, color: Colors.green),
            label: const Text('Use Fingerprint', style: TextStyle(color: Colors.green,fontSize: 16)),
            onPressed: _authenticateBiometric,
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/secretkey'),
            child: const Text(
              'Forgot Passcode?',
              style: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
