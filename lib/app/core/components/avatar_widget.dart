import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AvatarSize {
  small,
  medium,
  large,
  extraLarge,
}

enum AvatarType {
  circle,
  rounded,
  square,
}

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AvatarSize size;
  final AvatarType type;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final Widget? badge;
  final bool showOnlineStatus;
  final bool isOnline;
  final Color? onlineColor;
  final Color? offlineColor;
  final Widget? placeholder;
  final BoxFit? fit;
  final String? heroTag;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.medium,
    this.type = AvatarType.circle,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.badge,
    this.showOnlineStatus = false,
    this.isOnline = false,
    this.onlineColor,
    this.offlineColor,
    this.placeholder,
    this.fit,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = _getSize();
    final borderRadius = _getBorderRadius();
    
    Widget avatar = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? _getDefaultBackgroundColor(),
        borderRadius: borderRadius,
        border: borderWidth != null && borderWidth! > 0
            ? Border.all(
                color: borderColor ?? AppColors.border.withOpacity(0.2),
                width: borderWidth!,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: _buildContent(),
      ),
    );

    if (heroTag != null) {
      avatar = Hero(
        tag: heroTag!,
        child: avatar,
      );
    }

    Widget result = Stack(
      children: [
        avatar,
        if (badge != null)
          Positioned(
            top: 0,
            right: 0,
            child: badge!,
          ),
        if (showOnlineStatus)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: _getOnlineStatusSize(),
              height: _getOnlineStatusSize(),
              decoration: BoxDecoration(
                color: isOnline
                    ? (onlineColor ?? AppColors.success)
                    : (offlineColor ?? AppColors.textTertiary),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );

    if (onTap != null) {
      result = GestureDetector(
        onTap: onTap,
        child: result,
      );
    }

    return result;
  }

  Widget _buildContent() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: fit ?? BoxFit.cover,
        width: _getSize(),
        height: _getSize(),
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder();
        },
      );
    }
    
    return _buildFallback();
  }

  Widget _buildFallback() {
    if (placeholder != null) {
      return placeholder!;
    }

    if (name != null && name!.isNotEmpty) {
      return Center(
        child: Text(
          _getInitials(name!),
          style: TextStyle(
            color: textColor ?? AppColors.textOnPrimary,
            fontSize: _getFontSize(),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Icon(
      Icons.person,
      size: _getIconSize(),
      color: textColor ?? AppColors.textSecondary,
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: _getSize(),
      height: _getSize(),
      color: AppColors.surfaceContainer,
      child: Center(
        child: SizedBox(
          width: _getSize() * 0.3,
          height: _getSize() * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '?';
  }

  double _getSize() {
    switch (size) {
      case AvatarSize.small:
        return 32;
      case AvatarSize.medium:
        return 40;
      case AvatarSize.large:
        return 56;
      case AvatarSize.extraLarge:
        return 80;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AvatarSize.small:
        return 12;
      case AvatarSize.medium:
        return 14;
      case AvatarSize.large:
        return 20;
      case AvatarSize.extraLarge:
        return 28;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AvatarSize.small:
        return 16;
      case AvatarSize.medium:
        return 20;
      case AvatarSize.large:
        return 28;
      case AvatarSize.extraLarge:
        return 40;
    }
  }

  double _getOnlineStatusSize() {
    switch (size) {
      case AvatarSize.small:
        return 8;
      case AvatarSize.medium:
        return 10;
      case AvatarSize.large:
        return 14;
      case AvatarSize.extraLarge:
        return 18;
    }
  }

  BorderRadius? _getBorderRadius() {
    switch (type) {
      case AvatarType.circle:
        return BorderRadius.circular(_getSize() / 2);
      case AvatarType.rounded:
        return BorderRadius.circular(8);
      case AvatarType.square:
        return BorderRadius.zero;
    }
  }

  Color _getDefaultBackgroundColor() {
    if (name != null && name!.isNotEmpty) {
      // Generate a color based on the name
      final hash = name!.hashCode;
      final colors = [
        AppColors.primary,
        AppColors.primaryLight,
        Colors.orange,
        Colors.green,
        Colors.purple,
        Colors.teal,
        Colors.indigo,
        Colors.pink,
      ];
      return colors[hash.abs() % colors.length];
    }
    return AppColors.surfaceContainer;
  }
}

// Badge widget for avatar
class AvatarBadge extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;

  const AvatarBadge({
    super.key,
    this.text,
    this.child,
    this.backgroundColor,
    this.textColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final badgeSize = size ?? 20;
    
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.error,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.surface,
          width: 2,
        ),
      ),
      child: child ??
          (text != null
              ? Center(
                  child: Text(
                    text!,
                    style: TextStyle(
                      color: textColor ?? AppColors.textOnPrimary,
                      fontSize: badgeSize * 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null),
    );
  }
}
