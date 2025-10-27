import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/explore_controller.dart';
import '../widgets/review_card.dart';
import '../../../data/models/place_model.dart';
import '../../../data/models/review_model.dart';

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
      body: Obx(() {
        if (place == null) {
          return const Center(
            child: Text('Place not found'),
          );
        }
        
        return CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
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
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.grey,
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
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => _showShareDialog(place),
                  icon: const Icon(Icons.share),
                ),
                IconButton(
                  onPressed: () => _toggleFavorite(place),
                  icon: Icon(
                    // place.isFavorite ? Icons.favorite : Icons.favorite_border,
                    // color: place.isFavorite ? Colors.red : null,
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Place Info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and Category
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                place.name!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 12,
                            //     vertical: 6,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color: _getCategoryColor(place.category),
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   child: Text(
                            //     place.category ?? 'Unknown',
                            //     style: const TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Rating and Distance
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < place.avgRating!.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${place.avgRating!.toStringAsFixed(1)} (${place.totalReview!.toString()} reviews)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            // if (place.distance != null) ...[
                            //   const SizedBox(width: 16),
                            //   Icon(
                            //     Icons.location_on,
                            //     size: 16,
                            //     color: Colors.grey[600],
                            //   ),
                            //   const SizedBox(width: 4),
                            //   Text(
                            //     '${place.distance!.toStringAsFixed(1)} km',
                            //     style: TextStyle(
                            //       color: Colors.grey[600],
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            // ],
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Address
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                place.placeDetail?.address ?? 'No address available',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Partnership and Rewards Info
                        if (place.partnershipStatus!) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green[200]!,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: Colors.green[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Partner Location',
                                      style: TextStyle(
                                        color: Colors.green[700],
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
                                    color: Colors.green[600],
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
                                          color: Colors.amber[600],
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${place.expReward} XP',
                                          style: TextStyle(
                                            color: Colors.green[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                      if (place.expReward! > 0 && place.coinReward! > 0)
                                        const SizedBox(width: 16),
                                      if (place.coinReward! > 0) ...[
                                        Icon(
                                          Icons.monetization_on,
                                          color: Colors.amber[600],
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${place.coinReward} Coins',
                                          style: TextStyle(
                                            color: Colors.green[600],
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
                        
                        // Description
                        if (place.description != null) ...[
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            place.description!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
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
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Check In'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showDirections(place),
                                icon: const Icon(Icons.directions),
                                label: const Text('Directions'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Tabs
                  Container(
                    color: Colors.grey[50],
                    child: const TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: 'Reviews'),
                        Tab(text: 'Photos'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Content
            SliverFillRemaining(
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
        );
      }),
      
      // Floating Action Button for Review
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateReviewDialog(),
        icon: const Icon(Icons.rate_review),
        label: const Text('Write Review'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      ),
    );
  }

  Widget _buildReviewsTab(PlaceModel place) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      
      if (controller.errorMessage.isNotEmpty) {
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.loadPlaceReviews(place.id!),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      
      final reviews = controller.reviews;
      
      if (reviews.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No reviews yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Be the first to write a review!',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return ReviewCard(
            review: review,
            onTap: () => _showReviewDetail(review),
          );
        },
      );
    });
  }

  Widget _buildPhotosTab(PlaceModel place) {
    // Get photos from reviews
    final photos = <String>[];
    
    // Add place main image
    if (place.imageUrls != null) {
      photos.add(place.imageUrls![0]);
    }
    
    // Add photos from reviews
    // for (final review in controller.reviews) {
    //   if (review.placeId == place.id) {
    //     photos.addAll(review.imageUrls.first);
    //   }
    // }
    
    if (photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No photos yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share photos in your reviews!',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showPhotoViewer(photos, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              photos[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.grey[500],
                    size: 40,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


  void _showShareDialog(PlaceModel place) {
    Get.dialog(
      AlertDialog(
        title: const Text('Share Place'),
        content: Text('Share ${place.name} with your friends!'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement share functionality
              Get.back();
              Get.snackbar(
                'Shared',
                'Place shared successfully!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(PlaceModel place) {
    // Implement toggle favorite functionality
    // Get.snackbar(
    //   place.isFavorite ? 'Removed from Favorites' : 'Added to Favorites',
    //   place.isFavorite 
    //       ? '${place.name} removed from your favorites'
    //       : '${place.name} added to your favorites',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }

  void _showCheckinDialog(PlaceModel place) {
    Get.dialog(
      AlertDialog(
        title: const Text('Check In'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check in at ${place.name}?'),
            if (place.partnershipStatus!) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rewards Available:',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (place.expReward! > 0)
                      Text('• ${place.expReward} XP'),
                    if (place.coinReward! > 0)
                      Text('• ${place.coinReward} Coins'),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isCreatingCheckin
                    ? null
                    : () => _performCheckin(place),
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
    );
  }

  void _showCreateReviewDialog() {
    final place = controller.selectedPlace;
    if (place == null) return;
    
    final contentController = TextEditingController();
    final voteNotifier = ValueNotifier<int>(5);
    
    Get.dialog(
      AlertDialog(
        title: const Text('Write Review'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Review for ${place.name}'),
              const SizedBox(height: 16),
              
              // Rating
              const Text(
                'Rating',
                style: TextStyle(fontWeight: FontWeight.w600),
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
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Content
              const Text(
                'Review',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isCreatingReview
                    ? null
                    : () => _submitReview(
                          place.id.toString(),
                          voteNotifier.value,
                          contentController.text,
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
        title: Text('Review by ${review.user?.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.totalLike! ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(height: 12),
              
              // Content
              Text(review.content!),
              
              // Images
              if (review.imageUrls!.isNotEmpty) ...[
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
                          child: Image.network(
                            review.imageUrls![index],
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
                      color: Colors.grey[600],
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
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool status) {
    final backgroundColor = status ? Colors.green[100]! : Colors.orange[100]!;
    final textColor = status ? Colors.green[700]! : Colors.orange[700]!;
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
                  child: Image.network(
                    photos[index],
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
