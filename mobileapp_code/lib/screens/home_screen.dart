
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _ip = 'http://192.168.0.105/';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    checkStream();
  }

  Future<void> checkStream() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(_ip)).timeout(Duration(seconds: 3));
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


  void _showEditIpDialog() {
    final TextEditingController _controller = TextEditingController(text: _ip);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Camera IP'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'http://192.168.0.105/',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _ip = _controller.text.trim();
                });
                Navigator.pop(context);
                checkStream();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Camera Stream'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit IP',
            onPressed: _showEditIpDialog,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 48, color: Colors.redAccent),
            SizedBox(height: 12),
            Text(
              "Failed to connect to camera.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: checkStream,
              icon: Icon(Icons.refresh),
              label: Text("Retry"),
            ),
          ],
        ),
      )
          : Center(
        child: Image.network(
          _ip,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Text("Stream unavailable.");
          },
        ),
      ),
    );
  }
}
