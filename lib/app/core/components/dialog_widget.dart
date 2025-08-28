import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'button_widget.dart';

enum DialogType {
  info,
  success,
  warning,
  error,
  confirmation,
}

class DialogWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final DialogType type;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool barrierDismissible;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? messageColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final bool showCloseButton;
  final List<Widget>? actions;

  const DialogWidget({
    super.key,
    this.title,
    this.message,
    this.content,
    this.type = DialogType.info,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.barrierDismissible = true,
    this.icon,
    this.backgroundColor,
    this.titleColor,
    this.messageColor,
    this.titleStyle,
    this.messageStyle,
    this.padding,
    this.contentPadding,
    this.borderRadius,
    this.width,
    this.height,
    this.showCloseButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCloseButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            _buildHeader(),
            if (title != null || message != null || content != null)
              const SizedBox(height: 16),
            _buildContent(),
            if (_hasActions()) const SizedBox(height: 24),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (icon == null && title == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (icon != null) ...[
          icon!,
          if (title != null) const SizedBox(height: 16),
        ] else if (_getDefaultIcon() != null) ...[
          _getDefaultIcon()!,
          if (title != null) const SizedBox(height: 16),
        ],
        if (title != null)
          Text(
            title!,
            style: titleStyle ??
                TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? AppColors.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (content != null) {
      return Flexible(
        child: Container(
          padding: contentPadding,
          child: content!,
        ),
      );
    }

    if (message != null) {
      return Text(
        message!,
        style: messageStyle ??
            TextStyle(
              fontSize: 16,
              color: messageColor ?? AppColors.textSecondary,
              height: 1.4,
            ),
        textAlign: TextAlign.center,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActions(BuildContext context) {
    if (actions != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!,
      );
    }

    if (!_hasActions()) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (secondaryButtonText != null) ...[
          Expanded(
            child: ButtonWidget(
              text: secondaryButtonText!,
              type: ButtonType.outline,
              onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 12),
        ],
        if (primaryButtonText != null)
          Expanded(
            child: ButtonWidget(
              text: primaryButtonText!,
              type: _getPrimaryButtonType(),
              onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
      ],
    );
  }

  Widget? _getDefaultIcon() {
    IconData? iconData;
    Color? iconColor;

    switch (type) {
      case DialogType.info:
        iconData = Icons.info_outline;
        iconColor = AppColors.primary;
        break;
      case DialogType.success:
        iconData = Icons.check_circle_outline;
        iconColor = AppColors.success;
        break;
      case DialogType.warning:
        iconData = Icons.warning_amber_outlined;
        iconColor = AppColors.warning;
        break;
      case DialogType.error:
        iconData = Icons.error_outline;
        iconColor = AppColors.error;
        break;
      case DialogType.confirmation:
        iconData = Icons.help_outline;
        iconColor = AppColors.primary;
        break;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 32,
        color: iconColor,
      ),
    );
  }

  ButtonType _getPrimaryButtonType() {
    switch (type) {
      case DialogType.error:
        return ButtonType.primary;
      case DialogType.warning:
        return ButtonType.primary;
      default:
        return ButtonType.primary;
    }
  }

  bool _hasActions() {
    return primaryButtonText != null || secondaryButtonText != null;
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    Widget? content,
    DialogType type = DialogType.info,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
    Widget? icon,
    bool showCloseButton = false,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => DialogWidget(
        title: title,
        message: message,
        content: content,
        type: type,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        barrierDismissible: barrierDismissible,
        icon: icon,
        showCloseButton: showCloseButton,
        actions: actions,
      ),
    );
  }
}

// Predefined dialog methods for common scenarios
class AppDialog {
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    DialogType type = DialogType.confirmation,
  }) {
    return DialogWidget.show<bool>(
      context: context,
      title: title,
      message: message,
      type: type,
      primaryButtonText: confirmText,
      secondaryButtonText: cancelText,
      onPrimaryPressed: () => Navigator.of(context).pop(true),
      onSecondaryPressed: () => Navigator.of(context).pop(false),
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return DialogWidget.show(
      context: context,
      title: title,
      message: message,
      type: DialogType.info,
      primaryButtonText: buttonText,
    );
  }

  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return DialogWidget.show(
      context: context,
      title: title,
      message: message,
      type: DialogType.success,
      primaryButtonText: buttonText,
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return DialogWidget.show(
      context: context,
      title: title,
      message: message,
      type: DialogType.error,
      primaryButtonText: buttonText,
    );
  }

  static Future<void> showWarning({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return DialogWidget.show(
      context: context,
      title: title,
      message: message,
      type: DialogType.warning,
      primaryButtonText: buttonText,
    );
  }

  static Future<bool?> showDeleteConfirmation({
    required BuildContext context,
    String title = 'Hapus Item',
    String message = 'Apakah Anda yakin ingin menghapus item ini? Tindakan ini tidak dapat dibatalkan.',
    String confirmText = 'Hapus',
    String cancelText = 'Batal',
  }) {
    return DialogWidget.show<bool>(
      context: context,
      title: title,
      message: message,
      type: DialogType.error,
      primaryButtonText: confirmText,
      secondaryButtonText: cancelText,
      onPrimaryPressed: () => Navigator.of(context).pop(true),
      onSecondaryPressed: () => Navigator.of(context).pop(false),
    );
  }

  static Future<void> showCustom({
    required BuildContext context,
    required Widget content,
    String? title,
    bool showCloseButton = true,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return DialogWidget.show(
      context: context,
      title: title,
      content: content,
      showCloseButton: showCloseButton,
      actions: actions,
      barrierDismissible: barrierDismissible,
    );
  }
}
