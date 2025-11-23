import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getBool('isDark') ?? false;

  runApp(MyApp(isDarkInit: savedTheme));
}

class MyApp extends StatefulWidget {
  final bool isDarkInit;

  const MyApp({super.key, required this.isDarkInit});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.isDarkInit;
  }

  void toggleTheme() async {
    setState(() => isDark = !isDark);

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Film',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: LoginPage(onToggleTheme: toggleTheme),
    );
  }
}
