import 'package:flutter/material.dart';

/// Light Sea Green color palette for the app
/// Turquoise/Aqua color scheme - alternative to primary
class LightSeaGreenColors {
  LightSeaGreenColors._();

  static const Color lightSeaGreen50 = Color(0xFF8AFEF6);
  static const Color lightSeaGreen100 = Color(0xFF30EFE5);
  static const Color lightSeaGreen200 = Color(0xFF29DAD0);
  static const Color lightSeaGreen300 = Color(0xFF25C7BF);
  static const Color lightSeaGreen400 = Color(0xFF20B2AA);
  static const Color lightSeaGreen500 = Color(0xFF20B2AA); // Base light sea green color
  static const Color lightSeaGreen600 = Color(0xFF188D87);
  static const Color lightSeaGreen700 = Color(0xFF0E6762);
  static const Color lightSeaGreen800 = Color(0xFF074542);
  static const Color lightSeaGreen900 = Color(0xFF022724);
  static const Color lightSeaGreen950 = Color(0xFF011614);

  /// Get light sea green color by intensity (50-950)
  static Color getShade(int shade) {
    switch (shade) {
      case 50:
        return lightSeaGreen50;
      case 100:
        return lightSeaGreen100;
      case 200:
        return lightSeaGreen200;
      case 300:
        return lightSeaGreen300;
      case 400:
        return lightSeaGreen400;
      case 500:
        return lightSeaGreen500;
      case 600:
        return lightSeaGreen600;
      case 700:
        return lightSeaGreen700;
      case 800:
        return lightSeaGreen800;
      case 900:
        return lightSeaGreen900;
      case 950:
        return lightSeaGreen950;
      default:
        return lightSeaGreen500;
    }
  }

  /// Material color swatch for theme
  static const MaterialColor lightSeaGreenSwatch = MaterialColor(
    0xFF20B2AA,
    <int, Color>{
      50: lightSeaGreen50,
      100: lightSeaGreen100,
      200: lightSeaGreen200,
      300: lightSeaGreen300,
      400: lightSeaGreen400,
      500: lightSeaGreen500,
      600: lightSeaGreen600,
      700: lightSeaGreen700,
      800: lightSeaGreen800,
      900: lightSeaGreen900,
    },
  );
}
