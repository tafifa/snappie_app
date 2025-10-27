import 'package:flutter/material.dart';

/// Danger color palette for the app
/// Red color scheme for errors and destructive actions
class DangerColors {
  DangerColors._();

  static const Color danger50 = Color(0xFFFFE9E9);
  static const Color danger100 = Color(0xFFFFD2D2);
  static const Color danger200 = Color(0xFFFFA7A7);
  static const Color danger300 = Color(0xFFFF7070);
  static const Color danger400 = Color(0xFFFF1718);
  static const Color danger500 = Color(0xFFC90000); // Base danger color
  static const Color danger600 = Color(0xFFA50000);
  static const Color danger700 = Color(0xFF7E0000);
  static const Color danger800 = Color(0xFF5D0000);
  static const Color danger900 = Color(0xFF3A0000);
  static const Color danger950 = Color(0xFF280000);

  /// Get danger color by intensity (50-950)
  static Color getShade(int shade) {
    switch (shade) {
      case 50:
        return danger50;
      case 100:
        return danger100;
      case 200:
        return danger200;
      case 300:
        return danger300;
      case 400:
        return danger400;
      case 500:
        return danger500;
      case 600:
        return danger600;
      case 700:
        return danger700;
      case 800:
        return danger800;
      case 900:
        return danger900;
      case 950:
        return danger950;
      default:
        return danger500;
    }
  }

  /// Material color swatch for theme
  static const MaterialColor dangerSwatch = MaterialColor(
    0xFFC90000,
    <int, Color>{
      50: danger50,
      100: danger100,
      200: danger200,
      300: danger300,
      400: danger400,
      500: danger500,
      600: danger600,
      700: danger700,
      800: danger800,
      900: danger900,
    },
  );
}
