import 'package:flutter/material.dart';

class AppThemeData {
  // Colors
  static final lightGreen = Color(0xFF9BBD4F);
  static final opaqueGreen = lightGreen.withAlpha(40);
  static final darkGreen = Color(0xFF536248);
  static final black = Color(0xFF0A0A0A);
  static final white = Color(0xFFFFFFFF);

  // Color schemes
  static final lightColorScheme = ColorScheme.light(
    primary: lightGreen,
    secondary: darkGreen,
    surface: white,
  );

  // Text themes
  static final textTheme = TextTheme(
    // Titles are titles of pages
    titleLarge: TextStyle(
      fontSize: 32,
      fontFamily: 'Tienne',
      fontWeight: FontWeight.bold,
      color: black,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontFamily: 'Tienne',
      fontWeight: FontWeight.bold,
      color: black,
    ),

    // Headlines are in text chapters
    headlineLarge: TextStyle(fontSize: 24, fontFamily: 'Raleway', color: black),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontFamily: 'Raleway',
      color: black,
    ),

    // Body texts
    bodyMedium: TextStyle(fontSize: 16, fontFamily: 'Tienne', color: black),
    bodySmall: TextStyle(fontSize: 12, fontFamily: 'Tienne', color: black),

    // Labels are used as links
    labelLarge: TextStyle(
      fontSize: 16,
      fontFamily: 'Tienne',
      color: black,
      fontStyle: FontStyle.italic,
      decoration: TextDecoration.underline,
      decorationColor: lightGreen,
    ),
  );

  // Icon themes
  static final iconTheme = IconThemeData(color: lightGreen, size: 24);

  // App themes
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightGreen,
    colorScheme: lightColorScheme,
    textTheme: textTheme,
    iconTheme: iconTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge,
    ),
  );
}
