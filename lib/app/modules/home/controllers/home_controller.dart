import 'package:get/get.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../core/services/auth_service.dart';

class HomeController extends GetxController {
  final AuthService authService;
  
  HomeController({required this.authService});
  
  final _posts = <PostEntity>[].obs;
  final _stories = <Map<String, dynamic>>[].obs;
  final _trending = <Map<String, dynamic>>[].obs;
  final _userData = <String, dynamic>{}.obs;
  final _isLoading = false.obs;

  List<PostEntity> get posts => _posts;
  List<Map<String, dynamic>> get stories => _stories;
  List<Map<String, dynamic>> get trending => _trending;
  Map<String, dynamic> get userData => _userData;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    _setLoading(true);
    
    try {
      // Load user data from AuthService
      if (authService.isLoggedIn) {
        final userData = authService.userData;
        if (userData != null) {
          _userData.value = userData;
          print('👤 Home: User data loaded - ${userData['name']}');
        }
      }
      
      // TODO: Load real posts, stories, trending from API when endpoints are ready
      _posts.clear();
      _stories.clear();
      _trending.clear();
      
      // For now, show empty state for posts/stories until API endpoints are implemented
      print('🏠 Home: Posts and stories will be loaded from API soon!');
    } catch (e) {
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
