import 'package:get/get.dart';
import '../../../domain/entities/place_entity.dart';
import '../../../domain/entities/review_entity.dart';

class ExploreController extends GetxController {
  
  // Place-related reactive variables
  final _isLoading = false.obs;
  final _places = <PlaceEntity>[].obs;
  final _categories = <String>[].obs;
  final _selectedPlace = Rxn<PlaceEntity>();
  final _errorMessage = ''.obs;
  final _searchQuery = ''.obs;
  final _selectedCategory = ''.obs;
  final _hasMoreData = true.obs;
  final _currentPage = 1.obs;
  final _isLoadingCategories = false.obs;
  
  // Review-related reactive variables
  final _reviews = <ReviewEntity>[].obs;
  final _userReviews = <ReviewEntity>[].obs;
  final _isCreatingReview = false.obs;
  final _isLoadingReviews = false.obs;
  final _selectedReview = Rxn<ReviewEntity>();
  
  // Check-in related
  final _isCreatingCheckin = false.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingCategories => _isLoadingCategories.value;
  bool get isLoadingReviews => _isLoadingReviews.value;
  bool get isCreatingReview => _isCreatingReview.value;
  bool get isCreatingCheckin => _isCreatingCheckin.value;
  
  List<PlaceEntity> get places => _places;
  List<String> get categories => _categories;
  List<ReviewEntity> get reviews => _reviews;
  List<ReviewEntity> get userReviews => _userReviews;
  
  PlaceEntity? get selectedPlace => _selectedPlace.value;
  ReviewEntity? get selectedReview => _selectedReview.value;
  
  String get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  
  // Setters untuk widget access
  set searchQuery(String value) => _searchQuery.value = value;
  set selectedCategory(String value) => _selectedCategory.value = value;
  
  bool get hasMoreData => _hasMoreData.value;
  int get currentPage => _currentPage.value;
  
  @override
  void onInit() {
    super.onInit();
    // Set default filter
    _selectedCategory.value = 'nearby';
    loadExploreData();
  }
  
  Future<void> loadExploreData() async {
    await Future.wait([
      loadPlaces(),
      loadCategories(),
    ]);
  }
  
  // ===== PLACE METHODS =====
  
  Future<void> loadPlaces({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _hasMoreData.value = true;
      _places.clear();
    }
    
    if (!_hasMoreData.value && !refresh) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      // Mock data - replace with actual implementation
      await Future.delayed(const Duration(milliseconds: 500));
      
      final mockPlaces = <PlaceEntity>[
        PlaceEntity(
          id: 1,
          name: 'Sagamatha Coffee Bar',
          category: 'Cafe',
          address: 'Jl. Kemang Raya No. 123, Jakarta Selatan',
          latitude: -6.2608,
          longitude: 106.7941,
          imageUrls: ['https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500'],
          partnershipStatus: 'active',
          rewardInfo: const RewardInfo(baseExp: 20, baseCoin: 10),
          averageRating: 4.2,
          totalReviews: 128,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
          distance: 0.5,
        ),
        PlaceEntity(
          id: 2,
          name: 'Warung Gudeg Bu Endang',
          category: 'Traditional',
          address: 'Jl. Malioboro No. 456, Yogyakarta',
          latitude: -7.7956,
          longitude: 110.3695,
          imageUrls: ['https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500'],
          partnershipStatus: 'active',
          rewardInfo: const RewardInfo(baseExp: 25, baseCoin: 15),
          averageRating: 4.8,
          totalReviews: 89,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          updatedAt: DateTime.now(),
          distance: 1.2,
        ),
        PlaceEntity(
          id: 3,
          name: 'Kopi Kenangan',
          category: 'Cafe',
          address: 'Jl. Sudirman No. 789, Jakarta Pusat',
          latitude: -6.2088,
          longitude: 106.8456,
          imageUrls: ['https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500'],
          partnershipStatus: 'active',
          rewardInfo: const RewardInfo(baseExp: 15, baseCoin: 8),
          averageRating: 4.5,
          totalReviews: 256,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
          distance: 0.8,
        ),
        PlaceEntity(
          id: 4,
          name: 'Restoran Padang Sederhana',
          category: 'Restaurant',
          address: 'Jl. Asia Afrika No. 321, Bandung',
          latitude: -6.9175,
          longitude: 107.6191,
          imageUrls: ['https://images.unsplash.com/photo-1559925393-8be0ec4767c8?w=500'],
          partnershipStatus: 'active',
          rewardInfo: const RewardInfo(baseExp: 30, baseCoin: 20),
          averageRating: 4.6,
          totalReviews: 167,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
          distance: 2.1,
        ),
      ];
      
      if (refresh || _currentPage.value == 1) {
        _places.assignAll(mockPlaces);
      } else {
        _places.addAll(mockPlaces);
      }
      
      if (mockPlaces.isEmpty) {
        _hasMoreData.value = false;
      } else {
        _currentPage.value++;
      }
    } catch (e) {
      _setError('Failed to load places');
    }
    
