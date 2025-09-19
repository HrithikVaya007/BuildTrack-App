import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/worker/worker_dashboard.dart';
import 'providers/app_provider.dart'; // Make sure this file exists exactly at lib/providers/app_provider.dart

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(), // This uses your AppProvider class
      child: const WorkerApp(),
    ),
  );
}

class WorkerApp extends StatelessWidget {
  const WorkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Worker App',
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: const Color(0xFF1A73E8), // Blue
          secondary: const Color(0xFF5F6368), // Grey
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: const WorkerDashboard(),
    );
  }
}
