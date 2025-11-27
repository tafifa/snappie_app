import 'package:flutter/material.dart';

enum FoodType {
  nusantara,
  internasional,
  seafood,
  kafein,
  nonKafein,
  vegetarian,
  dessert,
  makananRingan,
  pastry,
}

extension FoodTypeExtension on FoodType {
  String get label {
    switch (this) {
      case FoodType.nusantara:
        return 'Nusantara';
      case FoodType.internasional:
        return 'Internasional';
      case FoodType.seafood:
        return 'Seafood';
      case FoodType.kafein:
        return 'Kafein';
      case FoodType.nonKafein:
        return 'Non-Kafein';
      case FoodType.vegetarian:
        return 'Vegetarian';
      case FoodType.dessert:
        return 'Dessert';
      case FoodType.makananRingan:
        return 'Makanan Ringan';
      case FoodType.pastry:
        return 'Pastry';
    }
  }

  IconData get icon {
    switch (this) {
      case FoodType.nusantara:
        return Icons.rice_bowl;
      case FoodType.internasional:
        return Icons.public;
      case FoodType.seafood:
        return Icons.set_meal;
      case FoodType.kafein:
        return Icons.coffee;
      case FoodType.nonKafein:
        return Icons.local_drink;
      case FoodType.vegetarian:
        return Icons.eco;
      case FoodType.dessert:
        return Icons.cake;
      case FoodType.makananRingan:
        return Icons.fastfood;
      case FoodType.pastry:
        return Icons.bakery_dining;
    }
  }

  /// Get all labels as list
  static List<String> get allLabels => FoodType.values.map((e) => e.label).toList();

  /// Get icon by label
  static IconData? getIconByLabel(String label) {
    final normalizedLabel = label.toLowerCase().trim();
    for (final value in FoodType.values) {
      if (value.label.toLowerCase() == normalizedLabel) {
        return value.icon;
      }
    }
    return null;
  }
}