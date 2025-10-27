import '../core/constants/environment_config.dart';

class ApiEndpoints {
  // Base URLs - Now using EnvironmentConfig
  static String get baseUrl => EnvironmentConfig.baseUrl;
  static String get apiVersion => EnvironmentConfig.apiVersion;
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  
  // User endpoints
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String users = '/users';
  static const String userById = '/users/id/{id}';
  
  // Place endpoints
  static const String places = '/places';
  static const String placeDetail = '/places/id/{id}';
  static const String placeReviews = '/places/id/{id}/reviews';
  
  // Checkin endpoints
  static const String createCheckin = '/gamification/checkin';
  static const String reviewPlace = '/gamification/review';
  static const String coinTransactions = '/gamification/coins/transactions';
  static const String expTransactions = '/gamification/exp/transactions';
  
  // Articles endpoints
  static const String articles = '/articles';
  static const String articleDetail = '/articles/id/{id}';

  // Posts endpoints
  static const String posts = '/social/posts';
  static const String feedPosts = '/social/posts/feed';
  static const String trendingPosts = '/social/posts/trending';
  static const String postDetail = '/social/posts/id/{id}';

  
  // Utility methods
  static String getFullUrl(String endpoint) => '$baseUrl$apiVersion$endpoint';
  static String replaceId(String endpoint, String id) => endpoint.replaceAll('{id}', id);
}
