import 'environment_config.dart';

class ApiEndpoints {
  // Base URLs - Now using EnvironmentConfig
  static String get baseUrl => EnvironmentConfig.baseUrl;
  static String get apiVersion => EnvironmentConfig.apiVersion;
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  
  // User endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile'; // Fixed: matches backend PUT route
  static const String changePassword = '/user/change-password';
  static const String users = '/users';
  
  // Place endpoints
  static const String places = '/places';
  static const String placeDetail = '/places/{id}';
  static const String nearbyPlaces = '/places/nearby';
  static const String placeCategories = '/categories'; // Fixed: matches backend route
  static const String searchPlaces = '/places'; // Fixed: search is handled via query params
  
  // Checkin endpoints
  static const String checkins = '/checkins';
  static const String createCheckin = '/checkins'; // Fixed: matches backend POST route
  static const String checkinHistory = '/checkins/history';
  static const String validateCheckin = '/checkins/validate';
  
  // Review endpoints
  static const String reviews = '/reviews';
  static const String createReview = '/reviews'; // Fixed: matches backend POST route
  static const String updateReview = '/reviews/{id}/update';
  static const String deleteReview = '/reviews/{id}/delete';
  static const String placeReviews = '/places/{id}/reviews';
  
  // Articles endpoints
  static const String articles = '/articles';
  static const String articleDetail = '/articles/{id}';
  static const String searchArticles = '/articles/search';
  static const String bookmarkArticle = '/articles/{id}/bookmark';
  static const String bookmarkedArticles = '/articles/bookmarked';
  
  // Utility methods
  static String getFullUrl(String endpoint) => '$baseUrl$apiVersion$endpoint';
  static String replaceId(String endpoint, String id) => endpoint.replaceAll('{id}', id);
}
