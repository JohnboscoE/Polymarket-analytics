import 'package:flutter/material.dart';
import 'package:polymarket_analytics/screens/main_screen.dart';

import 'analytics_dashboard.dart';

class PolymarketAnalyticsApp extends StatelessWidget {
  const PolymarketAnalyticsApp({super.key});

  static const Color brandBlue = Color(0xFF2E5CFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardSurface = Color(0xFF1E1E1E);
  static const Color accentGreen = Color(0xFF00CC99);
  static const Color accentRed = Color(0xFFFF6B6B);
  static const Color lightText = Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polymarket Analytics',
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: brandBlue,
        scaffoldBackgroundColor: backgroundDark,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: lightText),
          bodyMedium: TextStyle(color: lightText),
          titleLarge: TextStyle(color: lightText),
          titleMedium: TextStyle(color: lightText),
        ),
        cardTheme: CardThemeData(
          color: cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
