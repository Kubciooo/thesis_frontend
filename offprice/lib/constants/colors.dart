import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  static const Map<int, Color> colorBackground = {
    50: Color.fromRGBO(48, 48, 48, .1),
    100: Color.fromRGBO(48, 48, 48, .2),
    200: Color.fromRGBO(48, 48, 48, .3),
    300: Color.fromRGBO(48, 48, 48, .4),
    400: Color.fromRGBO(48, 48, 48, .5),
    500: Color.fromRGBO(48, 48, 48, .6),
    600: Color.fromRGBO(48, 48, 48, .7),
    700: Color.fromRGBO(48, 48, 48, .8),
    800: Color.fromRGBO(48, 48, 48, .9),
    900: Color.fromRGBO(48, 48, 48, 1),
  };

  static const Map<int, Color> colorSecondary = {
    50: Color.fromRGBO(244, 175, 25, .1),
    100: Color.fromRGBO(244, 175, 25, .2),
    200: Color.fromRGBO(244, 175, 25, .3),
    300: Color.fromRGBO(244, 175, 25, .4),
    400: Color.fromRGBO(244, 175, 25, .5),
    500: Color.fromRGBO(244, 175, 25, .6),
    600: Color.fromRGBO(244, 175, 25, .7),
    700: Color.fromRGBO(244, 175, 25, .8),
    800: Color.fromRGBO(244, 175, 25, .9),
    900: Color.fromRGBO(244, 175, 25, 1),
  };

  static const Map<int, Color> colorPrimary = {
    50: Color.fromRGBO(240, 39, 18, .1),
    100: Color.fromRGBO(240, 39, 18, .2),
    200: Color.fromRGBO(240, 39, 18, .3),
    300: Color.fromRGBO(240, 39, 18, .4),
    400: Color.fromRGBO(240, 39, 18, .5),
    500: Color.fromRGBO(240, 39, 18, .6),
    600: Color.fromRGBO(240, 39, 18, .7),
    700: Color.fromRGBO(240, 39, 18, .8),
    800: Color.fromRGBO(240, 39, 18, .9),
    900: Color.fromRGBO(240, 39, 18, 1),
  };
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: AppColors.colorPrimary[900],
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.colorBackground[900],
        fontFamily: 'Archivo Narrow',
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));
  }
}
