import 'package:flutter/material.dart';
import 'themes/primary_colors.dart';
import 'themes/accent_colors.dart';
import 'themes/warning_colors.dart';
import 'themes/danger_colors.dart';
import 'themes/success_colors.dart';
import 'themes/meta_colors.dart';
import 'themes/light_sea_green_colors.dart';

/// Main app theme configuration
class AppTheme {
  AppTheme._();

  // Background color
  static const Color background = MetaColors.meta50;

  /// Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // Ensure the app uses the locally bundled Ubuntu font family
      fontFamily: 'Ubuntu',

      scaffoldBackgroundColor: background,

      // Primary colors
      primaryColor: PrimaryColors.primary500,
      primaryColorLight: PrimaryColors.primary300,
      primaryColorDark: PrimaryColors.primary700,
      primarySwatch: PrimaryColors.primarySwatch,

      // Accent/Secondary colors
      colorScheme: ColorScheme.light(
        primary: PrimaryColors.primary500,
        onPrimary: MetaColors.meta50,
        primaryContainer: PrimaryColors.primary100,
        onPrimaryContainer: PrimaryColors.primary900,

        secondary: LightSeaGreenColors.lightSeaGreen500,
        onSecondary: MetaColors.meta50,
        secondaryContainer: LightSeaGreenColors.lightSeaGreen100,
        onSecondaryContainer: LightSeaGreenColors.lightSeaGreen900,

        tertiary: AccentColors.accent500,
        onTertiary: Colors.black,
        tertiaryContainer: AccentColors.accent100,
        onTertiaryContainer: AccentColors.accent900,

        error: DangerColors.danger500,
        onError: MetaColors.meta50,
        errorContainer: DangerColors.danger100,
        onErrorContainer: DangerColors.danger900,

        surface: background,
        onSurface: MetaColors.meta900,
        surfaceContainer: MetaColors.meta50,
        onSurfaceVariant: MetaColors.meta700,

        outline: MetaColors.meta300,
        outlineVariant: MetaColors.meta200,
        shadow: MetaColors.meta900.withAlpha(26),
        scrim: MetaColors.meta900.withAlpha(128),

        inverseSurface: MetaColors.meta900,
        onInverseSurface: MetaColors.meta50,
        inversePrimary: PrimaryColors.primary200,
      ),
    );
  }

  /// Dark theme (optional - can be implemented later)
  static ThemeData get darkTheme {
    // TODO: Implement dark theme
    return lightTheme;
  }

  /// Helper methods to get specific color shades
  static Color getPrimaryShade(int shade) => PrimaryColors.getShade(shade);
  static Color getAccentShade(int shade) => AccentColors.getShade(shade);
  static Color getWarningShade(int shade) => WarningColors.getShade(shade);
  static Color getDangerShade(int shade) => DangerColors.getShade(shade);
  static Color getSuccessShade(int shade) => SuccessColors.getShade(shade);
  static Color getMetaShade(int shade) => MetaColors.getShade(shade);
  static Color getLightSeaGreenShade(int shade) => LightSeaGreenColors.getShade(shade);
}