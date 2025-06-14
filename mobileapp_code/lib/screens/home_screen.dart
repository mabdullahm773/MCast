import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp_code/services/url_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    checkStream();
  }

  Future<void> checkStream() async {
    print('Connecting to: ${UrlService.ip}');
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(UrlService.ip)).timeout(const Duration(seconds: 3));
      _hasError = response.statusCode != 200;
    } catch (e) {
      _hasError = true;
    }

    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed < 2000) {
      await Future.delayed(Duration(milliseconds: 2000 - elapsed));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Camera Stream'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text(
              "Failed to connect to camera.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: checkStream,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      )
          : Center(
        child: Mjpeg(
          stream: UrlService.ip,
          isLive: true,
          error: (context, error, stack) => const Text("Stream unavailable."),
        ),
      ),
    );
  }
}