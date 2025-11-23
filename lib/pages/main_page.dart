import 'package:flutter/material.dart';
import 'home_page.dart';
import 'library_page.dart';
import 'settings_page.dart';

class MainPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const MainPage({super.key, required this.onToggleTheme});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const LibraryPage(), // Tab 1
      HomePage(onToggleTheme: widget.onToggleTheme), // Tab 2
      SettingsPage(onToggleTheme: widget.onToggleTheme), // Tab 3
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Library"),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: "Film Saya",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
