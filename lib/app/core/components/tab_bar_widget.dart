import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TabItem {
  final String text;
  final Widget? icon;
  final Widget? activeIcon;
  final String? tooltip;
  final bool enabled;

  const TabItem({
    required this.text,
    this.icon,
    this.activeIcon,
    this.tooltip,
    this.enabled = true,
  });
}

class TabBarWidget extends StatelessWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final double? indicatorWeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final double? height;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final bool showIndicator;
  final Decoration? indicator;

  const TabBarWidget({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.indicatorWeight,
    this.padding,
    this.margin,
    this.borderRadius,
    this.isScrollable = false,
    this.tabAlignment,
    this.height,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.showIndicator = true,
    this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius,
      ),
      child: TabBar(
        tabs: tabs.map((tab) => _buildTab(tab)).toList(),
        onTap: onTap,
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        labelColor: selectedColor ?? AppColors.primary,
        unselectedLabelColor: unselectedColor ?? AppColors.textSecondary,
        labelStyle: selectedTextStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
        unselectedLabelStyle: unselectedTextStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
        indicator: showIndicator
            ? (indicator ??
                UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: indicatorColor ?? AppColors.primary,
                    width: indicatorWeight ?? 2,
                  ),
                ))
            : null,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildTab(TabItem tab) {
    Widget tabContent;

    if (tab.icon != null) {
      tabContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tab.icon!,
          const SizedBox(height: 4),
          Text(tab.text),
        ],
      );
    } else {
      tabContent = Text(tab.text);
    }

    Widget result = Tab(
      child: tabContent,
    );

    if (tab.tooltip != null) {
      result = Tooltip(
        message: tab.tooltip!,
        child: result,
      );
    }

    return result;
  }
}

// Segmented control style tab bar
class SegmentedTabBarWidget extends StatelessWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? height;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;

  const SegmentedTabBarWidget({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBackgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.height,
    this.selectedTextStyle,
    this.unselectedTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceContainer,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: tab.enabled ? () => onTap(index) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedBackgroundColor ?? AppColors.surface)
                      : Colors.transparent,
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    tab.text,
                    style: isSelected
                        ? (selectedTextStyle ??
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selectedColor ?? AppColors.textPrimary,
                            ))
                        : (unselectedTextStyle ??
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: unselectedColor ?? AppColors.textSecondary,
                            )),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Chip style tab bar
class ChipTabBarWidget extends StatelessWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? spacing;
  final bool isScrollable;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;

  const ChipTabBarWidget({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.spacing,
    this.isScrollable = true,
    this.selectedTextStyle,
    this.unselectedTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final chipWidgets = tabs.asMap().entries.map((entry) {
      final index = entry.key;
      final tab = entry.value;
      final isSelected = index == currentIndex;

      return GestureDetector(
        onTap: tab.enabled ? () => onTap(index) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (selectedBackgroundColor ?? AppColors.primary)
                : (unselectedBackgroundColor ?? AppColors.surfaceContainer),
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(
                    color: AppColors.border.withOpacity(0.2),
                    width: 1,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tab.icon != null) ...[
                tab.icon!,
                const SizedBox(width: 6),
              ],
              Text(
                tab.text,
                style: isSelected
                    ? (selectedTextStyle ??
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: selectedColor ?? AppColors.textOnPrimary,
                        ))
                    : (unselectedTextStyle ??
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: unselectedColor ?? AppColors.textSecondary,
                        )),
              ),
            ],
          ),
        ),
      );
    }).toList();

    Widget content = Wrap(
      spacing: spacing ?? 8,
      children: chipWidgets,
    );

    if (isScrollable) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chipWidgets
              .expand((chip) => [chip, SizedBox(width: spacing ?? 8)])
              .take(chipWidgets.length * 2 - 1)
              .toList(),
        ),
      );
    }

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      color: backgroundColor,
      child: content,
    );
  }
}
