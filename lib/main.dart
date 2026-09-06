import 'package:flutter/material.dart';
import 'app/theme.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const SystemKApp());
}

class SystemKApp extends StatelessWidget {
  const SystemKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System-K',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const ChatScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
