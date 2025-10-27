/// Remote Assets Configuration
/// 
/// This file contains URLs for remote assets stored in the cloud.
/// Uses template-based approach for better maintainability.
library;

class RemoteAssets {
  RemoteAssets._();

  // Cloudinary Configuration
  static const String cloudName = 'deqnkuhbv';
  static const String version = 'v1761044273';
  // https://res.cloudinary.com/deqnkuhbv/image/upload/v1761044273/snappie/assets/avatar/avatar_m4_mdpi.png
  static const String baseUrl = 'https://res.cloudinary.com/$cloudName/image/upload/$version/snappie/assets';

  // Template methods for building URLs dynamically
  static String asset(String path) => '$baseUrl/$path';
  
  static String avatar(String filename) => '$baseUrl/avatar/$filename';
  
  static String logo(String filename) => '$baseUrl/logos/$filename';
  
  static String icon(String filename) => '$baseUrl/icons/$filename';
  
  static String splash(String filename) => '$baseUrl/splash/$filename';
  
  static String banner(String filename) => '$baseUrl/banners/$filename';
  
  static String placeholder(String filename) => '$baseUrl/placeholders/$filename';
  
  static String background(String filename) => '$baseUrl/backgrounds/$filename';

  // Local fallback paths
  static String localAvatar(String filename) => 'assets/avatar/$filename';
  static String localLogo(String filename) => 'assets/logo/$filename';
  static String localIcon(String filename) => 'assets/icon/$filename';
  static String localSplash(String filename) => 'assets/splash/$filename';

  // Common predefined assets (for convenience)
  static String get defaultAvatar => avatar('avatar_m1_hdpi.png');
  static String get placeholderAvatar => avatar('placeholder.png');
  
  static String get appLogo => logo('app_logo.png');
  static String get appLogoWhite => logo('app_logo_white.png');
  static String get appLogoTransparent => logo('app_logo_transparent.png');
  
  static String get notificationIcon => icon('notification.png');
  static String get errorIcon => icon('error.png');
  static String get successIcon => icon('success.png');
  
  static String get splashBackground => splash('background.png');
  static String get splashLogo => splash('logo.png');
  
  static String get homeBanner => banner('home_banner.jpg');
  static String get promoBanner => banner('promo_banner.jpg');
  
  static String get placeholderImage => placeholder('image_placeholder.png');
  static String get noImageAvailable => placeholder('no_image.png');
  
  static String get authBackground => background('auth_bg.png');
  static String get homeBackground => background('home_bg.png');

  // Helper method to validate URL
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Gets the filename from a URL without path or query parameters
  static String getExactFilename(String url) {
    return url.split('/').last.split('?').first;
  }
}
