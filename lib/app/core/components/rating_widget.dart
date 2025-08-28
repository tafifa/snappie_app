import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showRatingText;
  final String? ratingText;
  final TextStyle? textStyle;
  final MainAxisAlignment alignment;
  final bool allowHalfRating;

  const RatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16,
    this.activeColor,
    this.inactiveColor,
    this.showRatingText = false,
    this.ratingText,
    this.textStyle,
    this.alignment = MainAxisAlignment.start,
    this.allowHalfRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          final starRating = index + 1;
          IconData iconData;
          Color color;

          if (allowHalfRating) {
            if (rating >= starRating) {
              iconData = Icons.star;
              color = activeColor ?? AppColors.warning;
            } else if (rating >= starRating - 0.5) {
              iconData = Icons.star_half;
              color = activeColor ?? AppColors.warning;
            } else {
              iconData = Icons.star_border;
              color = inactiveColor ?? AppColors.textTertiary;
            }
          } else {
            if (rating >= starRating) {
              iconData = Icons.star;
              color = activeColor ?? AppColors.warning;
            } else {
              iconData = Icons.star_border;
              color = inactiveColor ?? AppColors.textTertiary;
            }
          }

          return Icon(
            iconData,
            size: size,
            color: color,
          );
        }),
        if (showRatingText) ...[
          const SizedBox(width: 4),
          Text(
            ratingText ?? rating.toStringAsFixed(1),
            style: textStyle ??
                TextStyle(
                  fontSize: size * 0.8,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ],
    );
  }
}
