import 'package:flutter/material.dart';

/// Success color palette for the app
/// Green color scheme for success states
class SuccessColors {
  SuccessColors._();

  static const Color success50 = Color(0xFFC7FFC3);
  static const Color success100 = Color(0xFF75FF67);
  static const Color success200 = Color(0xFF39E502);
  static const Color success300 = Color(0xFF2FC501);
  static const Color success400 = Color(0xFF25A401);
  static const Color success500 = Color(0xFF1D8800); // Base success color
  static const Color success600 = Color(0xFF156B01);
  static const Color success700 = Color(0xFF0E5300);
  static const Color success800 = Color(0xFF073900);
  static const Color success900 = Color(0xFF032100);
  static const Color success950 = Color(0xFF011500);

  /// Get success color by intensity (50-950)
  static Color getShade(int shade) {
    switch (shade) {
      case 50:
        return success50;
      case 100:
        return success100;
      case 200:
        return success200;
      case 300:
        return success300;
      case 400:
        return success400;
      case 500:
        return success500;
      case 600:
        return success600;
      case 700:
        return success700;
      case 800:
        return success800;
      case 900:
        return success900;
      case 950:
        return success950;
      default:
        return success500;
    }
  }

  /// Material color swatch for theme
  static const MaterialColor successSwatch = MaterialColor(
    0xFF1D8800,
    <int, Color>{
      50: success50,
      100: success100,
      200: success200,
      300: success300,
      400: success400,
      500: success500,
      600: success600,
      700: success700,
      800: success800,
      900: success900,
    },
  );
}
