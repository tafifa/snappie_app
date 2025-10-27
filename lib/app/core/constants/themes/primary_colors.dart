import 'package:flutter/material.dart';

/// Primary color palette for the app
/// Teal/Cyan color scheme
class PrimaryColors {
  PrimaryColors._();

  static const Color primary50 = Color(0xFFADFFFF);
  static const Color primary100 = Color(0xFF02FCFC);
  static const Color primary200 = Color(0xFF03DADA);
  static const Color primary300 = Color(0xFF03BBBB);
  static const Color primary400 = Color(0xFF009E9E);
  static const Color primary500 = Color(0xFF008080); // Base primary color
  static const Color primary600 = Color(0xFF026767);
  static const Color primary700 = Color(0xFF004D4D);
  static const Color primary800 = Color(0xFF003434);
  static const Color primary900 = Color(0xFF002020);
  static const Color primary950 = Color(0xFF001414);

  /// Get primary color by intensity (50-950)
  static Color getShade(int shade) {
    switch (shade) {
      case 50:
        return primary50;
      case 100:
        return primary100;
      case 200:
        return primary200;
      case 300:
        return primary300;
      case 400:
        return primary400;
      case 500:
        return primary500;
      case 600:
        return primary600;
      case 700:
        return primary700;
      case 800:
        return primary800;
      case 900:
        return primary900;
      case 950:
        return primary950;
      default:
        return primary500;
    }
  }

  /// Material color swatch for theme
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF008080,
    <int, Color>{
      50: primary50,
      100: primary100,
      200: primary200,
      300: primary300,
      400: primary400,
      500: primary500,
      600: primary600,
      700: primary700,
      800: primary800,
      900: primary900,
    },
  );
}
