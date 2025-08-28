import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum SnackBarType {
  info,
  success,
  warning,
  error,
}

class SnackBarWidget extends StatelessWidget {
  final String message;
  final SnackBarType type;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Duration? duration;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? actionColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const SnackBarWidget({
    super.key,
    required this.message,
    this.type = SnackBarType.info,
    this.actionLabel,
    this.onActionPressed,
    this.duration,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.actionColor,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.showCloseButton = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? _getBackgroundColor(),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null || _getDefaultIcon() != null) ...[
            icon ?? _getDefaultIcon()!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: textStyle ??
                  TextStyle(
                    fontSize: 14,
                    color: textColor ?? _getTextColor(),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: onActionPressed,
              style: TextButton.styleFrom(
                foregroundColor: actionColor ?? _getActionColor(),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (showCloseButton) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.close,
                size: 18,
                color: textColor ?? _getTextColor(),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget? _getDefaultIcon() {
    IconData? iconData;
    Color? iconColor;

    switch (type) {
      case SnackBarType.info:
        iconData = Icons.info_outline;
        iconColor = AppColors.primary;
        break;
      case SnackBarType.success:
        iconData = Icons.check_circle_outline;
        iconColor = AppColors.success;
        break;
      case SnackBarType.warning:
        iconData = Icons.warning_amber_outlined;
        iconColor = AppColors.warning;
        break;
      case SnackBarType.error:
        iconData = Icons.error_outline;
        iconColor = AppColors.error;
        break;
    }

    return Icon(
      iconData,
      size: 20,
      color: iconColor,
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case SnackBarType.info:
        return AppColors.primary.withOpacity(0.1);
      case SnackBarType.success:
        return AppColors.success.withOpacity(0.1);
      case SnackBarType.warning:
        return AppColors.warning.withOpacity(0.1);
      case SnackBarType.error:
        return AppColors.error.withOpacity(0.1);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case SnackBarType.info:
        return AppColors.primary;
      case SnackBarType.success:
        return AppColors.success;
      case SnackBarType.warning:
        return AppColors.warning;
      case SnackBarType.error:
        return AppColors.error;
    }
  }

  Color _getActionColor() {
    switch (type) {
      case SnackBarType.info:
        return AppColors.primary;
      case SnackBarType.success:
        return AppColors.success;
      case SnackBarType.warning:
        return AppColors.warning;
      case SnackBarType.error:
        return AppColors.error;
    }
  }
}

// Helper class for showing snackbars
class AppSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
    Widget? icon,
    bool showCloseButton = false,
  }) {
    final snackBar = SnackBar(
      content: SnackBarWidget(
        message: message,
        type: type,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        icon: icon,
        showCloseButton: showCloseButton,
        onClose: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
      duration: duration ?? const Duration(seconds: 4),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      duration: duration,
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

// Custom SnackBar with floating behavior
class FloatingSnackBar {
  static OverlayEntry? _currentOverlay;

  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration? duration,
    Widget? icon,
    bool showCloseButton = true,
    EdgeInsetsGeometry? margin,
  }) {
    // Remove existing overlay if any
    hide();

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: SnackBarWidget(
            message: message,
            type: type,
            actionLabel: actionLabel,
            onActionPressed: onActionPressed,
            icon: icon,
            showCloseButton: showCloseButton,
            onClose: hide,
          ),
        ),
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);

    // Auto hide after duration
    Future.delayed(duration ?? const Duration(seconds: 4), () {
      hide();
    });
  }

  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
