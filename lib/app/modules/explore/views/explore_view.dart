import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/explore_controller.dart';
import '../../../domain/entities/place_entity.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: CustomScrollView(
        slivers: [
          // App Bar with Search
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[400]!,
                      Colors.blue[600]!,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Mau makan di mana hari ini?',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onChanged: (value) => controller.searchQuery = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Chips
                  Obx(() => Row(
                    children: [
                      _buildFilterChip('Terdekat', controller.selectedCategory == 'nearby'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Populer', controller.selectedCategory == 'popular'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Rating', controller.selectedCategory == 'rating'),
                    ],
                  )),
                  
                  const SizedBox(height: 24),
                  
                  // Promotional Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kok tidak boleh banget!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Explore hidden bakul aman dari Jakarta dan sekitarnya yuk!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Colors.orange[600],
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Favorit Kami Section
                  Row(
                    children: [
                      const Text(
                        'Favorit kami',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Get.toNamed('/places'),
                        child: Text(
                          'Lihat Semuanya',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Places Grid
                  _buildPlacesGrid(),
                  
                  const SizedBox(height: 24),
                  
                  // Terlaris Section
                  Row(
                    children: [
                      const Text(
                        'Terlaris',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Get.toNamed('/places'),
                        child: Text(
                          'Lihat Semuanya',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // More Places Grid
                  _buildMorePlacesGrid(),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => _onFilterChipTapped(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _onFilterChipTapped(String filter) {
    switch (filter) {
      case 'Terdekat':
        controller.selectedCategory = 'nearby';
        break;
      case 'Populer':
        controller.selectedCategory = 'popular';
        break;
      case 'Rating':
        controller.selectedCategory = 'rating';
        break;
    }
    // Trigger filter action
    controller.filterByCategory(controller.selectedCategory);
  }

  Widget _buildPlacesGrid() {
    return Obx(() {
      if (controller.isLoading && controller.places.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.places.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: Text('No places found'),
          ),
        );
      }

      // Show first 2 places
      final displayPlaces = controller.places.take(2).toList();
      
      return Column(
        children: [
          Row(
            children: [
              if (displayPlaces.isNotEmpty) 
                Expanded(child: _buildPlaceCard(displayPlaces[0])),
              if (displayPlaces.length > 1) ...[
                const SizedBox(width: 12),
                Expanded(child: _buildPlaceCard(displayPlaces[1])),
              ],
            ],
          ),
        ],
      );
    });
  }

  Widget _buildMorePlacesGrid() {
    return Obx(() {
      if (controller.places.length <= 2) {
        return const SizedBox.shrink();
      }

      // Show next 2 places (index 2 and 3)
      final displayPlaces = controller.places.skip(2).take(2).toList();
      
      return Column(
        children: [
          Row(
            children: [
              if (displayPlaces.isNotEmpty) 
                Expanded(child: _buildPlaceCard(displayPlaces[0])),
              if (displayPlaces.length > 1) ...[
                const SizedBox(width: 12),
                Expanded(child: _buildPlaceCard(displayPlaces[1])),
              ],
            ],
          ),
        ],
      );
    });
  }

  Widget _buildPlaceCard(PlaceEntity place) {
    return GestureDetector(
      onTap: () => _onPlaceCardTapped(place),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  place.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.address,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.averageRating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPlaceCardTapped(PlaceEntity place) {
    controller.selectPlace(place);
    Get.toNamed('/place-detail', arguments: place);
  }
}
