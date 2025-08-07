import 'package:flutter/material.dart';
import '../../../domain/entities/place_entity.dart';

class PlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onTap;
  final VoidCallback? onCheckin;

  const PlaceCard({
    Key? key,
    required this.place,
    this.onTap,
    this.onCheckin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[300],
              ),
              child: place.imageUrls.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        place.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      ),
                    )
                  : _buildPlaceholderImage(),
            ),
            
            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and category
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(place.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getCategoryDisplayName(place.category),
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
                          place.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating and distance
                  Row(
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            place.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' (${place.totalReviews})',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Distance (if available)
                      if (place.distance != null) ...[
                        Icon(
                          Icons.directions_walk,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${place.distance!.toStringAsFixed(1)} km',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  // Partnership status and rewards
                  if (place.partnershipStatus == PartnershipStatus.active) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green[200]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 16,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Earn ${place.rewardInfo.baseExp} XP + ${place.rewardInfo.baseCoin} coins',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onTap,
                          child: const Text('View Details'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onCheckin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Check-in'),
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

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: Colors.grey[500],
            ),
            const SizedBox(height: 8),
            Text(
              'No Image',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PlaceCategory _getCategoryFromString(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return PlaceCategory.restaurant;
      case 'cafe':
        return PlaceCategory.cafe;
      case 'traditional':
        return PlaceCategory.traditional;
      case 'foodcourt':
      case 'food_court':
        return PlaceCategory.foodCourt;
      case 'streetfood':
      case 'street_food':
        return PlaceCategory.streetFood;
      case 'shopping':
        return PlaceCategory.shopping;
      case 'entertainment':
        return PlaceCategory.entertainment;
      case 'tourism':
        return PlaceCategory.tourism;
      case 'education':
        return PlaceCategory.education;
      case 'healthcare':
        return PlaceCategory.healthcare;
      case 'transportation':
        return PlaceCategory.transportation;
      default:
        return PlaceCategory.other;
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return 'Restaurant';
      case 'cafe':
        return 'Cafe';
      case 'traditional':
        return 'Traditional';
      case 'foodcourt':
      case 'food_court':
        return 'Food Court';
      case 'streetfood':
      case 'street_food':
        return 'Street Food';
      case 'shopping':
        return 'Shopping';
      case 'entertainment':
        return 'Entertainment';
      case 'tourism':
        return 'Tourism';
      case 'education':
        return 'Education';
      case 'healthcare':
        return 'Healthcare';
      case 'transportation':
        return 'Transportation';
      default:
        return 'Other';
    }
  }

  Color _getCategoryColor(String category) {
    PlaceCategory categoryEnum = _getCategoryFromString(category);
    switch (categoryEnum) {
      case PlaceCategory.restaurant:
        return Colors.orange;
      case PlaceCategory.cafe:
        return Colors.brown;
      case PlaceCategory.shopping:
        return Colors.purple;
      case PlaceCategory.entertainment:
        return Colors.pink;
      case PlaceCategory.tourism:
        return Colors.green;
      case PlaceCategory.education:
        return Colors.blue;
      case PlaceCategory.healthcare:
        return Colors.red;
      case PlaceCategory.transportation:
        return Colors.indigo;
      case PlaceCategory.other:
        return Colors.grey;
      case PlaceCategory.traditional:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PlaceCategory.foodCourt:
        // TODO: Handle this case.
        throw UnimplementedError();
      case PlaceCategory.streetFood:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}