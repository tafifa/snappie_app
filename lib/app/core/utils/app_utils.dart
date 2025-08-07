import 'dart:async';
import 'package:intl/intl.dart';

class AppUtils {
  // Date formatting
  static String formatDate(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(date);
  }
  
  static String formatDateTime(DateTime dateTime, {String pattern = 'yyyy-MM-dd HH:mm'}) {
    return DateFormat(pattern).format(dateTime);
  }
  
  static DateTime? parseDate(String dateString, {String pattern = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(pattern).parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  // String utilities
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidPassword(String password) {
    return password.length >= 8 && 
           RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password);
  }
  
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[\+]?[1-9][\d]{1,14}$').hasMatch(phone);
  }
  
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  // Number formatting
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
  
  static String formatNumber(num number, {int decimalPlaces = 0}) {
    return NumberFormat('#,##0.${'0' * decimalPlaces}').format(number);
  }
  
  // File size formatting
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  // Color utilities
  static String colorToHex(int color) {
    return '#${color.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
  
  // Debouncing
  static void debounce(Function() action, {Duration delay = const Duration(milliseconds: 500)}) {
    Timer? timer;
    timer = Timer(delay, action);
    timer.cancel();
  }
}