    _setLoading(false);
  }
  
  Future<void> loadCategories() async {
    _isLoadingCategories.value = true;
    
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _categories.assignAll(['Restaurant', 'Cafe', 'Shop', 'Tourist Spot', 'Hotel']);
    } catch (e) {
      // Handle error silently for categories
    }
    
    _isLoadingCategories.value = false;
  }
  
  Future<void> loadNearbyPlaces({
    required double latitude,
    required double longitude,
  }) async {
    await loadPlaces(refresh: true);
  }
  
  void searchPlaces(String query) {
    _searchQuery.value = query;
    loadPlaces(refresh: true);
  }
  
  void filterByCategory(String category) {
    _selectedCategory.value = category;
    loadPlaces(refresh: true);
  }
  
  void clearFilters() {
    _selectedCategory.value = '';
    _searchQuery.value = '';
    loadPlaces(refresh: true);
  }
  
  void loadMorePlaces() {
    if (!_isLoading.value && _hasMoreData.value) {
      loadPlaces();
    }
  }
  
  void selectPlace(PlaceEntity place) {
    _selectedPlace.value = place;
  }
  
  Future<void> refreshData() async {
    await Future.wait([
      loadPlaces(refresh: true),
      loadCategories(),
    ]);
  }
  
  // ===== REVIEW METHODS =====
  
  Future<void> loadPlaceReviews(int placeId) async {
    _isLoadingReviews.value = true;
    _clearError();
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _reviews.assignAll([]);
    } catch (e) {
      _setError('Failed to load reviews');
    }
    
    _isLoadingReviews.value = false;
  }
  
  // Filter reviews by status
  void filterByStatus(String status) {
    // Mock implementation - in real app would filter reviews
    loadPlaceReviews(1); // Mock place ID
  }
  
  // Load more reviews data
  void loadMoreData() {
    if (!_isLoadingReviews.value && _hasMoreData.value) {
      // Mock load more implementation
    }
  }
  
  // Get review statistics
  Map<String, int> getReviewStats() {
    final total = _reviews.length;
    return {
      'total': total,
      'approved': (total * 0.8).round(),
      'pending': (total * 0.15).round(),
      'rejected': (total * 0.05).round(),
    };
  }
  
  // Get user review statistics
  Map<String, int> getUserReviewStats() {
    final userReviews = _userReviews.length;
    return {
      'total': userReviews,
      'approved': (userReviews * 0.9).round(),
      'pending': (userReviews * 0.1).round(),
    };
  }
  
  Future<void> createReview({
    required int placeId,
    required int vote,
    required String content,
  }) async {
    _isCreatingReview.value = true;
    _clearError();
    
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      Get.snackbar(
        'Success',
        'Review submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      await loadPlaceReviews(placeId);
    } catch (e) {
      _setError('Failed to create review');
      Get.snackbar(
        'Error',
        'Failed to create review',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    
    _isCreatingReview.value = false;
  }
  
  // ===== CHECKIN METHODS =====
  
  Future<void> createCheckin({
    required String placeId,
    required double latitude,
    required double longitude,
  }) async {
    _isCreatingCheckin.value = true;
    _clearError();
    
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      Get.snackbar(
        'Success',
        'Check-in created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _setError('Failed to create check-in');
      Get.snackbar(
        'Error',
        'Failed to create check-in',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    
    _isCreatingCheckin.value = false;
  }
  
  // ===== PRIVATE METHODS =====
  
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }
  
  void _setError(String error) {
    _errorMessage.value = error;
  }
  
  void _clearError() {
    _errorMessage.value = '';
  }
}
