import 'dart:async';

import 'package:get/get.dart';
import 'package:snappie_app/app/core/constants/app_colors.dart';
import 'package:snappie_app/app/core/constants/food_type.dart';
import 'package:snappie_app/app/core/constants/place_value.dart';
import '../../../data/models/place_model.dart';
import '../../../data/models/review_model.dart';
import '../../../data/models/checkin_model.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/place_repository_impl.dart';
import '../../../data/repositories/review_repository_impl.dart';
import '../../../data/repositories/checkin_repository_impl.dart';
import '../../../data/repositories/post_repository_impl.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/location_service.dart';

class ExploreController extends GetxController {
  final PlaceRepository placeRepository;
  final ReviewRepository reviewRepository;
  final CheckinRepository checkinRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;
  final AuthService authService;

  ExploreController({
    required this.placeRepository,
    required this.reviewRepository,
    required this.checkinRepository,
    required this.postRepository,
    required this.userRepository,
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
  final _selectedLocation = Rxn<List<double>>();
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

  // Gallery-related reactive variables
  final _galleryCheckins = <CheckinModel>[].obs;
  final _galleryPosts = <PostModel>[].obs;
  final _isLoadingGalleryCheckins = false.obs;
  final _isLoadingGalleryPosts = false.obs;

  // Favorite/Saved places related
  final _isTogglingFavorite = false.obs;
  final _savedPlaces = <int>[].obs;
  final _isLoadingSavedPlaces = false.obs;

  // Initialization flag
  final _isInitialized = false.obs;

  // Banner visibility state
  final _showBanner = true.obs;
  final _showMissionCta = true.obs;


  Timer? _searchDebounce;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingCategories => _isLoadingCategories.value;
  bool get isLoadingReviews => _isLoadingReviews.value;
  bool get isCreatingReview => _isCreatingReview.value;
  bool get isCreatingCheckin => _isCreatingCheckin.value;
  bool get isLoadingGalleryCheckins => _isLoadingGalleryCheckins.value;
  bool get isLoadingGalleryPosts => _isLoadingGalleryPosts.value;
  bool get isTogglingFavorite => _isTogglingFavorite.value;
  bool get isLoadingSavedPlaces => _isLoadingSavedPlaces.value;
  List<int> get savedPlaces => _savedPlaces;

  List<PlaceModel> get places => _places;
  List<String> get categories => _categories;
  List<ReviewModel> get reviews => _reviews;
  List<ReviewModel> get userReviews => _userReviews;
  List<CheckinModel> get galleryCheckins => _galleryCheckins;
  List<PostModel> get galleryPosts => _galleryPosts;

  PlaceModel? get selectedPlace => _selectedPlace.value;
  List<String>? get selectedImageUrls => _selectedImageUrls.value;
  ReviewModel? get selectedReview => _selectedReview.value;

  String get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  int? get selectedRating => _selectedRating.value;
  String? get selectedPriceRange => _selectedPriceRange.value;
  String get selectedFilter => _selectedFilter.value;

  List<String> get foodTypes => FoodTypeExtension.allLabels;
  List<String> get placeValues => PlaceValueExtension.allLabels;

    final _selectedFoodTypes = <String>[].obs;
  final _selectedPlaceValues = <String>[].obs;
  RxList<String> get selectedFoodTypes => _selectedFoodTypes;
  RxList<String> get selectedPlaceValues => _selectedPlaceValues;

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
  bool get showMissionCta => _showMissionCta.value;

  void hideBanner() => _showBanner.value = false;
  void hideMissionCta() => _showMissionCta.value = false;
  void showMissionCtaPrompt() => _showMissionCta.value = true;

  @override
  void onInit() {
    super.onInit();
    // Set default filter - use valid category from backend
    _selectedCategory.value = '';
    print('🔍 ExploreController created (not initialized yet)');
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
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
      print("Load Places with filters: _searchQuery='${_searchQuery.value}', "
          "selectedCategory='${_selectedCategory.value}', "
          "selectedRating=${_selectedRating.value}, "
          "selectedPriceRange='${_selectedPriceRange.value}', "
          "selectedFilter='${_selectedFilter.value}', "
          "selectedLocation=${_selectedLocation.value}");
      // Load places from repository
      final placesList = await placeRepository.getPlaces(
        perPage: 20,
        search: _searchQuery.value.isNotEmpty ? _searchQuery.value : null,
        minRating: _selectedRating.value?.toDouble(),
        partner: _selectedFilter.value == 'partner' ? true : null,
        popular: _selectedFilter.value == 'popular' ? true : null,
        longitude: _selectedFilter.value == 'nearby' ? _selectedLocation.value![1] : null,
        latitude: _selectedFilter.value == 'nearby' ? _selectedLocation.value![0] :  null,
        placeValues: _selectedFilter.value == 'placeValues' ? _selectedPlaceValues.toList() : null,
        foodTypes: _selectedFilter.value == 'foodTypes' ? _selectedFoodTypes.toList() : null,
      );

      print('🎯 PLACES LOADED SUCCESSFULLY:');
      print('Places Count: ${placesList.length}');
      print(
          'First Place: ${placesList.isNotEmpty ? placesList.first.name : "None"}');
      print(
          'Firs Place Additional Info: ${placesList.isNotEmpty ? placesList.first.placeAttributes : "None"}');

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
      _categories
          .assignAll(['Semua', 'Restoran', 'Kafe', 'Street Food', 'Fast Food']);
      print('📋 Categories loaded');
    } catch (e) {
      // Handle error silently for categories
      print('Error loading categories: $e');
    }

    _isLoadingCategories.value = false;
  }

  void searchPlaces(String query) {
    _searchQuery.value = query;
    loadPlaces(refresh: true);
  }

  void handleSearchInput(String query, {Duration delay = const Duration(milliseconds: 900)}) {
    _searchQuery.value = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(delay, () {
      if (_searchQuery.value.isEmpty) {
        loadPlaces(refresh: true);
      } else {
        searchPlaces(_searchQuery.value);
      }
    });
  }

  void applyFilter(String filter) {
    _selectedFilter.value = filter;
    loadPlaces(refresh: true);
  }

  void togglePlaceValueSelection(String placeValue) {
    if (_selectedPlaceValues.contains(placeValue)) {
      _selectedPlaceValues.remove(placeValue);
      print('❌ Place value removed: $placeValue');
    } else {
      _selectedPlaceValues.add(placeValue);
      print('✅ Place value selected: $placeValue');
    }
    print('📍 Total selected: ${_selectedPlaceValues.length} - ${_selectedPlaceValues.join(", ")}');
  }

    void toggleFoodTypeSelection(String foodType) {
    if (_selectedFoodTypes.contains(foodType)) {
      _selectedFoodTypes.remove(foodType);
      print('❌ Food type removed: $foodType');
    } else {
      _selectedFoodTypes.add(foodType);
      print('✅ Food type selected: $foodType');
    }
    print(
        '📋 Total selected: ${_selectedFoodTypes.length} - ${_selectedFoodTypes.join(", ")}');
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

  Future<void> filterByNearby() async {
    final locationService = Get.find<LocationService>();
    final position = await locationService.getCurrentPosition();
    if (position == null) return;

    print('📍 Current Position: Lat ${position.latitude}, Lon ${position.longitude}');
    _selectedFilter.value = 'nearby';
    _selectedLocation.value = [position.latitude, position.longitude];
    await loadPlaces(refresh: true);
  }

  void clearFilters() {
    _selectedCategory.value = '';
    _searchQuery.value = '';
    _selectedRating.value = null;
    _selectedPriceRange.value = null;
    _selectedFilter.value = '';
    _selectedLocation.value = null;
    _selectedPlaceValues.clear();
    _selectedFoodTypes.clear();
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
    required PlaceModel? place,
    required int vote,
    required String content,
    List<String>? imageUrls,
    Map<String, dynamic> additionalInfo = const {},
  }) async {
    _isCreatingReview.value = true;
    _clearError();

    try {
      // Create review via repository
      await reviewRepository.createReview(
        placeId: place!.id!,
        content: content,
        rating: vote,
        imageUrls: imageUrls,
        additionalInfo: additionalInfo,
      );

      // Show success and go back to place reviews list
      Get.snackbar(
        'Berhasil',
        'Ulasan berhasil dikirim! Kamu mendapatkan ${place.expReward ?? 50} XP dan ${place.coinReward ?? 25} Koin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: AppColors.textOnPrimary,
        duration: const Duration(seconds: 3),
      );

      await loadPlaceReviews(place.id!);

      await Future.delayed(Duration(milliseconds: 100));
      Get.back(closeOverlays: true);
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
    Map<String, dynamic> additionalInfo = const {},
  }) async {
    _isCreatingCheckin.value = true;
    _clearError();

    try {
      // Create checkin via repository
      await checkinRepository.createCheckin(
        placeId: placeId,
        latitude: latitude,
        longitude: longitude,
        additionalInfo: additionalInfo,
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

  // ===== GALLERY METHODS =====

  /// Load checkins for gallery (Galeri Misi tab)
  Future<void> loadGalleryCheckins(int placeId) async {
    _isLoadingGalleryCheckins.value = true;
    _galleryCheckins.clear();

    try {
      final checkins = await checkinRepository.getCheckinsByPlaceId(placeId);
      _galleryCheckins.assignAll(checkins);
      print('📸 Gallery checkins loaded: ${checkins.length}');
    } catch (e) {
      print('❌ Error loading gallery checkins: $e');
      // Silent fail - gallery will show empty state
    }

    _isLoadingGalleryCheckins.value = false;
  }

  /// Load posts for gallery (Postingan Terkait tab)
  Future<void> loadGalleryPosts(int placeId) async {
    _isLoadingGalleryPosts.value = true;
    _galleryPosts.clear();

    try {
      final posts = await postRepository.getPostsByPlaceId(placeId);
      _galleryPosts.assignAll(posts);
      print('📝 Gallery posts loaded: ${posts.length}');
    } catch (e) {
      print('❌ Error loading gallery posts: $e');
      // Silent fail - gallery will show empty state
    }

    _isLoadingGalleryPosts.value = false;
  }

  /// Get all image URLs from checkins (for Galeri Misi)
  List<String> get galleryCheckinImages {
    return _galleryCheckins
        .where((c) => c.imageUrl != null && c.imageUrl!.isNotEmpty)
        .map((c) => c.imageUrl!)
        .toList();
  }

  /// Get all image URLs from posts (for Postingan Terkait)
  List<String> get galleryPostImages {
    final images = <String>[];
    for (final post in _galleryPosts) {
      if (post.imageUrls != null && post.imageUrls!.isNotEmpty) {
        images.addAll(post.imageUrls!);
      }
    }
    return images;
  }

  // ===== FAVORITE/SAVED PLACES METHODS =====

  /// Load user's saved places from API
  Future<void> loadSavedPlaces() async {
    if (_isLoadingSavedPlaces.value) return;
    
    _isLoadingSavedPlaces.value = true;
    try {
      final userSaved = await userRepository.getUserSaved();
      _savedPlaces.assignAll(userSaved.savedPlaces ?? []);
      print('⭐ Loaded saved places: ${_savedPlaces.length}');
      print('⭐ Saved place IDs: ${_savedPlaces.join(", ")}');
    } catch (e) {
      print('❌ Error loading saved places: $e');
      // Silent fail - will show as not saved
    } finally {
      _isLoadingSavedPlaces.value = false;
    }
  }

  /// Check if a place is saved in user's favorites
  bool isPlaceSaved(int placeId) {
    return _savedPlaces.contains(placeId);
  }

  /// Toggle save/unsave a place from favorites
  Future<bool> toggleSavedPlace(int placeId) async {
    if (_isTogglingFavorite.value) return false;
    
    _isTogglingFavorite.value = true;

    try {
      // Check if already saved locally
      final isCurrentlySaved = _savedPlaces.contains(placeId);
      print('⭐ Toggling saved place: $placeId (currently saved: $isCurrentlySaved)');
      
      if (isCurrentlySaved) {
        // Remove from local state first (optimistic)
        _savedPlaces.remove(placeId);
      } else {
        // Add to local state first (optimistic)
        _savedPlaces.add(placeId);
      }
      
      // Call toggle API
      final updatedSaved = await userRepository.toggleSavedPlace(_savedPlaces);
      print('⭐ Toggled saved place on server $updatedSaved');
      
      // Sync with server response
      _savedPlaces.assignAll(updatedSaved.savedPlaces ?? []);
      
      final isNowSaved = _savedPlaces.contains(placeId);
      print('⭐ Place ${isNowSaved ? "saved" : "unsaved"}: $placeId');
      return isNowSaved;
    } catch (e) {
      // Revert optimistic update on error - reload from server
      await loadSavedPlaces();
      print('❌ Error toggling saved place: $e');
      rethrow;
    } finally {
      _isTogglingFavorite.value = false;
    }
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
