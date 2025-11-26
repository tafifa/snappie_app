import 'package:get/get.dart';
import '../../../data/models/place_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/place_repository_impl.dart';
import '../../../data/repositories/review_repository_impl.dart';
import '../../../data/repositories/checkin_repository_impl.dart';
import '../../../core/services/auth_service.dart';

class ExploreController extends GetxController {
  final PlaceRepository placeRepository;
  final ReviewRepository reviewRepository;
  final CheckinRepository checkinRepository;
  final AuthService authService;

  ExploreController({
    required this.placeRepository,
    required this.reviewRepository,
    required this.checkinRepository,
    required this.authService,
  });

  // Place-related reactive variables
  final _isLoading = false.obs;
  final _places = <PlaceModel>[].obs;
  final _categories = <String>[].obs;
  final _selectedPlace = Rxn<PlaceModel>();
  final _selectedImageUrls = Rxn<List<String>>();
  final _errorMessage = ''.obs;
  final _searchQuery = ''.obs;
  final _selectedCategory = ''.obs;
  final _selectedRating = Rxn<int>();
  final _selectedPriceRange = Rxn<String>();
  final _selectedFilter = ''.obs; // For 'favorit' or 'terlaris'
  final _hasMoreData = true.obs;
  final _currentPage = 1.obs;
  final _isLoadingCategories = false.obs;
  
  // Review-related reactive variables
  final _reviews = <ReviewModel>[].obs;
  final _userReviews = <ReviewModel>[].obs;
  final _isCreatingReview = false.obs;
  final _isLoadingReviews = false.obs;
  final _selectedReview = Rxn<ReviewModel>();
  
  // Check-in related
  final _isCreatingCheckin = false.obs;
  
  // Initialization flag
  final _isInitialized = false.obs;
  
  // Banner visibility state
  final _showBanner = true.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingCategories => _isLoadingCategories.value;
  bool get isLoadingReviews => _isLoadingReviews.value;
  bool get isCreatingReview => _isCreatingReview.value;
  bool get isCreatingCheckin => _isCreatingCheckin.value;
  
  List<PlaceModel> get places => _places;
  List<String> get categories => _categories;
  List<ReviewModel> get reviews => _reviews;
  List<ReviewModel> get userReviews => _userReviews;
  
  PlaceModel? get selectedPlace => _selectedPlace.value;
  List<String>? get selectedImageUrls => _selectedImageUrls.value;
  ReviewModel? get selectedReview => _selectedReview.value;
  
  String get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  int? get selectedRating => _selectedRating.value;
  String? get selectedPriceRange => _selectedPriceRange.value;
  String get selectedFilter => _selectedFilter.value;
  
  // Check if any filter is active
  bool get isFiltered => 
      _searchQuery.value.isNotEmpty ||
      _selectedCategory.value.isNotEmpty ||
      _selectedRating.value != null ||
      _selectedPriceRange.value != null ||
      _selectedFilter.value.isNotEmpty;
  
  // Setters untuk widget access
  set searchQuery(String value) => _searchQuery.value = value;
  set selectedCategory(String value) => _selectedCategory.value = value;
  
  bool get hasMoreData => _hasMoreData.value;
  int get currentPage => _currentPage.value;
  bool get showBanner => _showBanner.value;
  
  void hideBanner() => _showBanner.value = false;

  @override
  void onInit() {
    super.onInit();
    // Set default filter - use valid category from backend
    _selectedCategory.value = '';
    print('🔍 ExploreController created (not initialized yet)');
  }
  
  /// Initialize data hanya saat tab pertama kali dibuka
  void initializeIfNeeded() {
    if (!_isInitialized.value) {
      _isInitialized.value = true;
      print('🔍 ExploreController initializing...');
      initializeExploreData();
    }
  }

  // Call this method when user is authenticated and navigates to explore
  Future<void> initializeExploreData() async {
    print('🚀 INITIALIZING EXPLORE DATA:');
    print('Auth Status: ${authService.isLoggedIn}');
    print('Token: ${authService.token}');
    print('User Email: ${authService.userEmail}');
    
    if (authService.isLoggedIn) {
      print('✅ User authenticated, loading explore data...');
      await loadExploreData();
    } else {
      print('❌ User not authenticated, skipping data load');
    }
  }

  Future<void> loadExploreData() async {
    // Check if user is authenticated
    if (!authService.isLoggedIn) {
      print('User not authenticated, cannot load explore data');
      _setError('Please login to view places and categories');
      return;
    }

    await Future.wait([
      loadPlaces(),
      loadCategories(),
    ]);
  }

  // ===== PLACE METHODS =====

