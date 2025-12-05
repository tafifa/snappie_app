import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/achievement_model.dart';
import '../../../data/repositories/achievement_repository_impl.dart';
import '../controllers/profile_controller.dart';

/// Full page view for user achievements
class AchievementsView extends StatefulWidget {
  const AchievementsView({super.key});

  @override
  State<AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<AchievementsView> {
  final AchievementRepository _repository = Get.find<AchievementRepository>();
  final ProfileController _profileController = Get.find<ProfileController>();
  
  bool _isLoading = true;
  List<UserAchievement> _achievements = [];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);
    
    try {
      final userId = _profileController.userData?.id;
      if (userId != null) {
        final result = await _repository.getUserAchievements(userId);
        setState(() {
          _achievements = result.items ?? [];
        });
      }
    } catch (e) {
      print('❌ Error loading achievements: $e');
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundContainer,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Penghargaan Saya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          _buildHeaderSection(),
          
          // Achievements list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _achievements.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _achievements.length,
                        itemBuilder: (context, index) {
                          return _buildAchievementItem(_achievements[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.purple.shade700],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Trophy icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 48,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Total Penghargaan',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '${_achievements.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Terus kumpulkan penghargaan!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada penghargaan',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selesaikan tantangan untuk mendapat penghargaan!',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(UserAchievement achievement) {
    final isUnlocked = achievement.status ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Trophy icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isUnlocked 
                  ? Colors.amber.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.emoji_events,
              color: isUnlocked ? Colors.amber : Colors.grey,
              size: 28,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Penghargaan #${achievement.achievementId}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                if (achievement.additionalInfo?.progress != null)
                  Text(
                    'Progress: ${achievement.additionalInfo!.progress}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  isUnlocked ? 'Terbuka' : 'Terkunci',
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Status
          Icon(
            isUnlocked ? Icons.check_circle : Icons.lock,
            color: isUnlocked ? Colors.green : Colors.grey,
            size: 28,
          ),
        ],
      ),
    );
  }
}
