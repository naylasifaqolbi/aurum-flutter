import 'package:flutter/material.dart';
import 'views/splash/splash_screen.dart';

void main() {
  runApp(const AurumApp());
}

class AurumApp extends StatelessWidget {
  const AurumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aurum',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF28C28)),
      ),

      home: const SplashScreen(),
    );
  }
}
