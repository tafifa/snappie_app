import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/place_entity.dart';

abstract class PlaceLocalDataSource {
  Future<void> savePlaces(List<PlaceEntity> places);
  Future<List<PlaceEntity>> getPlaces({String? category, String? search});
  Future<void> saveCategories(List<String> categories);
  Future<List<String>> getCategories();
  Future<void> clearPlaces();
  Future<void> clearCategories();
  Future<DateTime?> getLastSyncTime();
  Future<void> updateLastSyncTime();
  Future<bool> hasCachedData();
  Future<bool> hasCachedCategories();
  Future<void> toggleFavorite(int placeId, bool isFavorite);
  Future<List<PlaceEntity>> getFavoritePlaces();
}

class PlaceLocalDataSourceImpl implements PlaceLocalDataSource {
  static const String _placesKey = 'cached_places';
  static const String _categoriesKey = 'cached_categories';
  static const String _lastSyncKey = 'last_sync_time';
  static const String _favoritesKey = 'favorite_places';
  
  @override
  Future<void> savePlaces(List<PlaceEntity> places) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert places to JSON
      final placesJson = places.map((place) => {
        'id': place.id,
        'name': place.name,
        'category': place.category,
        'address': place.address,
        'latitude': place.latitude,
        'longitude': place.longitude,
        'imageUrls': place.imageUrls,
        'partnershipStatus': place.partnershipStatus,
        'averageRating': place.averageRating,
        'totalReviews': place.totalReviews,
        'createdAt': place.createdAt.toIso8601String(),
        'updatedAt': place.updatedAt.toIso8601String(),
        'distance': place.distance,
        'rewardInfo': place.rewardInfo != null ? {
          'baseExp': place.rewardInfo!.baseExp,
          'baseCoin': place.rewardInfo!.baseCoin,
        } : null,
      }).toList();
      
      await prefs.setString(_placesKey, jsonEncode(placesJson));
      await updateLastSyncTime();
      
      print('💾 Saved ${places.length} places to local storage');
    } catch (e) {
      print('❌ Error saving places to local storage: $e');
      rethrow;
    }
  }
  
  @override
  Future<List<PlaceEntity>> getPlaces({String? category, String? search}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final placesJson = prefs.getString(_placesKey);
      
      if (placesJson == null) {
        return [];
      }
      
      final List<dynamic> placesData = jsonDecode(placesJson);
      List<PlaceEntity> places = placesData.map((data) => _placeFromJson(data)).toList();
      
      // Apply filters
      if (category != null && category.isNotEmpty) {
        places = places.where((place) => place.category == category).toList();
      }
      
      if (search != null && search.isNotEmpty) {
        places = places.where((place) => 
          place.name.toLowerCase().contains(search.toLowerCase())
        ).toList();
      }
      
      print('📱 Loaded ${places.length} places from local storage');
      return places;
    } catch (e) {
      print('❌ Error loading places from local storage: $e');
      return [];
    }
  }
  
  @override
  Future<void> saveCategories(List<String> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_categoriesKey, categories);
      print('💾 Saved ${categories.length} categories to local storage');
    } catch (e) {
      print('❌ Error saving categories to local storage: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categories = prefs.getStringList(_categoriesKey) ?? [];
      print('📱 Loaded ${categories.length} categories from local storage');
      return categories;
    } catch (e) {
      print('❌ Error loading categories from local storage: $e');
      return [];
    }
  }

  @override
  Future<void> clearPlaces() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_placesKey);
      await prefs.remove(_lastSyncKey);
      print('🗑️ Cleared all places from local storage');
    } catch (e) {
      print('❌ Error clearing places from local storage: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_categoriesKey);
      print('🗑️ Cleared all categories from local storage');
    } catch (e) {
      print('❌ Error clearing categories from local storage: $e');
      rethrow;
    }
  }
  
  @override
  Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastSyncKey);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      print('❌ Error getting last sync time: $e');
      return null;
    }
  }
  
  @override
  Future<void> updateLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('❌ Error updating last sync time: $e');
    }
  }
  
  @override
  Future<bool> hasCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_placesKey);
    } catch (e) {
      print('❌ Error checking cached data: $e');
      return false;
    }
  }

  @override
  Future<bool> hasCachedCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_categoriesKey);
    } catch (e) {
      print('❌ Error checking cached categories: $e');
      return false;
    }
  }
  
  @override
  Future<void> toggleFavorite(int placeId, bool isFavorite) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey) ?? '[]';
      final List<int> favorites = List<int>.from(jsonDecode(favoritesJson));
      
      if (isFavorite) {
        if (!favorites.contains(placeId)) {
          favorites.add(placeId);
        }
      } else {
        favorites.remove(placeId);
      }
      
      await prefs.setString(_favoritesKey, jsonEncode(favorites));
      print('⭐ Toggled favorite for place $placeId: $isFavorite');
    } catch (e) {
      print('❌ Error toggling favorite: $e');
      rethrow;
    }
  }
  
  @override
  Future<List<PlaceEntity>> getFavoritePlaces() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey) ?? '[]';
      final List<int> favoriteIds = List<int>.from(jsonDecode(favoritesJson));
      
      if (favoriteIds.isEmpty) {
        return [];
      }
      
      final allPlaces = await getPlaces();
      final favoritePlaces = allPlaces.where((place) => favoriteIds.contains(place.id)).toList();
      
      print('⭐ Loaded ${favoritePlaces.length} favorite places');
      return favoritePlaces;
    } catch (e) {
      print('❌ Error loading favorite places: $e');
      return [];
    }
  }
  
  PlaceEntity _placeFromJson(Map<String, dynamic> data) {
    return PlaceEntity(
      id: data['id'],
      name: data['name'],
      category: data['category'],
      address: data['address'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      imageUrls: List<String>.from(data['imageUrls']),
      partnershipStatus: data['partnershipStatus'],
      rewardInfo: data['rewardInfo'] != null ? RewardInfo(
        baseExp: data['rewardInfo']['baseExp'],
        baseCoin: data['rewardInfo']['baseCoin'],
      ) : null,
      averageRating: data['averageRating'],
      totalReviews: data['totalReviews'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      distance: data['distance'],
    );
  }
}
