import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/place_model.dart';
import '../controllers/explore_controller.dart';
import '../widgets/place_card.dart';
import '../widgets/place_filter_bar.dart';

class PlacesView extends GetView<ExploreController> {
  const PlacesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Places'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          PlaceFilterBar(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.places.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessage.isNotEmpty && controller.places.isEmpty) {
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

              if (controller.places.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No places found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search or filters',
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
                      controller.loadMorePlaces();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.places.length +
                        (controller.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.places.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final place = controller.places[index];
                      return PlaceCard(
                        place: place,
                        onTap: () => _navigateToPlaceDetail(place),
                        onCheckin: () => _showCheckinDialog(place),
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
        onPressed: () => _showNearbyPlaces(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.near_me, color: Colors.white),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Places'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Enter place name or address...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.searchPlaces(searchController.text);
              Get.back();
            },
            child: const Text('Search'),
          ),
        ],
      ),
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
              'Filter by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: controller.selectedCategory.isEmpty,
                  onSelected: (selected) {
                    if (selected) {
                      controller.clearFilters();
                    }
                  },
                ),
                ...controller.categories.map(
                  (category) => FilterChip(
                    label: Text(category),
                    selected: controller.selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        controller.filterByCategory(category);
                      }
                    },
                  ),
                ),
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

  void _showNearbyPlaces(BuildContext context) {
    // This would typically get current location first
    // For now, using dummy coordinates
    controller.loadNearbyPlaces(
      latitude: -6.2088,
      longitude: 106.8456,
    );
    
    Get.snackbar(
      'Nearby Places',
      'Loading places near your location...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _navigateToPlaceDetail(PlaceModel place) {
    Get.toNamed('/place-detail', arguments: place);
  }

  void _showCheckinDialog(PlaceModel place) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Check-in to ${place.name ?? "this place"}'),
        content: const Text('Are you sure you want to check-in to this place?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // This would typically get current location
              // For now, using place coordinates
              controller.createCheckin(
                placeId: place.id ?? 0,
                latitude: place.latitude ?? 0.0,
                longitude: place.longitude ?? 0.0,
              );
              Get.back();
            },
            child: const Text('Check-in'),
          ),
        ],
      ),
    );
  }
}
