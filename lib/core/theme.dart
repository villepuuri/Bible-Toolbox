import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  // Colors
  static final lightGreen = Color(0xFF9BBD4F);
  static final opaqueGreen = lightGreen.withAlpha(40);
  static final darkGreen = Color(0xFF536248);
  static final black = Color(0xFF0A0A0A);
  static final white = Color(0xFFFFFFFF);
  static final shadowBlack = black.withAlpha(25); // 10%

  // Color schemes
  static final lightColorScheme = ColorScheme.light(
    primary: lightGreen,
    primaryContainer: opaqueGreen,
    secondary: darkGreen,
    surface: white,
    outline: black
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
    headlineSmall: GoogleFonts.raleway(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: black,
    ),

    // Body texts
    bodyLarge: GoogleFonts.tienne(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: black,
      height: 1.4,
    ),
    bodyMedium: GoogleFonts.tienne(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: black,
      height: 1.4,
    ),
    bodySmall: GoogleFonts.tienne(fontSize: 12, color: black, height: 1.4),

    /* Labels */

    // External links
    labelLarge: GoogleFonts.tienne(
      fontSize: 16,
      height: 1.4,
      color: darkGreen,
      fontStyle: FontStyle.italic,
    ),

    // Internal links
    labelMedium: GoogleFonts.tienne(
      fontSize: 16,
      height: 1.4,
      color: lightGreen,
      fontStyle: FontStyle.italic,
    ),

    // Small info texts
    labelSmall: GoogleFonts.raleway(
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: black,
    ),
  );

  /* Button themes */

  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(lightGreen),
      foregroundColor: WidgetStateProperty.all(white),
      overlayColor: WidgetStateProperty.all(darkGreen.withAlpha(25)),
      textStyle: WidgetStateProperty.all(
        textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
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
      minimumSize: const WidgetStatePropertyAll(Size(40, 40)),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(
        black,
      ),
      textStyle: WidgetStatePropertyAll(
        textTheme.bodyMedium,
      ),

      side: WidgetStateProperty.all(
        BorderSide(
          color: lightColorScheme.primary,
          width: 2,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static final textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(1),
      minimumSize: WidgetStateProperty.all(Size(0, 0)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: WidgetStateProperty.all(textTheme.labelMedium),
      foregroundColor: WidgetStateProperty.all(lightColorScheme.primary),
      padding: WidgetStateProperty.all(
        EdgeInsets.zero
        // EdgeInsets.symmetric(horizontal: 0, vertical: 4),
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
      space: 3,
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
      titleTextStyle: textTheme.titleMedium,
      scrolledUnderElevation: 0,
    ),
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonTheme,
  );
}
