import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../modules/explore/controllers/explore_controller.dart';

class ReviewStatsCard extends StatelessWidget {
  const ReviewStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreController>();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[400]!,
              Colors.blue[600]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.rate_review,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Review Statistics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() => controller.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : IconButton(
                          onPressed: () => controller.refreshData(),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Stats Grid
              Obx(() {
                final stats = controller.getReviewStats();
                
                return Column(
                  children: [
                    // First Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Total Reviews',
                            stats['total']?.toString() ?? '0',
                            Icons.reviews,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            'Approved',
                            stats['approved']?.toString() ?? '0',
                            Icons.check_circle,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Second Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Pending',
                            stats['pending']?.toString() ?? '0',
                            Icons.schedule,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            'Rejected',
                            stats['rejected']?.toString() ?? '0',
                            Icons.cancel,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Third Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Flagged',
                            stats['flagged']?.toString() ?? '0',
                            Icons.flag,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatItem(
                            'Avg Rating',
                            stats['averageRating']?.toStringAsFixed(1) ?? '0.0',
                            Icons.star,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              
              const SizedBox(height: 20),
              
              // User Stats Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Reviews',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final userStats = controller.getReviewStats();
                      
                      return Row(
                        children: [
                          Expanded(
                            child: _buildUserStatItem(
                              'Total',
                              userStats['total']?.toString() ?? '0',
                            ),
                          ),
                          Expanded(
                            child: _buildUserStatItem(
                              'Approved',
                              userStats['approved']?.toString() ?? '0',
                            ),
                          ),
                          Expanded(
                            child: _buildUserStatItem(
                              'Avg Rating',
                              userStats['averageRating']?.toStringAsFixed(1) ?? '0.0',
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
