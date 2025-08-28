import 'package:flutter/material.dart';

/// App Color Theme System
/// 
/// This class provides a centralized color management system for the Snappie app.
/// Colors are organized by semantic meaning rather than specific color values,
/// making it easy to maintain consistency and implement theme switching.
class AppColors {
  const AppColors._();
  
  // ============================================================================
  // PRIMARY COLORS
  // ============================================================================
  
  /// Primary brand color - used for main actions, active states
  static const Color primary = Color(0xFF2196F3); // Blue
  static const Color primaryLight = Color(0xFF64B5F6); // Blue[400]
  static const Color primaryDark = Color(0xFF1976D2); // Blue[600]
  static const Color primarySurface = Color(0xFFE3F2FD); // Blue[50]
  static const Color primaryContainer = Color(0xFFBBDEFB); // Blue[100]

  // ============================================================================
  // SURFACE COLORS
  // ============================================================================
  
  /// Background colors for different surfaces
  static const Color background = Color(0xFFFAFAFA); // Grey[50]
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Grey[100]
  static const Color surfaceContainer = Color(0xFFEEEEEE); // Grey[200]
  
  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  
  /// Text colors with different emphasis levels
  static const Color textPrimary = Color(0xFF212121); // Black87
  static const Color textSecondary = Color(0xFF757575); // Grey[600]
  static const Color textTertiary = Color(0xFF9E9E9E); // Grey[500]
  static const Color textDisabled = Color(0xFFBDBDBD); // Grey[400]
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White
  static const Color textOnSurface = Color(0xFF212121); // Black87
  
  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================
  
  /// Success colors - for positive actions, confirmations
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color successLight = Color(0xFF81C784); // Green[300]
  static const Color successDark = Color(0xFF388E3C); // Green[700]
  static const Color successSurface = Color(0xFFE8F5E8); // Green[50]
  static const Color successContainer = Color(0xFFC8E6C9); // Green[100]
  
  /// Error colors - for errors, warnings, destructive actions
  static const Color error = Color(0xFFF44336); // Red
  static const Color errorLight = Color(0xFFE57373); // Red[300]
  static const Color errorDark = Color(0xFFD32F2F); // Red[700]
  static const Color errorSurface = Color(0xFFFFEBEE); // Red[50]
  static const Color errorContainer = Color(0xFFFFCDD2); // Red[100]
  
  /// Warning colors - for caution, pending states
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color warningLight = Color(0xFFFFB74D); // Orange[300]
  static const Color warningDark = Color(0xFFF57C00); // Orange[700]
  static const Color warningSurface = Color(0xFFFFF3E0); // Orange[50]
  static const Color warningContainer = Color(0xFFFFE0B2); // Orange[100]
  
  /// Info colors - for informational messages
  static const Color info = Color(0xFF2196F3); // Blue
  static const Color infoLight = Color(0xFF64B5F6); // Blue[300]
  static const Color infoDark = Color(0xFF1976D2); // Blue[700]
  static const Color infoContainer = Color(0xFFE3F2FD); // Blue[50]
  
  /// Accent colors - for highlights and special elements
  static const Color accent = Color(0xFF03DAC6); // Teal
  static const Color accentLight = Color(0xFF66FFF9); // Teal[200]
  
  // ============================================================================
  // BORDER & DIVIDER COLORS
  // ============================================================================
  
  /// Border and divider colors
  static const Color border = Color(0xFFE0E0E0); // Grey[300]
  static const Color borderLight = Color(0xFFEEEEEE); // Grey[200]
  static const Color borderDark = Color(0xFFBDBDBD); // Grey[400]
  static const Color divider = Color(0xFFE0E0E0); // Grey[300]
  
  // ============================================================================
  // OVERLAY COLORS
  // ============================================================================
  
  /// Overlay colors for modals, shadows, etc.
  static Color overlay = Colors.black.withOpacity(0.5);
  static Color overlayLight = Colors.black.withOpacity(0.3);
  static Color overlayDark = Colors.black.withOpacity(0.7);
  static Color scrim = Colors.black.withOpacity(0.6);
  
  // ============================================================================
  // GRADIENT COLORS
  // ============================================================================
  
  /// Common gradients used in the app
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [successLight, successDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ============================================================================
  // SHADOW COLORS
  // ============================================================================
  
  /// Shadow colors for elevation
  static Color shadowLight = Colors.grey.withOpacity(0.1);
  static Color shadowMedium = Colors.grey.withOpacity(0.2);
  static Color shadowDark = Colors.grey.withOpacity(0.3);
  
  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// Get rating color based on rating value
  static Color getRatingColor(double rating) {
    if (rating >= 4.0) return success;
    if (rating >= 3.0) return warning;
    if (rating >= 2.0) return Color(0xFFFF5722); // Deep Orange
    return error;
  }
  
  /// Get status color based on status type
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'open':
      case 'available':
      case 'online':
        return success;
      case 'pending':
      case 'processing':
        return warning;
      case 'inactive':
      case 'closed':
      case 'unavailable':
      case 'offline':
        return textTertiary;
      case 'error':
      case 'failed':
      case 'rejected':
        return error;
      default:
        return textSecondary;
    }
  }
}

/// Extension for easy access to colors with semantic naming
extension AppColorsExtension on BuildContext {
  /// Get colors instance for easy access
  static AppColors get instance => const AppColors._();
}
