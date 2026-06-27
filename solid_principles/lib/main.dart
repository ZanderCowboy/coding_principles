import 'package:flutter/material.dart';
import 'package:solid_principles/presentation/home_page.dart';

/// Software principles study app for Flutter/Dart interview prep.
///
/// Run from this directory:
///   flutter pub get
///   flutter run
///   flutter test
void main() {
  runApp(const SolidPrinciplesApp());
}

class SolidPrinciplesApp extends StatelessWidget {
  const SolidPrinciplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Software Principles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
