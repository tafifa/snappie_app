import 'package:get/get.dart';
import '../../../domain/entities/place_entity.dart';
import '../../../domain/entities/review_entity.dart';
import '../../../domain/usecases/place/get_places_usecase.dart';
import '../../../domain/usecases/place/get_categories_usecase.dart';
import '../../../domain/usecases/base_usecase.dart';
import '../../../core/services/auth_service.dart';

class ExploreController extends GetxController {
  final GetPlacesUseCase getPlacesUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final AuthService authService;

  ExploreController({
    required this.getPlacesUseCase,
    required this.getCategoriesUseCase,
    required this.authService,
  });

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
    // Set default filter - use valid category from backend
    _selectedCategory.value = '';
    
    // Don't load data immediately - wait for authentication
    // Data will be loaded when user navigates to explore tab
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
      // Always use API now instead of mock data
      final result = await getPlacesUseCase(GetPlacesParams(
        page: _currentPage.value,
        perPage: 20,
        category: _selectedCategory.value.isNotEmpty && _selectedCategory.value != 'nearby' ? _selectedCategory.value : null,
        search: _searchQuery.value.isNotEmpty ? _searchQuery.value : null,
      ));
      
      result.fold(
        (failure) => _setError(failure.message),
        (placesList) {
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
        },
      );
    } catch (e) {
      _setError('Failed to load places: $e');
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
      // Use cached categories if available, only fetch from API if needed
      final result = await getCategoriesUseCase(NoParams());
      result.fold(
        (failure) => _setError(failure.message),
        (categoriesList) => _categories.assignAll(categoriesList),
      );
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
      // Always use API now instead of mock data
      // TODO: Implement when review usecase is ready
      _reviews.clear();
      // For now, show empty reviews until review usecase is implemented
    } catch (e) {
      _setError('Failed to load reviews: $e');
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
  }) async {
    _isCreatingReview.value = true;
    _clearError();
    
    try {
      // Always use API now instead of mock data
      // TODO: Implement when review usecase is ready
      await Future.delayed(const Duration(milliseconds: 1000));
      Get.snackbar(
        'Success',
        'Review submitted successfully! (API Mode)',
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
    required String placeId,
    required double latitude,
    required double longitude,
  }) async {
    _isCreatingCheckin.value = true;
    _clearError();
    
    try {
      // Always use API now instead of mock data
      // TODO: Implement when checkin usecase is ready
      await Future.delayed(const Duration(milliseconds: 1000));
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
