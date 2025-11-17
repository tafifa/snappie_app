import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/explore_controller.dart';
import '../../shared/widgets/index.dart';
import '../../../data/models/place_model.dart';
import '../../../data/models/review_model.dart';
import '../../../core/constants/app_colors.dart';

class PlaceDetailView extends GetView<ExploreController> {
  const PlaceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get place from arguments if passed
    final PlaceModel? place = Get.arguments as PlaceModel?;
    
    // Load place reviews when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (place != null) {
        controller.selectPlace(place);
        controller.loadPlaceReviews(place.id!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Builder(
        builder: (context) {
          if (place == null) {
            return const Center(
              child: Text('Place not found'),
            );
          }
          
          return CustomScrollView(
            slivers: [
              // Custom App Bar with Image
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () => _showShareDialog(place),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () => _toggleFavorite(place),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Place Image
                      place.imageUrls!.isNotEmpty
                          ? Image.network(
                              place.imageUrls!.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.surfaceContainer,
                                  child: Icon(
                                    Icons.image,
                                    size: 80,
                                    color: AppColors.textTertiary,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.surfaceContainer,
                              child: Icon(
                                Icons.image,
                                size: 80,
                                color: AppColors.textTertiary,
                              ),
                            ),
                      
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.background,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Place Info Card
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and Category
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    place.name!,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    place.foodType?.isNotEmpty == true 
                                        ? place.foodType!.first 
                                        : 'Restaurant',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Rating and Reviews
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < (place.avgRating ?? 0).floor()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.warning,
                                      size: 20,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(place.avgRating ?? 0).toStringAsFixed(1)} (${place.totalReview ?? 0} reviews)',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Address
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    place.placeDetail?.address ?? 'No address available',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Partnership Info
                            if (place.partnershipStatus == true) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.successContainer,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.success,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: AppColors.success,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Partner Location',
                                          style: TextStyle(
                                            color: AppColors.success,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Check-in here to earn rewards!',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (place.expReward! > 0 || place.coinReward! > 0) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          if (place.expReward! > 0) ...[
                                            Icon(
                                              Icons.star,
                                              color: AppColors.warning,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${place.expReward} XP',
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                          if (place.expReward! > 0 && place.coinReward! > 0)
                                            const SizedBox(width: 16),
                                          if (place.coinReward! > 0) ...[
                                            Icon(
                                              Icons.monetization_on,
                                              color: AppColors.warning,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${place.coinReward} Coins',
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _showCheckinDialog(place),
                                    icon: Icon(Icons.check_circle),
                                    label: Text('Check In'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.textOnPrimary,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showDirections(place),
                                    icon: Icon(Icons.directions),
                                    label: Text('Directions'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Description
                      if (place.description != null) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowLight,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                place.description!,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Tabs
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                labelColor: AppColors.primary,
                                unselectedLabelColor: AppColors.textSecondary,
                                indicatorColor: AppColors.primary,
                                indicatorWeight: 3,
                                tabs: [
                                  Tab(text: 'Reviews'),
                                  Tab(text: 'Photos'),
                                ],
                              ),
                              SizedBox(
                                height: 400,
                                child: TabBarView(
                                  children: [
                                    // Reviews Tab
                                    _buildReviewsTab(place),
                                    
                                    // Photos Tab
                                    _buildPhotosTab(place),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 100), // Space for FAB
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      
      // Floating Action Button for Review
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateReviewDialog(),
        icon: const Icon(Icons.rate_review),
        label: const Text('Write Review'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
    );
  }

  Widget _buildReviewsTab(PlaceModel place) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(
          child: LoadingStateWidget(),
        );
      }
      
      if (controller.errorMessage.isNotEmpty) {
        return ErrorStateWidget(
          message: controller.errorMessage,
          onRetry: () => controller.loadPlaceReviews(place.id!),
        );
      }
      
      final reviews = controller.reviews;
      
      if (reviews.isEmpty) {
        return const NoDataEmptyState(
          title: 'No reviews yet',
          subtitle: 'Be the first to write a review!',
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ReviewCard(
              review: review,
              onTap: () => _showReviewDetail(review),
            ),
          );
        },
      );
    });
  }

  Widget _buildPhotosTab(PlaceModel place) {
    // Get photos from reviews
    final photos = <String>[];
    
    // Add place main image
    if (place.imageUrls != null && place.imageUrls!.isNotEmpty) {
      photos.addAll(place.imageUrls!);
    }
    
    // Add photos from reviews
    for (final review in controller.reviews) {
      if (review.imageUrls != null && review.imageUrls!.isNotEmpty) {
        photos.addAll(review.imageUrls!);
      }
    }
    
    if (photos.isEmpty) {
      return const NoDataEmptyState(
        title: 'No photos yet',
        subtitle: 'Share photos in your reviews!',
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showPhotoViewer(photos, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: NetworkImageWidget(
              imageUrl: photos[index],
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }


  void _showShareDialog(PlaceModel place) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Share Place',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Share ${place.name} with your friends!',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement share functionality
              Get.back();
              Get.snackbar(
                'Shared',
                'Place shared successfully!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.success,
                colorText: AppColors.textOnPrimary,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(PlaceModel place) {
    // Implement toggle favorite functionality
    Get.snackbar(
      'Added to Favorites',
      '${place.name} added to your favorites',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.textOnPrimary,
    );
  }

  void _showCheckinDialog(PlaceModel place) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Check In',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check in at ${place.name}?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            if (place.partnershipStatus == true) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.successContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rewards Available:',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (place.expReward! > 0)
                      Text(
                        '• ${place.expReward} XP',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    if (place.coinReward! > 0)
                      Text(
                        '• ${place.coinReward} Coins',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isCreatingCheckin
                    ? null
                    : () => _performCheckin(place),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
                child: controller.isCreatingCheckin
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Check In'),
              )),
        ],
      ),
    );
  }

  void _performCheckin(PlaceModel place) async {
    // Get current location (mock coordinates for now)
    const latitude = -6.2088;
    const longitude = 106.8456;
    
    await controller.createCheckin(
      placeId: place.id!,
      latitude: latitude,
      longitude: longitude,
    );
    
    Get.back();
  }

  void _showDirections(PlaceModel place) {
    Get.snackbar(
      'Directions',
      'Opening directions to ${place.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: AppColors.textOnPrimary,
    );
  }

  void _showCreateReviewDialog() {
    final place = controller.selectedPlace;
    if (place == null) return;
    
    final contentController = TextEditingController();
    final voteNotifier = ValueNotifier<int>(5);
    
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Write Review',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review for ${place.name}',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              
              // Rating
              Text(
                'Rating',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<int>(
                valueListenable: voteNotifier,
                builder: (context, vote, child) {
                  return Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => voteNotifier.value = index + 1,
                        child: Icon(
                          index < vote ? Icons.star : Icons.star_border,
                          color: AppColors.warning,
                          size: 32,
                        ),
                      );
                    }),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Content
              Text(
                'Review',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                maxLines: 4,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isCreatingReview
                    ? null
                    : () => _submitReview(
                          place.id.toString(),
                          voteNotifier.value,
                          contentController.text,
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
                child: controller.isCreatingReview
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit'),
              )),
        ],
      ),
    );
  }

  void _submitReview(String placeId, int vote, String content) async {
    if (content.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write a review',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.textOnPrimary,
      );
      return;
    }
    
    await controller.createReview(
      placeId: int.parse(placeId),
      vote: vote,
      content: content.trim(),
    );
    
    Get.back();
  }

  void _showReviewDetail(ReviewModel review) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Review by ${review.user?.name}',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (review.totalLike ?? 0) ? Icons.star : Icons.star_border,
                    color: AppColors.warning,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(height: 12),
              
              // Content
              Text(
                review.content ?? 'No content',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              
              // Images
              if (review.imageUrls != null && review.imageUrls!.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: review.imageUrls!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: NetworkImageWidget(
                            imageUrl: review.imageUrls![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              const SizedBox(height: 12),
              
              // Date and Status
              Row(
                children: [
                  Text(
                    _formatDate(review.createdAt!),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  if (review.status != null)
                    _buildStatusChip(review.status!),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool status) {
    final backgroundColor = status ? AppColors.successContainer : AppColors.warningContainer;
    final textColor = status ? AppColors.success : AppColors.warning;
    final text = status ? 'Approved' : 'Pending';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showPhotoViewer(List<String> photos, int initialIndex) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: photos.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                return Center(
                  child: NetworkImageWidget(
                    imageUrl: photos[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
