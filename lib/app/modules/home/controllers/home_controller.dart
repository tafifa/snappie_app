import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/post_repository_impl.dart';
import '../../../core/services/auth_service.dart';

class HomeController extends GetxController {
  final AuthService authService;
  final PostRepository postRepository;
  
  HomeController({
    required this.authService,
    required this.postRepository,
  });
  
  final _posts = <PostModel>[].obs;
  final Rx<UserModel?> _userData = Rx<UserModel?>(null);
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _isInitialized = false.obs;
  final _showBanner = true.obs; // State untuk banner visibility

  List<PostModel> get posts => _posts;
  UserModel? get userData => _userData.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get showBanner => _showBanner.value;
  
  void hideBanner() => _showBanner.value = false;

  @override
  void onInit() {
    super.onInit();
    // Tidak load data di sini - akan di-trigger dari view
    print('🏠 HomeController created (not initialized yet)');
  }
  
  /// Initialize data hanya saat tab pertama kali dibuka
  void initializeIfNeeded() {
    if (!_isInitialized.value) {
      _isInitialized.value = true;
      print('🏠 HomeController initializing...');
      loadHomeData();
    }
  }

  Future<void> loadHomeData() async {
    _setLoading(true);
    _errorMessage.value = '';
    
    try {
      // Load user data from AuthService
      if (authService.isLoggedIn) {
        final userData = authService.userData;
        if (userData != null) {
          _userData.value = userData;
          print('👤 Home: User data loaded - ${userData.name}');
        }
      }
      
      // Load posts from API
      final loadedPosts = await postRepository.getPosts();
      _posts.assignAll(loadedPosts);
      
      print('🏠 Home: Loaded ${loadedPosts.length} posts');
    } catch (e) {
      _errorMessage.value = 'Failed to load posts: $e';
      print('❌ Error loading home data: $e');
    }
    
    _setLoading(false);
  }

  Future<void> refreshData() async {
    await loadHomeData();
  }

  void likePost(int postId) {
    // TODO: Implement like functionality
    Get.snackbar(
      'Liked',
      'Post liked successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void commentPost(int postId) {
    // TODO: Implement comment functionality
    Get.snackbar(
      'Comment',
      'Comment feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void sharePost(int postId) {
    // TODO: Implement share functionality
    Get.snackbar(
      'Shared',
      'Post shared successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void followUser(String username) {
    // TODO: Implement follow functionality
    Get.snackbar(
      'Followed',
      'User followed successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }
}
