import 'package:flutter/material.dart';

/// Warning color palette for the app
/// Yellow/Gold color scheme
class WarningColors {
  WarningColors._();

  static const Color warning50 = Color(0xFFFFF8F1);
  static const Color warning100 = Color(0xFFFFF2E2);
  static const Color warning200 = Color(0xFFFFE4C1);
  static const Color warning300 = Color(0xFFFFDAA5);
  static const Color warning400 = Color(0xFFFFCD76);
  static const Color warning500 = Color(0xFFFFBF00); // Base warning color
  static const Color warning600 = Color(0xFFC99601);
  static const Color warning700 = Color(0xFF956E02);
  static const Color warning800 = Color(0xFF624701);
  static const Color warning900 = Color(0xFF352500);
  static const Color warning950 = Color(0xFF211600);

  /// Get warning color by intensity (50-950)
  static Color getShade(int shade) {
    switch (shade) {
      case 50:
        return warning50;
      case 100:
        return warning100;
      case 200:
        return warning200;
      case 300:
        return warning300;
      case 400:
        return warning400;
      case 500:
        return warning500;
      case 600:
        return warning600;
      case 700:
        return warning700;
      case 800:
        return warning800;
      case 900:
        return warning900;
      case 950:
        return warning950;
      default:
        return warning500;
    }
  }

  /// Material color swatch for theme
  static const MaterialColor warningSwatch = MaterialColor(
    0xFFFFBF00,
    <int, Color>{
      50: warning50,
      100: warning100,
      200: warning200,
      300: warning300,
      400: warning400,
      500: warning500,
      600: warning600,
      700: warning700,
      800: warning800,
      900: warning900,
    },
  );
}
