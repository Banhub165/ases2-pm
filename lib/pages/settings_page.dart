import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const SettingsPage({super.key, required this.onToggleTheme});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('isDark') ?? false;
    });
  }

  void toggleTheme(bool value) async {
    setState(() {
      isDark = value;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);

    widget.onToggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDark,
            onChanged: toggleTheme,
            secondary: const Icon(Icons.brightness_6),
          ),
        ],
      ),
    );
  }
}
