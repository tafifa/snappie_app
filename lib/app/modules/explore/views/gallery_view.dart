import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/place_model.dart';
import '../../shared/widgets/index.dart';
import '../controllers/explore_controller.dart';

class GalleryView extends GetView<ExploreController> {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaceModel? place = Get.arguments as PlaceModel?;

    if (place == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Galeri',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
        ),
        body: const Center(
          child: Text('Data tidak ditemukan'),
        ),
      );
    }

    // Collect all photos
    final photos = <String>[];
    if (place.imageUrls != null) {
      photos.addAll(place.imageUrls!);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Galeri',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: photos.isEmpty
          ? _buildEmptyState()
          : _buildGalleryContent(context, place, photos),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada foto',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryContent(BuildContext context, PlaceModel place, List<String> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Foto ${place.name ?? "Tempat"}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return _buildPhotoTile(context, photos, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoTile(BuildContext context, List<String> photos, int index) {
    return GestureDetector(
      onTap: () {
        FullscreenImageViewer.show(
          context: context,
          imageUrls: photos,
          initialIndex: index,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: NetworkImageWidget(
          imageUrl: photos[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
