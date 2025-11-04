import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    primaryContainer: opaqueGreen,
    secondary: darkGreen,
    surface: white,
  );

  // Text themes
  // todo: Change text themes to local from Google fonts
  static final textTheme = TextTheme(
    // Titles are titles of pages
    titleLarge: GoogleFonts.tienne(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: black,
      height: 1.2,
      letterSpacing: -1,
    ),
    titleMedium: GoogleFonts.tienne(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: black,
      height: 1.2,
      letterSpacing: -0.6,
    ),
    titleSmall: GoogleFonts.tienne(
      fontSize: 20,
      color: black,
      height: 1.2,
      letterSpacing: -0.6,
    ),

    // Headlines are in text chapters
    headlineLarge: GoogleFonts.raleway(fontSize: 24, color: black),
    headlineMedium: GoogleFonts.raleway(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: black,
    ),

    // Body texts
    bodyMedium: GoogleFonts.tienne(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: black,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.tienne(fontSize: 12, color: black, height: 1.4),

    // Labels are used as links
    labelMedium: GoogleFonts.tienne(
      fontSize: 16,
      height: 1.4,
      color: black,
      fontStyle: FontStyle.italic,
    ),
  );

  // Button themes
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(lightGreen),
      foregroundColor: WidgetStateProperty.all(white),
      overlayColor: WidgetStateProperty.all(darkGreen.withAlpha(25)),
      textStyle: WidgetStateProperty.all(
        textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w900),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
  );

  static final outlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(white),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      ),
      side: WidgetStateProperty.all(
        BorderSide(color: lightColorScheme.primary, width: 2),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );

  // Icon themes
  static final iconTheme = IconThemeData(color: lightGreen, size: 28);

  // App themes
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightGreen,
    colorScheme: lightColorScheme,
    textTheme: textTheme,
    iconTheme: iconTheme,
    dividerTheme: DividerThemeData(
      color: lightColorScheme.primary,
      thickness: 1,
      space: 3
    ),
    listTileTheme: ListTileThemeData(
      iconColor: lightGreen,
      titleTextStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightGreen,
      foregroundColor: white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: textTheme.titleLarge,
    ),
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
  );
}
