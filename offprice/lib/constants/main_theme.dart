import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: AppColors.colorPrimary[900],
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.colorBackground[900],
        fontFamily: 'Archivo Narrow',
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
        )));
  }
}
