import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/explore_controller.dart';
import '../../../domain/entities/place_entity.dart';
import '../../../core/constants/app_colors.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Initialize explore data when view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeExploreData();
    });
    
    return Scaffold(
      backgroundColor: AppColors.surfaceContainer,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 90,
            floating: true,
            snap: true,
            pinned: false,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryLight,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowLight,
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
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Mau makan di mana hari ini?',
                                    hintStyle: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onChanged: (value) => controller.searchQuery = value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      _buildFilterChip('Semua', controller.selectedCategory.isEmpty),
                      const SizedBox(width: 8),
                      _buildFilterChip('Cafe', controller.selectedCategory == 'cafe'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Restaurant', controller.selectedCategory == 'restaurant'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Traditional', controller.selectedCategory == 'traditional'),
                    ],
                  )),
                  
                  const SizedBox(height: 24),
                  
                  // Promotional Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.warningSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.warningContainer),
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
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Explore hidden bakul aman dari Jakarta dan sekitarnya yuk!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
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
                            color: AppColors.warningContainer,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.restaurant_menu,
                            color: AppColors.warning,
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
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Get.toNamed('/places'),
                        child: Text(
                          'Lihat Semuanya',
                          style: TextStyle(
                            color: AppColors.primary,
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
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Get.toNamed('/places'),
                        child: Text(
                          'Lihat Semuanya',
                          style: TextStyle(
                            color: AppColors.primary,
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
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _onFilterChipTapped(String filter) {
    switch (filter) {
      case 'Semua':
        controller.selectedCategory = '';
        break;
      case 'Cafe':
        controller.selectedCategory = 'cafe';
        break;
      case 'Restaurant':
        controller.selectedCategory = 'restaurant';
        break;
      case 'Traditional':
        controller.selectedCategory = 'traditional';
        break;
    }
    // Trigger filter action
    controller.filterByCategory(controller.selectedCategory);
  }



  Widget _buildPlacesGrid() {
    return Obx(() {
      print('🎨 BUILDING PLACES GRID:');
      print('Controller places length: ${controller.places.length}');
      print('Controller isLoading: ${controller.isLoading}');
      print('Controller places isEmpty: ${controller.places.isEmpty}');
      
      if (controller.isLoading && controller.places.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading places...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.places.isEmpty) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 24,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada tempat makan',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba refresh atau cek koneksi',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.refreshData(),
                child: Text('Refresh'),
              ),
            ],
          ),
        );
      }

      // Show maximum 4 places in horizontal scrollable list
      final displayPlaces = controller.places.take(4).toList();
      
      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: displayPlaces.length,
          itemBuilder: (context, index) {
            return Container(
              width: 160,
              margin: EdgeInsets.only(
                right: index < displayPlaces.length - 1 ? 12 : 0,
              ),
              child: _buildPlaceCard(displayPlaces[index]),
            );
          },
        ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            Flexible(
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: AppColors.surfaceVariant,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    place.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: AppColors.textTertiary,
                            size: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Content
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        place.address,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
