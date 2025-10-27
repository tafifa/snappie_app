import 'package:flutter/material.dart';

/// Meta/Neutral color palette for the app
/// Grayscale color scheme for backgrounds, borders, and text
class MetaColors {
  MetaColors._();

  static const Color meta50 = Color(0xFFF5F5F5);
  static const Color meta100 = Color(0xFFE5E5E5);
  static const Color meta200 = Color(0xFFCFCFCF);
  static const Color meta300 = Color(0xFFB6B6B6);
  static const Color meta400 = Color(0xFF9E9E9E);
  static const Color meta500 = Color(0xFF888888); // Base meta color
  static const Color meta600 = Color(0xFF6A6A6A);
  static const Color meta700 = Color(0xFF505050);
  static const Color meta800 = Color(0xFF373737);
  static const Color meta900 = Color(0xFF1D1D1D);
  static const Color meta950 = Color(0xFF131313);

  /// Get meta color by intensity (50-950)
  static Color getShade(int shade) {
    switch (shade) {
      case 50:
        return meta50;
      case 100:
        return meta100;
      case 200:
        return meta200;
      case 300:
        return meta300;
      case 400:
        return meta400;
      case 500:
        return meta500;
      case 600:
        return meta600;
      case 700:
        return meta700;
      case 800:
        return meta800;
      case 900:
        return meta900;
      case 950:
        return meta950;
      default:
        return meta500;
    }
  }

  /// Material color swatch for theme
  static const MaterialColor metaSwatch = MaterialColor(
    0xFF888888,
    <int, Color>{
      50: meta50,
      100: meta100,
      200: meta200,
      300: meta300,
      400: meta400,
      500: meta500,
      600: meta600,
      700: meta700,
      800: meta800,
      900: meta900,
    },
  );
}
