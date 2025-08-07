import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/review_entity.dart';
import '../controllers/explore_controller.dart';
import '../widgets/review_card.dart';
import '../widgets/review_stats_card.dart';
import '../widgets/create_review_dialog.dart';

class ReviewsView extends GetView<ExploreController> {
  const ReviewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats card
          const ReviewStatsCard(),
          
          // Reviews list
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.reviews.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessage.isNotEmpty && controller.reviews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.refreshData(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.reviews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No reviews yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to write a review!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshData(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        !controller.isLoading &&
                        controller.hasMoreData) {
                      controller.loadMoreData();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.reviews.length +
                        (controller.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.reviews.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final review = controller.reviews[index];
                      return ReviewCard(
                        review: review,
                        onTap: () => _showReviewDetail(review),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateReviewDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption('Newest First', 'created_at', 'desc'),
            _buildSortOption('Oldest First', 'created_at', 'asc'),
            _buildSortOption('Highest Rating', 'vote', 'desc'),
            _buildSortOption('Lowest Rating', 'vote', 'asc'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String field, String order) {
    return RadioListTile<String>(
      title: Text(label),
      value: '${field}_$order',
      groupValue: 'created_at_desc', // Default sort option
      onChanged: (String? value) {
        if (value != null) {
          // Handle sort selection if controller method exists
          // controller.sortReviews(field, order);
        }
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: [
                _buildFilterOption('All Status', ''),
                _buildFilterOption('Approved', 'approved'),
                _buildFilterOption('Pending', 'pending'),
                _buildFilterOption('Rejected', 'rejected'),
                _buildFilterOption('Flagged', 'flagged'),
              ],
            )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: '',
      onChanged: (String? newValue) {
        if (newValue != null) {
          if (newValue.isEmpty) {
            controller.clearFilters();
          } else {
            controller.filterByStatus(newValue);
          }
        }
      },
    );
  }

  void _showCreateReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateReviewDialog(placeId: 0),
    );
  }

  void _showReviewDetail(ReviewEntity review) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Review for ${review.place.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating
            Row(
              children: [
                const Text('Rating: '),
                ...List.generate(5, (index) {
                  return Icon(
                    index < review.vote ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
                Text(' (${review.vote}/5)'),
              ],
            ),
            const SizedBox(height: 8),
            
            // Content
            const Text(
              'Review:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(review.content),
            const SizedBox(height: 8),
            
            // Status
            Row(
              children: [
                const Text('Status: '),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(review.status as ReviewStatus),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(review.status as ReviewStatus),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Date
            Text(
              'Posted: ${_formatDate(review.createdAt)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/place-detail', arguments: review.place);
            },
            child: const Text('View Place'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReviewStatus status) {
    switch (status) {
      case ReviewStatus.approved:
        return Colors.green;
      case ReviewStatus.pending:
        return Colors.orange;
      case ReviewStatus.rejected:
        return Colors.red;
      case ReviewStatus.flagged:
        return Colors.purple;
    }
  }

  String _getStatusText(ReviewStatus status) {
    switch (status) {
      case ReviewStatus.approved:
        return 'Approved';
      case ReviewStatus.pending:
        return 'Pending';
      case ReviewStatus.rejected:
        return 'Rejected';
      case ReviewStatus.flagged:
        return 'Flagged';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}