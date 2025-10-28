import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../modules/explore/controllers/explore_controller.dart';

class PlaceFilterBar extends StatelessWidget {
  final ExploreController controller;

  const PlaceFilterBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          TextField(
            controller: TextEditingController(text: controller.searchQuery),
            decoration: InputDecoration(
              hintText: 'Search places...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.searchQuery = '';
                        controller.loadPlaces();
                      },
                    )
                  : const SizedBox.shrink()),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onSubmitted: (value) {
              controller.searchPlaces(value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Category filters
          Row(
            children: [
              const Text(
                'Categories:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => controller.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Category chips
          Obx(() => SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // All categories chip
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: controller.selectedCategory.isEmpty,
                    onSelected: (selected) {
                      if (selected) {
                        controller.clearFilters();
                      }
                    },
                    selectedColor: Colors.blue[100],
                    checkmarkColor: Colors.blue,
                  ),
                ),
                
                // Category chips
                ...controller.categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_formatCategoryName(category)),
                      selected: controller.selectedCategory == category,
                      onSelected: (selected) {
                        if (selected) {
                          controller.filterByCategory(category);
                        } else {
                          controller.clearFilters();
                        }
                      },
                      selectedColor: Colors.blue[100],
                      checkmarkColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          )),
          
          // Active filters indicator
          Obx(() {
            final hasFilters = controller.selectedCategory.isNotEmpty ||
                controller.searchQuery.isNotEmpty;
            
            if (!hasFilters) return const SizedBox.shrink();
            
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 16,
                    color: Colors.blue[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Filters active',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => controller.clearFilters(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Clear all',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  String _formatCategoryName(String category) {
    // Convert category name to title case
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
