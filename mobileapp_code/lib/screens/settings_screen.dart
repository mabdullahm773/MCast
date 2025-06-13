import 'package:flutter/material.dart';
import 'package:mobileapp_code/screens/setpasscode_screen.dart';
import 'package:mobileapp_code/services/url_service.dart';
import 'package:provider/provider.dart';
import '../services/local_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;
  bool isSecurityEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSecuritySetting();
  }

  Future<void> _loadSecuritySetting() async {
    final value = await ApplockService.isAppLockEnabled();
    setState(() => isSecurityEnabled = value);
  }

  Future<void> _toggleAppLock(bool value) async {
    if (value) {
      // User is enabling the lock → navigate to SetPasscode screen
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SetPasscodeScreen()),
      );

      if (result == true) {
        setState(() => isSecurityEnabled = true);
      }
    } else {
      // User is disabling the lock → clear passcode
      await ApplockService.setAppLockEnabled(false);
      await ApplockService.savePasscode('');
      setState(() => isSecurityEnabled = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('App Lock disabled')),
      );
    }
  }


  void _editIpDialog() {
    final controller = TextEditingController(text: UrlService.ip);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Stream IP'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter IP e.g. http:',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => UrlService.ip = controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _changePasscode() {
    Navigator.pushNamed(context, '/verify');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('General', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('Edit Stream IP'),
            subtitle: Text(UrlService.ip),
            leading: const Icon(Icons.link),
            trailing: const Icon(Icons.edit),
            onTap: _editIpDialog,
          ),
          Consumer<ThemeService>(
            builder: (context, themeService, _) => SwitchListTile(
              title: const Text('Dark Theme'),
              value: themeService.isDarkTheme,
              secondary: const Icon(Icons.dark_mode),
              onChanged: (val) => themeService.toggleTheme(),
            ),
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: const Text('Enable App Lock'),
            value: isSecurityEnabled,
            secondary: const Icon(Icons.lock),
            onChanged: _toggleAppLock,

          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change Passcode'),
            onTap: _changePasscode,
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Info'),
            subtitle: Text('MicroCam Viewer v1.0.0'),
          ),
        ],
      ),
    );
  }
}
