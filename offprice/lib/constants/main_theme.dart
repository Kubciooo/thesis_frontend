import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

///
/// Klasa odpowiedzialna za główne kolory i czcionki w aplikacji
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: AppColors.colorPrimary[900],
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.colorBackground[900],
        fontFamily: 'Archivo Narrow',
        colorScheme: const ColorScheme.dark(primary: Colors.white70),
        textTheme: GoogleFonts.archivoNarrowTextTheme(const TextTheme(
          headline1: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: AppColors.colorHeading,
            height: 1.1,
            letterSpacing: -0.03,
          ),
          headline2: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: AppColors.colorHeading,
            height: 1.1,
            letterSpacing: -0.03,
          ),
          headline3: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.15,
            letterSpacing: -0.03,
          ),
          headline4: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Color(0x00e0e0ff),
            height: 1.15,
            letterSpacing: -0.03,
          ),
        )));
  }
}
