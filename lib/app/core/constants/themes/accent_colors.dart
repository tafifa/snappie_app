import 'package:flutter/material.dart';

/// Accent color palette for the app
/// Orange/Peach color scheme
class AccentColors {
  AccentColors._();

  static const Color accent50 = Color(0xFFFEF4F0);
  static const Color accent100 = Color(0xFFFEEAE1);
  static const Color accent200 = Color(0xFFFDD1BC);
  static const Color accent300 = Color(0xFFFCBB98);
  static const Color accent400 = Color(0xFFFCA060);
  static const Color accent500 = Color(0xFFF28C28); // Base accent color
  static const Color accent600 = Color(0xFFBE6D1E);
  static const Color accent700 = Color(0xFF905113);
  static const Color accent800 = Color(0xFF613509);
  static const Color accent900 = Color(0xFF391D03);
  static const Color accent950 = Color(0xFF251001);

  /// Get accent color by intensity (50-950)
  static Color getShade(int shade) {
    switch (shade) {
      case 50:
        return accent50;
      case 100:
        return accent100;
      case 200:
        return accent200;
      case 300:
        return accent300;
      case 400:
        return accent400;
      case 500:
        return accent500;
      case 600:
        return accent600;
      case 700:
        return accent700;
      case 800:
        return accent800;
      case 900:
        return accent900;
      case 950:
        return accent950;
      default:
        return accent500;
    }
  }

  /// Material color swatch for theme
  static const MaterialColor accentSwatch = MaterialColor(
    0xFFF28C28,
    <int, Color>{
      50: accent50,
      100: accent100,
      200: accent200,
      300: accent300,
      400: accent400,
      500: accent500,
      600: accent600,
      700: accent700,
      800: accent800,
      900: accent900,
    },
  );
}
