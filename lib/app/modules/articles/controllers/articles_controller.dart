import 'package:get/get.dart';
import '../../../domain/entities/articles_entity.dart';

class ArticlesController extends GetxController {
  // Reactive variables
  final _isLoading = false.obs;
  final _articles = <ArticlesEntity>[].obs;
  final _filteredArticles = <ArticlesEntity>[].obs;
  final _searchQuery = ''.obs;
  final _selectedCategory = ''.obs;
  final _errorMessage = ''.obs;
  final _currentPage = 1.obs;
  final _hasMoreData = true.obs;
  final _isLoadingMore = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  List<ArticlesEntity> get articles => _filteredArticles;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  String get errorMessage => _errorMessage.value;
  int get currentPage => _currentPage.value;
  bool get hasMoreData => _hasMoreData.value;

  // Categories
  final categories = [
    'Semua',
    'Destinasi',
    'Kuliner',
    'Budaya',
    'Tips Travel',
    'Petualangan'
  ];

  @override
  void onInit() {
    super.onInit();
    loadArticles();
  }

  Future<void> loadArticles({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _hasMoreData.value = true;
      _articles.clear();
    }

    if (!_hasMoreData.value && !refresh) return;

    _setLoading(true);
    _clearError();

    try {
      // Simulate API call to load articles
      await Future.delayed(const Duration(milliseconds: 800));

      final mockArticles = _generateMockArticles();

      if (refresh || _currentPage.value == 1) {
        _articles.assignAll(mockArticles);
      } else {
        _articles.addAll(mockArticles);
      }

      if (mockArticles.length < 10) {
        _hasMoreData.value = false;
      } else {
        _currentPage.value++;
      }

      _applyFilters();
    } catch (e) {
      _setError('Failed to load articles');
    }

    _setLoading(false);
  }

  void searchArticles(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory.value = category == 'Semua' ? '' : category;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = _articles.toList();

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((article) =>
          article.title.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
          article.content.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
          article.author.toLowerCase().contains(_searchQuery.value.toLowerCase())).toList();
    }

    // Apply category filter
    if (_selectedCategory.value.isNotEmpty) {
      filtered = filtered.where((article) =>
          article.category == _selectedCategory.value).toList();
    }

    _filteredArticles.assignAll(filtered);
  }

  Future<void> loadMoreArticles() async {
    if (!_isLoadingMore.value && _hasMoreData.value) {
      _isLoadingMore.value = true;
      await loadArticles();
      _isLoadingMore.value = false;
    }
  }

  Future<void> refreshArticles() async {
    await loadArticles(refresh: true);
  }

  void toggleBookmark(ArticlesEntity article) {
    final index = _articles.indexWhere((a) => a.id == article.id);
    if (index != -1) {
      _articles[index] = article.copyWith(isBookmarked: !article.isBookmarked);
      _applyFilters();
    }
  }

  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String error) {
    _errorMessage.value = error;
  }

  void _clearError() {
    _errorMessage.value = '';
  }

  List<ArticlesEntity> _generateMockArticles() {
    return [
      ArticlesEntity(
        id: 1,
        title: "Spot Hidden Gems di Pontianak",
        content: "Pontianak menyimpan banyak tempat tersembunyi yang menawan. Dari kafe-kafe unik di sudut kota hingga taman tersembunyi yang jarang dikunjungi wisatawan. Salah satu tempat yang wajib dikunjungi adalah Taman Alun Kapuas yang menawarkan pemandangan sungai yang memukau, terutama saat matahari terbenam.\n\nSelain itu, ada juga Kampung Beting yang merupakan perkampungan terapung di atas Sungai Kapuas. Di sini, Anda bisa merasakan kehidupan masyarakat lokal yang masih sangat tradisional. Jangan lupa untuk mencicipi kuliner khas seperti Bubur Pedas dan Choi Pan yang bisa ditemukan di warung-warung pinggir jalan.\n\nUntuk pengalaman yang lebih berkesan, cobalah menyusuri Sungai Kapuas dengan perahu tradisional sambil menikmati pemandangan rumah-rumah panggung yang berjejer di sepanjang sungai.",
        excerpt: "Temukan tempat-tempat tersembunyi yang menawan di Pontianak",
        imageUrl: "https://via.placeholder.com/300x200",
        author: "Susur Galur",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: "Destinasi",
        tags: ["pontianak", "hidden gems", "wisata"],
        views: 1250,
        likes: 89,
      ),
      ArticlesEntity(
        id: 2,
        title: "Kuliner Khas Kalimantan Barat",
        content: "Jelajahi cita rasa autentik Kalimantan Barat...",
        excerpt: "Nikmati kelezatan kuliner khas Kalimantan Barat",
        imageUrl: "https://via.placeholder.com/300x200",
        author: "Food Explorer",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        category: "Kuliner",
        tags: ["kuliner", "kalimantan", "makanan"],
        views: 980,
        likes: 67,
      ),
      ArticlesEntity(
        id: 3,
        title: "Budaya Dayak yang Memukau",
        content: "Mengenal lebih dekat budaya Dayak yang kaya...",
        excerpt: "Eksplorasi budaya Dayak yang penuh makna",
        imageUrl: "https://via.placeholder.com/300x200",
        author: "Culture Hunter",
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        category: "Budaya",
        tags: ["dayak", "budaya", "tradisi"],
        views: 756,
        likes: 45,
      ),
      ArticlesEntity(
        id: 4,
        title: "Tips Traveling Hemat di Kalimantan",
        content: "Panduan lengkap traveling hemat namun berkesan...",
        excerpt: "Traveling hemat tapi tetap berkesan di Kalimantan",
        imageUrl: "https://via.placeholder.com/300x200",
        author: "Budget Traveler",
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        category: "Tips Travel",
        tags: ["tips", "hemat", "traveling"],
        views: 1100,
        likes: 78,
      ),
      ArticlesEntity(
        id: 5,
        title: "Petualangan Sungai Kapuas",
        content: "Menyusuri sungai terpanjang di Indonesia...",
        excerpt: "Petualangan seru menyusuri Sungai Kapuas",
        imageUrl: "https://via.placeholder.com/300x200",
        author: "Adventure Seeker",
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        category: "Petualangan",
        tags: ["sungai", "kapuas", "petualangan"],
        views: 890,
        likes: 56,
      ),
    ];
  }
}