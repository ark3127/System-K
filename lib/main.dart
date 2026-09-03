import 'package:flutter/material.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F1A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'SYSTEM-K',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
