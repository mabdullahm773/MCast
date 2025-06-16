import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

import '../services/local_storage.dart';
import '../widgets/popup_widget.dart';

class SetPasscodeScreen extends StatefulWidget {
  const SetPasscodeScreen({super.key});

  @override
  State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  String? _firstPasscode;
  bool _isConfirming = false;

  void _onPasscodeEntered(String enteredPasscode) async {
    if (!_isConfirming) {
      setState(() {
        _firstPasscode = enteredPasscode;
        _isConfirming = true;
      });
      _verificationNotifier.add(false); // Ask again to confirm
    } else {
      if (enteredPasscode == _firstPasscode) {
        // Save the passcode
        await ApplockService.savePasscode(enteredPasscode);
        await ApplockService.setAppLockEnabled(true);
        _verificationNotifier.add(true);

        if (context.mounted) {
          Navigator.pop(context, true); // Return true to indicate success

          await showDialog(
            context: context,
            barrierDismissible: false, // prevent tapping outside to dismiss
            builder: (_) => SecretKeyPopup(
              onSubmit: (key) async {
                await ApplockService.setSecretKey(key);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Secret key saved')));
              },
              title: "Set Recovery Key",
              cancel: false,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passcode set successfully')),
          );
        }
      } else {
        // Passcodes did not match
        _verificationNotifier.add(false);
        setState(() {
          _firstPasscode = null;
          _isConfirming = false;
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passcodes do not match. Try again.')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
      title: Text(
        _isConfirming ? 'Confirm Passcode' : 'Set a 4-digit Passcode',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
      passwordDigits: 4,
      backgroundColor: Colors.teal.shade900,
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
      cancelCallback: () {
        Navigator.pop(context, false);
      }, // Return false on cancel
    );
  }
}
