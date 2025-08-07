import 'package:get/get.dart';
import '../../../domain/entities/checkin_entity.dart';
import '../../../domain/entities/place_entity.dart';

// Post entity for social media timeline
class PostEntity {
  final int id;
  final String username;
  final String userAvatar;
  final String placeName;
  final String placeAddress;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final List<String> tags;
  final bool isLiked;

  PostEntity({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.placeName,
    required this.placeAddress,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.tags,
    this.isLiked = false,
  });
}

class HomeController extends GetxController {
  
  // Reactive variables
  final _isLoading = false.obs;
  final _checkinHistory = <CheckinEntity>[].obs;
  final _nearbyPlaces = <PlaceEntity>[].obs;
  final _posts = <PostEntity>[].obs;
  final _errorMessage = ''.obs;
  final _isCreatingCheckin = false.obs;
  final _isLoadingHistory = false.obs;
  final _successMessage = ''.obs;
  final _lastCheckin = Rx<CheckinEntity?>(null);
  final _currentPage = 1.obs;
  final _hasMoreData = true.obs;
  final _selectedStatus = ''.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingHistory => _isLoadingHistory.value;
  List<CheckinEntity> get checkinHistory => _checkinHistory;
  List<PlaceEntity> get nearbyPlaces => _nearbyPlaces;
  List<PostEntity> get posts => _posts;
  String get errorMessage => _errorMessage.value;
  String get successMessage => _successMessage.value;
  bool get isCreatingCheckin => _isCreatingCheckin.value;
  CheckinEntity? get lastCheckin => _lastCheckin.value;
  int get currentPage => _currentPage.value;
  bool get hasMoreData => _hasMoreData.value;
  String get selectedStatus => _selectedStatus.value;
  
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  
  Future<void> loadInitialData() async {
    await Future.wait([
      loadCheckinHistory(),
      loadNearbyPlaces(),
      loadPosts(),
    ]);
  }
  
  Future<void> loadCheckinHistory({
    bool refresh = false,
    String? status,
  }) async {
    if (refresh) {
      _currentPage.value = 1;
      _hasMoreData.value = true;
      _checkinHistory.clear();
    }
    
    if (!_hasMoreData.value && !refresh) return;
    
    _isLoadingHistory.value = true;
    _clearError();
    
    try {
      // Mock data - replace with actual use case
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock checkin history
      final mockData = <CheckinEntity>[
        // Add mock data here if needed
      ];
      
      if (refresh || _currentPage.value == 1) {
        _checkinHistory.assignAll(mockData);
      } else {
        _checkinHistory.addAll(mockData);
      }
      
      if (mockData.isEmpty) {
        _hasMoreData.value = false;
      } else {
        _currentPage.value++;
      }
      
      if (_checkinHistory.isNotEmpty) {
        _lastCheckin.value = _checkinHistory.first;
      }
    } catch (e) {
      _setError('Failed to load check-in history');
    }
    
    _isLoadingHistory.value = false;
  }
  
