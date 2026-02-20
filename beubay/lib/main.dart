import 'package:beubay/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BeubayApp());
}

class BeubayApp extends StatelessWidget {
  const BeubayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BEUBAY',
      theme: ThemeData(
        primaryColor: const Color(0xFFA020F0),
        scaffoldBackgroundColor: const Color(0xFFA020F0),
        fontFamily: 'Poppins', // optional
      ),
      home: const SplashScreen(),
    );
  }
}
