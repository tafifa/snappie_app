import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'empty_state_widget.dart';

/// Predefined empty states untuk common scenarios

/// No Data Empty State
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

/// No Search Results Empty State
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

/// No Connection Empty State
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

/// Error Empty State
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

/// Under Construction Empty State
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

/// No Notifications Empty State
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

/// No Favorites Empty State
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