  Future<void> loadNearbyPlaces() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Mock data - replace with actual use case
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock nearby places
      _nearbyPlaces.assignAll([
        // Add mock data here if needed
      ]);
    } catch (e) {
      _setError('Failed to load nearby places');
    }
    
    _setLoading(false);
  }
  
  Future<void> createCheckin({
    required String placeId,
    required double latitude,
    required double longitude,
  }) async {
    _isCreatingCheckin.value = true;
    _clearError();
    _clearSuccess();
    
    try {
      // Mock checkin creation - replace with actual use case
      await Future.delayed(const Duration(milliseconds: 1000));
      
      _setSuccess('Check-in created successfully!');
      Get.snackbar(
        'Success',
        'Check-in created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Reload checkin history
      await loadCheckinHistory(refresh: true);
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
  
  // Filter checkins by status
  void filterByStatus(String status) {
    _selectedStatus.value = status;
    loadCheckinHistory(refresh: true, status: status);
  }
  
  // Clear filters
  void clearFilters() {
    _selectedStatus.value = '';
    loadCheckinHistory(refresh: true);
  }
  
  // Load more checkins for pagination
  void loadMoreCheckins() {
    if (!_isLoadingHistory.value && _hasMoreData.value) {
      loadCheckinHistory();
    }
  }
  
  Future<void> refreshData() async {
    await loadInitialData();
  }
  
  // Get checkin statistics
  Map<String, int> getCheckinStats() {
    final total = _checkinHistory.length;
    final thisMonth = _checkinHistory.where((checkin) {
      final now = DateTime.now();
      return checkin.createdAt.month == now.month && 
             checkin.createdAt.year == now.year;
    }).length;
    
    return {
      'total': total,
      'thisMonth': thisMonth,
      'thisWeek': total > 0 ? (total * 0.3).round() : 0, // Mock calculation
    };
  }
  
  // Get total rewards
  Map<String, int> getTotalRewards() {
    final totalCheckins = _checkinHistory.length;
    return {
      'exp': totalCheckins * 10, // 10 XP per checkin
      'coin': totalCheckins * 5, // 5 coins per checkin
    };
  }
  
  // Load social media posts
  Future<void> loadPosts() async {
    _setLoading(true);
    _clearError();
    
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final mockPosts = [
        PostEntity(
          id: 1,
          username: "Marissa Ana",
          userAvatar: "https://via.placeholder.com/40",
          placeName: "Sagamatha Coffee Bar",
          placeAddress: "Jakarta Selatan",
          content: "Hidden Gems kafe yang berada di dalam gang perumahan, interiornya unik, dilengkapi dengan area sudut baca di tengah.",
          imageUrl: "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500",
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          likes: 24,
          comments: 5,
          tags: ["#hiddenGems", "#coffee", "#cozyPlace"],
        ),
        PostEntity(
          id: 2,
          username: "Budi Santoso",
          userAvatar: "https://via.placeholder.com/40",
          placeName: "Warung Gudeg Bu Endang",
          placeAddress: "Yogyakarta",
          content: "Gudeg terenak di Jogja! Bumbu meresap sempurna, nasi hangat, dan sambal krecek yang mantap. Wajib coba kalau ke Jogja!",
          imageUrl: "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500",
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
          likes: 67,
          comments: 12,
          tags: ["#gudeg", "#jogja", "#kulinerNusantara"],
        ),
        PostEntity(
          id: 3,
          username: "Sinta Dewi",
          userAvatar: "https://via.placeholder.com/40",
          placeName: "Pantai Kuta Bali",
          placeAddress: "Bali",
          content: "Sunset di Pantai Kuta hari ini luar biasa! Warna langitnya seperti lukisan. Perfect spot untuk healing dan foto-foto.",
          imageUrl: "https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=500",
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
          likes: 142,
          comments: 23,
          tags: ["#sunset", "#bali", "#beach"],
        ),
        PostEntity(
          id: 4,
          username: "Andi Prasetyo",
          userAvatar: "https://via.placeholder.com/40",
          placeName: "Museum Nasional",
          placeAddress: "Jakarta Pusat",
          content: "Exploring sejarah Indonesia di Museum Nasional. Koleksi artifaknya lengkap banget, dari masa prasejarah sampai modern. Educational trip yang menarik!",
          imageUrl: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500",
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          likes: 89,
          comments: 15,
          tags: ["#museum", "#sejarah", "#educational"],
        ),
      ];
      
      _posts.assignAll(mockPosts);
    } catch (e) {
      _setError('Failed to load posts');
    }
    
    _setLoading(false);
  }
  
  // Toggle like on a post
  void toggleLike(int postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedPost = PostEntity(
        id: post.id,
        username: post.username,
        userAvatar: post.userAvatar,
        placeName: post.placeName,
        placeAddress: post.placeAddress,
        content: post.content,
        imageUrl: post.imageUrl,
        createdAt: post.createdAt,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        comments: post.comments,
        tags: post.tags,
        isLiked: !post.isLiked,
      );
      _posts[postIndex] = updatedPost;
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }
  
  void _setError(String error) {
    _errorMessage.value = error;
  }
  
  void _setSuccess(String message) {
    _successMessage.value = message;
  }
  
  void _clearError() {
    _errorMessage.value = '';
  }
  
  void _clearSuccess() {
    _successMessage.value = '';
  }
}
