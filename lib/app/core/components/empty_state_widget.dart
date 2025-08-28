import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'button_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final Widget? icon;
  final String? iconPath;
  final IconData? iconData;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? customAction;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final bool showAnimation;

  const EmptyStateWidget({
    super.key,
    this.icon,
    this.iconPath,
    this.iconData,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.customAction,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.spacing,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: padding ?? const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            SizedBox(height: spacing ?? 24),
            _buildTitle(),
            if (subtitle != null) ...[
              SizedBox(height: spacing != null ? spacing! / 2 : 12),
              _buildSubtitle(),
            ],
            if (actionText != null || customAction != null) ...[
              SizedBox(height: spacing ?? 24),
              _buildAction(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    Widget iconWidget;

    if (icon != null) {
      iconWidget = icon!;
    } else if (iconPath != null) {
      iconWidget = Image.asset(
        iconPath!,
        width: iconSize ?? 120,
        height: iconSize ?? 120,
        color: iconColor ?? AppColors.textTertiary,
      );
    } else {
      iconWidget = Icon(
        iconData ?? Icons.inbox_outlined,
        size: iconSize ?? 80,
        color: iconColor ?? AppColors.textTertiary,
      );
    }

    if (showAnimation) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Opacity(
              opacity: value,
              child: iconWidget,
            ),
          );
        },
      );
    }

    return iconWidget;
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: titleStyle ??
          TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle!,
      style: subtitleStyle ??
          TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAction() {
    if (customAction != null) {
      return customAction!;
    }

    if (actionText != null && onAction != null) {
      return ButtonWidget(
        text: actionText!,
        onPressed: onAction,
        type: ButtonType.primary,
        size: ButtonSize.medium,
      );
    }

    return const SizedBox.shrink();
  }
}

// Predefined empty states for common scenarios
class NoDataEmptyState extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const NoDataEmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      iconData: Icons.inbox_outlined,
      title: title ?? 'Tidak ada data',
      subtitle: subtitle ?? 'Belum ada data yang tersedia saat ini.',
      actionText: actionText,
      onAction: onAction,
    );
  }
}

class NoSearchResultsEmptyState extends StatelessWidget {
  final String? query;
  final String? title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const NoSearchResultsEmptyState({
    super.key,
    this.query,
    this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      iconData: Icons.search_off_outlined,
      title: title ?? 'Tidak ditemukan',
      subtitle: subtitle ??
          (query != null
              ? 'Tidak ada hasil untuk "$query". Coba kata kunci lain.'
              : 'Tidak ada hasil yang ditemukan. Coba kata kunci lain.'),
      actionText: actionText,
      onAction: onAction,
    );
  }
}

class NoConnectionEmptyState extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const NoConnectionEmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      iconData: Icons.wifi_off_outlined,
      title: title ?? 'Tidak ada koneksi',
      subtitle: subtitle ?? 'Periksa koneksi internet Anda dan coba lagi.',
      actionText: actionText ?? 'Coba Lagi',
      onAction: onAction,
    );
  }
}

class ErrorEmptyState extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const ErrorEmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      iconData: Icons.error_outline,
      title: title ?? 'Terjadi kesalahan',
      subtitle: subtitle ?? 'Maaf, terjadi kesalahan. Silakan coba lagi.',
      actionText: actionText ?? 'Coba Lagi',
      onAction: onAction,
      iconColor: AppColors.error,
    );
  }
}

class UnderConstructionEmptyState extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const UnderConstructionEmptyState({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      iconData: Icons.construction_outlined,
      title: title ?? 'Sedang Dikembangkan',
      subtitle: subtitle ?? 'Fitur ini sedang dalam tahap pengembangan.',
      iconColor: AppColors.warning,
    );
  }
}

class NoNotificationsEmptyState extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const NoNotificationsEmptyState({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      iconData: Icons.notifications_none_outlined,
      title: title ?? 'Tidak ada notifikasi',
      subtitle: subtitle ?? 'Semua notifikasi akan muncul di sini.',
    );
  }
}

class NoFavoritesEmptyState extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const NoFavoritesEmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      iconData: Icons.favorite_border_outlined,
      title: title ?? 'Belum ada favorit',
      subtitle: subtitle ?? 'Item yang Anda sukai akan muncul di sini.',
      actionText: actionText,
      onAction: onAction,
    );
  }
}