  Future<void> loadPlaces({bool refresh = false}) async {
    // Check authentication before loading
    if (!authService.isLoggedIn) {
      _setError('Please login to view places');
      return;
    }

    if (refresh) {
      _currentPage.value = 1;
      _hasMoreData.value = true;
      _places.clear();
    }
    
    if (!_hasMoreData.value && !refresh) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      // Load places from repository
      final placesList = await placeRepository.getPlaces(
        perPage: 20,
        search: _searchQuery.value.isNotEmpty ? _searchQuery.value : null,
        minRating: _selectedRating.value?.toDouble(),
        // Add more filters as needed
      );
      
      print('🎯 PLACES LOADED SUCCESSFULLY:');
      print('Places Count: ${placesList.length}');
      print('First Place: ${placesList.isNotEmpty ? placesList.first.name : "None"}');
      
      if (refresh || _currentPage.value == 1) {
        print('🔄 Assigning all places to _places');
        _places.assignAll(placesList);
      } else {
        print('➕ Adding places to existing _places');
        _places.addAll(placesList);
      }
      
      print('📱 _places length after update: ${_places.length}');
      print('📱 _places.isEmpty: ${_places.isEmpty}');
      
      if (placesList.isEmpty) {
        _hasMoreData.value = false;
      } else {
        _currentPage.value++;
      }
      
      // Force UI update
      _places.refresh();
    } catch (e) {
      _setError('Failed to load places: $e');
      print('❌ Error loading places: $e');
    }
    
    _setLoading(false);
  }

  Future<void> loadCategories() async {
    // Check authentication before loading
    if (!authService.isLoggedIn) {
      print('User not authenticated, cannot load categories');
      return;
    }

    _isLoadingCategories.value = true;
    
    try {
      // TODO: Implement categories API endpoint
      // For now, use hardcoded categories
      _categories.assignAll(['Semua', 'Restoran', 'Kafe', 'Street Food', 'Fast Food']);
      print('📋 Categories loaded');
    } catch (e) {
      // Handle error silently for categories
      print('Error loading categories: $e');
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

  void setSelectedRating(int rating) {
    _selectedRating.value = rating;
    // Don't load places immediately, wait for user to press OK
  }

  void applyRatingFilter() {
    loadPlaces(refresh: true);
  }

  void clearRatingFilter() {
    _selectedRating.value = null;
    loadPlaces(refresh: true);
  }

  void setSelectedPriceRange(String priceRange) {
    _selectedPriceRange.value = priceRange;
    // Don't load places immediately, wait for user to press OK
  }

  void applyPriceFilter() {
    loadPlaces(refresh: true);
  }

  void clearPriceFilter() {
    _selectedPriceRange.value = null;
    loadPlaces(refresh: true);
  }

  void filterByNearby() {
    // TODO: Implement nearby filter logic
    // This would typically use location services to sort by distance
    loadPlaces(refresh: true);
  }

  void setFavoritFilter() {
    _selectedFilter.value = 'favorit';
    loadPlaces(refresh: true);
  }

  void setTerlarisFilter() {
    _selectedFilter.value = 'terlaris';
    loadPlaces(refresh: true);
  }

  void clearFilters() {
    _selectedCategory.value = '';
    _searchQuery.value = '';
    _selectedRating.value = null;
    _selectedPriceRange.value = null;
    _selectedFilter.value = '';
    loadPlaces(refresh: true);
  }

  void loadMorePlaces() {
    if (!_isLoading.value && _hasMoreData.value) {
      loadPlaces();
    }
  }

  void selectPlace(PlaceModel? place) {
    _selectedPlace.value = place;
    _selectedImageUrls.value = place?.imageUrls;
  }

  Future<void> loadPlaceById(int placeId) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Load place by ID from repository
      final place = await placeRepository.getPlaceById(placeId);
      selectPlace(place);
      
      // Also load reviews for this place
      await loadPlaceReviews(placeId);
      
      print('🎯 Place loaded by ID: ${place.name}');
    } catch (e) {
      _setError('Failed to load place: $e');
      print('❌ Error loading place by ID: $e');
    }
    
    _setLoading(false);
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
      // Load reviews from repository
      final reviewsList = await reviewRepository.getPlaceReviews(placeId);
      _reviews.assignAll(reviewsList);
      print('📝 Reviews loaded: ${reviewsList.length}');
    } catch (e) {
      _setError('Failed to load reviews: $e');
      print('❌ Error loading reviews: $e');
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
    };
  }

  Future<void> createReview({
    required int placeId,
    required int vote,
    required String content,
    List<String>? imageUrls,
  }) async {
    _isCreatingReview.value = true;
    _clearError();
    
    try {
      // Create review via repository
      await reviewRepository.createReview(
        placeId: placeId,
        content: content,
        rating: vote,
        imageUrls: imageUrls,
      );
      
      Get.snackbar(
        'Success',
        'Review submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      await loadPlaceReviews(placeId);
    } catch (e) {
      _setError('Failed to create review: $e');
      Get.snackbar(
        'Error',
        'Failed to create review: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    
    _isCreatingReview.value = false;
  }

  // ===== CHECKIN METHODS =====

  Future<void> createCheckin({
    required int placeId,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    _isCreatingCheckin.value = true;
    _clearError();
    
    try {
      // Create checkin via repository
      await checkinRepository.createCheckin(
        placeId: placeId,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
      );
      
      Get.snackbar(
        'Success',
        'Check-in created successfully! (API Mode)',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _setError('Failed to create check-in: $e');
      Get.snackbar(
        'Error',
        'Failed to create check-in: $e',
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
