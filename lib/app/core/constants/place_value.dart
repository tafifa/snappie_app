import 'package:flutter/material.dart';

enum PlaceValue {
  affordablePrice,
  authenticTaste,
  variedMenu,
  open24Hours,
  goodNetwork,
  aesthetic,
  calmAtmosphere,
  traditionalAtmosphere,
  homeyAtmosphere,
  petFriendly,
  familyFriendly,
  friendlyService,
  hangoutSpot,
  workFromCafe,
  historicalPlace,
}

extension PlaceValueExtension on PlaceValue {
  String get label {
    switch (this) {
      case PlaceValue.affordablePrice:
        return 'Harga Terjangkau';
      case PlaceValue.authenticTaste:
        return 'Rasa Autentik';
      case PlaceValue.variedMenu:
        return 'Menu Bervariasi';
      case PlaceValue.open24Hours:
        return 'Buka 24 Jam';
      case PlaceValue.goodNetwork:
        return 'Jaringan Lancar';
      case PlaceValue.aesthetic:
        return 'Estetika';
      case PlaceValue.calmAtmosphere:
        return 'Suasana Tenang';
      case PlaceValue.traditionalAtmosphere:
        return 'Suasana Tradisional';
      case PlaceValue.homeyAtmosphere:
        return 'Suasana Homey';
      case PlaceValue.petFriendly:
        return 'Pet Friendly';
      case PlaceValue.familyFriendly:
        return 'Ramah Keluarga';
      case PlaceValue.friendlyService:
        return 'Pelayanan Ramah';
      case PlaceValue.hangoutSpot:
        return 'Cocok untuk Nongkrong';
      case PlaceValue.workFromCafe:
        return 'Cocok untuk Work From Cafe';
      case PlaceValue.historicalPlace:
        return 'Tempat Bersejarah';
    }
  }

  IconData get icon {
    switch (this) {
      case PlaceValue.affordablePrice:
        return Icons.attach_money;
      case PlaceValue.authenticTaste:
        return Icons.restaurant;
      case PlaceValue.variedMenu:
        return Icons.menu_book;
      case PlaceValue.open24Hours:
        return Icons.nights_stay;
      case PlaceValue.goodNetwork:
        return Icons.wifi;
      case PlaceValue.aesthetic:
        return Icons.brush;
      case PlaceValue.calmAtmosphere:
        return Icons.spa;
      case PlaceValue.traditionalAtmosphere:
        return Icons.temple_hindu;
      case PlaceValue.homeyAtmosphere:
        return Icons.home_filled;
      case PlaceValue.petFriendly:
        return Icons.pets;
      case PlaceValue.familyFriendly:
        return Icons.family_restroom;
      case PlaceValue.friendlyService:
        return Icons.emoji_people;
      case PlaceValue.hangoutSpot:
        return Icons.groups_2_outlined;
      case PlaceValue.workFromCafe:
        return Icons.laptop_mac;
      case PlaceValue.historicalPlace:
        return Icons.museum_outlined;
    }
  }

  /// Get all labels as list
  static List<String> get allLabels => PlaceValue.values.map((e) => e.label).toList();

  /// Get icon by label (for API response matching)
  static IconData? getIconByLabel(String label) {
    final normalizedLabel = label.toLowerCase().trim();
    for (final value in PlaceValue.values) {
      if (value.label.toLowerCase() == normalizedLabel) {
        return value.icon;
      }
    }
    return null; // Default icon if not found
  }
}