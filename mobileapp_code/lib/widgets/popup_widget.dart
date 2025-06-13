// lib/widgets/app_info_dialog.dart

import 'package:flutter/material.dart';

class AppInfoDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About MCast Viewer', style: TextStyle(fontSize: 20),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Version: 1.0.0', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),),
            SizedBox(height: 10),
            Text(
              'MicroCam Viewer is a lightweight mobile application '
                  'that allows you to live stream video from your microcontroller-based camera module (like ESP32-CAM).',
            ),
            SizedBox(height: 16),
            Text(
              'Key Features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Live stream from ESP32-CAM'),
            Text('- Change IP address for camera connection'),
            Text('- Secure app access with passcode/biometrics'),
            Text('- Light/Dark theme switching'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------- Secret key saving widget
class SecretKeyPopup extends StatefulWidget {
  final Function(String) onSubmit;

  const SecretKeyPopup({super.key, required this.onSubmit});

  @override
  State<SecretKeyPopup> createState() => _SecretKeyPopupState();
}

class _SecretKeyPopupState extends State<SecretKeyPopup> {
  final TextEditingController _controller = TextEditingController();
  bool _isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope( // disables back button
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.vpn_key_rounded, size: 60, color: Colors.deepPurple),
              const SizedBox(height: 16),
              const Text(
                'Set Recovery Key',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'This secret key will help you recover your passcode in case you forget it.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                onChanged: (value) => setState(() => _isEmpty = value.trim().isEmpty),
                decoration: InputDecoration(
                  hintText: 'e.g., MyPet123',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isEmpty
                    ? null
                    : () {
                  widget.onSubmit(_controller.text.trim());
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
