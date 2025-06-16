import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class SecretKeyScreen extends StatefulWidget {
  const SecretKeyScreen({super.key});

  @override
  State<SecretKeyScreen> createState() => _SecretKeyScreenState();
}

class _SecretKeyScreenState extends State<SecretKeyScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final enteredKey = _controller.text.trim();
    final storedKey = await ApplockService.getSecretKey();

    if (enteredKey == storedKey) {
      await ApplockService.clearPasscode();
      await ApplockService.setAppLockEnabled(false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('App Lock/Shared Key disabled')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } else {
      setState(() {
        _errorText = "Wrong secret key!";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter Secret Key",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Secret Key",
                  labelStyle: TextStyle(color: Colors.black45),
                ),
                onSubmitted: (_) => _submit(),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text("Submit",style: TextStyle(color: Colors.green),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}