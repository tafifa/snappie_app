import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snappie_app/app/modules/shared/widgets/_display_widgets/avatar_widget.dart';
import 'package:snappie_app/app/routes/app_pages.dart';
import '../../../../core/constants/app_colors.dart';

class PostCreationWidget extends StatelessWidget {
  final String? username;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final VoidCallback? onPhotoTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const PostCreationWidget({
    super.key,
    this.username,
    this.avatarUrl,
    this.onTap,
    this.onPhotoTap,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 4),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          AvatarWidget(
            imageUrl: avatarUrl,
            size: AvatarSize.small,
            onTap: () => Get.toNamed(AppPages.USER_PROFILE),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tuliskan sesuatu...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onPhotoTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
