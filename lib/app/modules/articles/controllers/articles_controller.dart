import 'package:get/get.dart';
import '../../../data/models/articles_model.dart';
import '../../../data/repositories/articles_repository_impl.dart';

class ArticlesController extends GetxController {
  final ArticlesRepository articlesRepository;
  
  ArticlesController({ArticlesRepository? articlesRepository})
      : articlesRepository =
            articlesRepository ?? Get.find<ArticlesRepository>();

  final _articles = <ArticlesModel>[].obs;
  final _categories = <String>[].obs;
  final _selectedCategory = ''.obs;
  final _searchQuery = ''.obs;
  final _isLoading = false.obs;
  final _isInitialized = false.obs;

  List<ArticlesModel> get articles => _articles;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    print('📰 ArticlesController created (not initialized yet)');
  }
  
  /// Initialize data hanya saat tab pertama kali dibuka
  void initializeIfNeeded() {
    if (!_isInitialized.value) {
      _isInitialized.value = true;
      print('📰 ArticlesController initializing...');
      loadArticles();
      loadCategories();
    }
  }

  Future<void> loadArticles() async {
    _setLoading(true);
    
    try {
      final articles = await articlesRepository.getArticles();
      _articles.value = articles;
      print('📰 Loaded ${articles.length} articles');
    } catch (e) {
      // Handle error silently
      print('Error loading articles: $e');
      _articles.clear();
    }
    
    _setLoading(false);
  }

  Future<void> loadCategories() async {
    try {
      // Always use API now instead of mock data
      // TODO: Load real categories from API when endpoints are ready
      _categories.clear();
      
      // For now, show empty state until API endpoints are implemented
    } catch (e) {
      // Handle error silently
      print('Error loading categories: $e');
    }
  }

  void filterByCategory(String category) {
    _selectedCategory.value = category;
    // TODO: Implement category filtering
    Get.snackbar(
      'Filter',
      'Filtered by $category',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void searchArticles(String query) {
    _searchQuery.value = query;
    // TODO: Implement search functionality
    Get.snackbar(
      'Search',
      'Searching for: $query',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearFilters() {
    _selectedCategory.value = '';
    _searchQuery.value = '';
    loadArticles();
  }

  Future<void> refreshData() async {
    await loadArticles();
  }

  void bookmarkArticle(int articleId) {
    // TODO: Implement bookmark functionality
    Get.snackbar(
      'Bookmarked',
      'Article bookmarked successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void shareArticle(int articleId) {
    // TODO: Implement share functionality
    Get.snackbar(
      'Shared',
      'Article shared successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }
}
