import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/explore_controller.dart';
import '../../../data/models/place_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../shared/layout/views/scaffold_frame.dart';
import '../../shared/widgets/index.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger lazy initialization saat view pertama kali di-build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeIfNeeded();
    });

    return ScaffoldFrame(
      controller: controller,
      headerHeight: 75,
      headerContent: SearchBarWidget(
        hintText: 'Mau makan di mana hari ini?',
        enableGlassmorphism: true,
        margin: const EdgeInsets.only(top: 16),
        onChanged: (value) {
          controller.searchQuery = value;
          if (value.isNotEmpty) {
            controller.searchPlaces(value);
          }
        },
      ),
      slivers: [
        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Filter Chips
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        _buildFilterChip('Terdekat', false),
                        const SizedBox(width: 8),
                        _buildFilterChip('Tipe Tempat',
                            controller.selectedPriceRange != null),
                        const SizedBox(width: 8),
                        _buildFilterChip('Tipe Kuliner',
                            controller.selectedPriceRange != null),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                            'Penilaian', controller.selectedRating != null),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                            'Harga', controller.selectedPriceRange != null),
                        const SizedBox(width: 16),
                      ],
                    ),
                  )),

              // const SizedBox(height: 16),

              Obx(() => (!controller.isFiltered && controller.showBanner)
                  ?
                  // Promotional Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: PromotionalBanner(
                        title: 'Dapatkan lebih banyak!',
                        subtitle: 'Dapatkan hadiah dengan menyelesaikan misi!',
                        imageAsset: Image.asset('assets/logo/dark-hdpi.png'),
                        size: BannerSize.standard,
                        showCloseButton: true,
                        onClose: () => controller.hideBanner(),
                      ),
                  )
                  : const SizedBox.shrink()),

              // Conditional Content based on filter state
              Obx(() {
                print('🔍 DEBUG: isFiltered = ${controller.isFiltered}');
                print('🔍 DEBUG: searchQuery = "${controller.searchQuery}"');
                print(
                    '🔍 DEBUG: selectedCategory = "${controller.selectedCategory}"');
                print(
                    '🔍 DEBUG: selectedRating = ${controller.selectedRating}');
                print(
                    '🔍 DEBUG: selectedPriceRange = "${controller.selectedPriceRange}"');

                return controller.isFiltered
                    ? _buildFilteredContent()
                    : _buildDefaultContent();
              }),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => _onFilterChipTapped(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
              ),
            ),
            if (label == 'Penilaian' || label == 'Harga') ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onFilterChipTapped(String filter) {
    switch (filter) {
      case 'Terdekat':
        // Handle nearby filter
        _showNearbyOptions();
        break;
      case 'Penilaian':
        _showRatingDropdown();
        break;
      case 'Harga':
        _showPriceDropdown();
        break;
    }
  }

  void _showRatingDropdown() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Penilaian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              final rating = 5 - index;
              return Obx(() => ListTile(
                    leading: Radio<int>(
                      value: rating,
                      groupValue: controller.selectedRating,
                      onChanged: (value) {
                        controller.setSelectedRating(value!);
                      },
                    ),
                    title: Row(
                      children: [
                        Text('$rating'),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 16,
                        ),
                      ],
                    ),
                    onTap: () {
                      controller.setSelectedRating(rating);
                    },
                  ));
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      controller.clearRatingFilter();
                      Navigator.pop(context);
                    },
                    child: const Text('Hapus'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyRatingFilter();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                    ),
                    child: const Text('Ok'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceDropdown() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Harga (mulai dari)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => ListTile(
                  leading: Radio<String>(
                    value: 'low',
                    groupValue: controller.selectedPriceRange,
                    onChanged: (value) {
                      controller.setSelectedPriceRange(value!);
                    },
                  ),
                  title: const Text('Rp0 - Rp25.000'),
                  onTap: () {
                    controller.setSelectedPriceRange('low');
                  },
                )),
            Obx(() => ListTile(
                  leading: Radio<String>(
                    value: 'medium',
                    groupValue: controller.selectedPriceRange,
                    onChanged: (value) {
                      controller.setSelectedPriceRange(value!);
                    },
                  ),
                  title: const Text('Rp25.000 - Rp50.000'),
                  onTap: () {
                    controller.setSelectedPriceRange('medium');
                  },
                )),
            Obx(() => ListTile(
                  leading: Radio<String>(
                    value: 'high',
                    groupValue: controller.selectedPriceRange,
                    onChanged: (value) {
                      controller.setSelectedPriceRange(value!);
                    },
                  ),
                  title: const Text('> Rp50.000'),
                  onTap: () {
                    controller.setSelectedPriceRange('high');
                  },
                )),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      controller.clearPriceFilter();
                      Navigator.pop(context);
                    },
                    child: const Text('Hapus'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyPriceFilter();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                    ),
                    child: const Text('Ok'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNearbyOptions() {
    // Handle nearby filter logic
    controller.filterByNearby();
  }

  Widget _buildDefaultContent() {
    return Obx(() {
      print('🎨 BUILDING PLACES GRID:');
      print('Controller places length: ${controller.places.length}');
      print('Controller isLoading: ${controller.isLoading}');
      print('Controller places isEmpty: ${controller.places.isEmpty}');

      if (controller.isLoading && controller.places.isEmpty) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
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
        return Center(
          child: Container(
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
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Favorit Kami Section
          Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: AppColors.border,
            //   ),
            // ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Favorit kami!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => controller.setFavoritFilter(),
                        child: Text(
                          'Lihat Selengkapnya',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            
                // Places Grid
                _buildPlacesGrid(),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Terlaris Section
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Teratas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => controller.setTerlarisFilter(),
                      child: Text(
                        'Lihat Selengkapnya',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          
              // Places Grid
              _buildPlacesGrid(),
            ],
          ),
        ],
      );
    });
  }

  String _getFilteredContentTitle() {
    if (controller.selectedFilter == 'favorit') {
      return 'Favorit Kami';
    } else if (controller.selectedFilter == 'terlaris') {
      return 'Terlaris';
    } else {
      return 'Hasil Pencarian';
    }
  }

  Widget _buildFilteredContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.success,
                width: 1,
              ),
            ),
          child: Row(
            children: [
              Obx(() => Text(
                    _getFilteredContentTitle(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  )),
              const Spacer(),
              Obx(() => Text(
                    '${controller.places.length} tempat',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  )),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => controller.clearFilters(),
                icon: Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ),

        // Loading indicator while fetching filtered results
        if (controller.isLoading && controller.places.isEmpty)
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Mencari tempat...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        // Empty state when no results match filters
        else if (controller.places.isEmpty)
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada hasil',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coba ubah filter atau kata kunci pencarian',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        // Vertical scrollable list - only show when there are places
        else
          _buildFilteredPlacesList(),
      ],
    );
  }

  Widget _buildFilteredPlacesList() {
    // Show all places in vertical scrollable list
    final displayPlaces = controller.places;

    print('🎯 _buildFilteredPlacesList called');
    print('📱 displayPlaces.length: ${displayPlaces.length}');
    print('📱 controller.isLoading: ${controller.isLoading}');
    print('📱 controller.places.isEmpty: ${controller.places.isEmpty}');

    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: AppColors.accent,
      //     width: 1,
      //   ),
      // ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: displayPlaces.length,
        itemBuilder: (context, index) {
          print('🏗️ Building place card for index: $index');
          return PlaceCardWidget(
            place: displayPlaces[index],
            cardSize: CardSize.fullWidth,
            onTap: () => _onPlaceCardTapped(displayPlaces[index]),
          );
        },
      ),
    );
  }

  Widget _buildPlacesGrid() {
    // Show maximum 4 places in horizontal scrollable list
    final displayPlaces = controller.places.take(4).toList();

    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: AppColors.accent,
      //     width: 1,
      //   ),
      // ),
      height: 240, // Set height constraint for horizontal ListView
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayPlaces.length,
        itemBuilder: (context, index) {
          return PlaceCardWidget(
            place: displayPlaces[index],
            cardSize: CardSize.large,
            onTap: () => _onPlaceCardTapped(displayPlaces[index]),
          );
        },
      ),
    );
  }

  void _onPlaceCardTapped(PlaceModel place) {
    controller.selectPlace(place);
    Get.toNamed('/place-detail', arguments: place);
  }
}
