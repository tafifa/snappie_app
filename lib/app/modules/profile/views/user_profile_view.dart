import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/repositories/user_repository_impl.dart';

/// Read-only profile view untuk user
/// Tanpa settings dan privacy features (saved posts, achievements)
class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  // Dependencies
  final _authService = Get.find<AuthService>();
  final _userRepository = Get.find<UserRepository>();

  // State variables
  bool _isLoading = true;
  String _errorMessage = '';
  
  String _userName = '';
  String _userEmail = '';
  String _userImageUrl = '';
  int _totalCheckins = 0;
  int _totalReviews = 0;
  int _totalPosts = 0;
  int _totalCoins = 0;
  int _totalExp = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Get user data from AuthService
      final userData = _authService.userData;
      if (userData == null) {
        throw Exception('User not logged in');
      }

      // Try to get fresh data from repository
      final user = await _userRepository.getUserProfile();
      
      setState(() {
        _userName = user.name ?? '';
        _userEmail = user.email ?? '';
        _userImageUrl = user.imageUrl ?? '';
        _totalCheckins = user.totalCheckin ?? 0;
        _totalReviews = user.totalReview ?? 0;
        _totalPosts = user.totalPost ?? 0;
        _totalCoins = user.totalCoin ?? 0;
        _totalExp = user.totalExp ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProfile() async {
    await _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainer,
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: CustomScrollView(
          slivers: [
            // App Bar with back button
            SliverAppBar(
              expandedHeight: 90,
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            const SizedBox(height: 16),
                            
                            // Profile Header
                            _buildProfileHeader(),
                            
                            const SizedBox(height: 16),
                            
                            // Stats Cards
                            _buildStatsCards(),
                            
                            const SizedBox(height: 16),
                            
                            // User Posts (jika ada)
                            _buildUserPosts(),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            backgroundImage: _userImageUrl.isNotEmpty
                ? NetworkImage(_userImageUrl)
                : null,
            child: _userImageUrl.isEmpty
                ? Text(
                    _userName.isNotEmpty
                        ? _userName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          
          const SizedBox(height: 16),
          
          // Name
          Text(
            _userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Email
          Text(
            _userEmail,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Level & Exp
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Level ${(_totalExp / 100).floor()}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$_totalCoins Coins',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Check-ins',
              _totalCheckins.toString(),
              Icons.location_on,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Reviews',
              _totalReviews.toString(),
              Icons.rate_review,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Posts',
              _totalPosts.toString(),
              Icons.article,
              Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPosts() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Posts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'No posts yet',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
