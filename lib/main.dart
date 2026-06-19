// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pixievet/app_init_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixievet',
      theme: ThemeData(
        primaryColor: Color(0xFF2BB0A6),
        scaffoldBackgroundColor: Color(0xFFF9FAFB),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2BB0A6),
          primary: Color(0xFF2BB0A6),
          secondary: Color(0xFFFF8A65),
          background: Color(0xFFF9FAFB),
        ),

        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: Color(0xFF6B7280)),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2BB0A6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AppInitPage(),
    );
  }
}
