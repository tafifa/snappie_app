import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppHeaderWidget extends StatelessWidget {
  final String greeting;
  final String subtitle;
  final Widget? avatar;
  final Widget? actionButton;
  final List<Color>? gradientColors;
  final EdgeInsetsGeometry? padding;
  final double? expandedHeight;
  final bool floating;
  final bool snap;
  final bool pinned;

  const AppHeaderWidget({
    super.key,
    required this.greeting,
    required this.subtitle,
    this.avatar,
    this.actionButton,
    this.gradientColors,
    this.padding,
    this.expandedHeight,
    this.floating = true,
    this.snap = true,
    this.pinned = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight ?? 90,
      floating: floating,
      snap: snap,
      pinned: pinned,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors ?? [
                AppColors.primaryLight,
                AppColors.primaryDark,
              ],
            ),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    if (avatar != null) ...[
                      avatar!,
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: AppColors.textOnPrimary.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (actionButton != null) actionButton!,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
