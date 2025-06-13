import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import '../services/local_storage.dart';
import 'setpasscode_screen.dart';

class VerifyPasscodeScreen extends StatefulWidget {
  const VerifyPasscodeScreen({super.key});

  @override
  State<VerifyPasscodeScreen> createState() => _VerifyPasscodeScreenState();
}

class _VerifyPasscodeScreenState extends State<VerifyPasscodeScreen> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  Future<void> _onPasscodeEntered(String enteredPasscode) async {
    final storedPasscode = await ApplockService.getPasscode();

    if (enteredPasscode == storedPasscode) {
      _verificationNotifier.add(true);
      Navigator.pushNamed(context, '/change');
    } else {
      _verificationNotifier.add(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect passcode. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
      title: const Text(
        'Enter Current Passcode',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      passwordDigits: 4,
      backgroundColor: Colors.deepPurple,
      passwordEnteredCallback: _onPasscodeEntered,
      cancelButton: const Text('Cancel', style: TextStyle(color: Colors.white)),
      deleteButton: const Text('Delete', style: TextStyle(color: Colors.white)),
      shouldTriggerVerification: _verificationNotifier.stream,
      circleUIConfig: const CircleUIConfig(
        borderColor: Colors.white,
        fillColor: Colors.white,
        circleSize: 12,
      ),
      keyboardUIConfig: const KeyboardUIConfig(
        digitBorderWidth: 1,
        digitTextStyle: TextStyle(fontSize: 22, color: Colors.white),
      ),
      cancelCallback: () => Navigator.pop(context),
    );
  }
}
