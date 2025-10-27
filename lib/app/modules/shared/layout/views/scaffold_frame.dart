import 'package:flutter/material.dart';
import 'package:snappie_app/app/core/constants/app_colors.dart';

/// Reusable scaffold layout with SliverAppBar and CustomScrollView
///
/// For normal AppBar layouts, use DetailLayout instead.
/// This widget is specifically designed for scrollable content with SliverAppBar.
///
/// Usage Example:
/// ```dart
/// ScaffoldFrame(
///   headerContent: YourCustomHeader(),
///   slivers: [
///     SliverList(...),
///     SliverGrid(...),
///   ],
///   onRefresh: () async {
///     // Pull to refresh logic
///   },
/// )
/// ```
class ScaffoldFrame extends StatelessWidget {
  final Widget? headerContent;
  final double headerHeight;
  final List<Widget> slivers;
  final controller;
  final Widget? floatingActionButton;

  const ScaffoldFrame({
    super.key,
    this.headerContent,
    this.headerHeight = 90,
    required this.slivers,
    required this.controller,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      slivers: [
        // SliverAppBar
        if (headerContent != null) ...[
          SliverAppBar(
            expandedHeight: headerHeight,
            floating: true,
            snap: true,
            pinned: false,
            backgroundColor: AppColors.primary,
            flexibleSpace: 
                FlexibleSpaceBar(
                    background: Padding(
                      padding: EdgeInsets.fromLTRB(16, 36, 16, 8),
                      child: headerContent,
                    ),
                  )
                ,
          ),
        ],
        
        // Body slivers
        ...slivers
      ],
    );

    return Scaffold(
        backgroundColor: AppColors.surfaceContainer,
        body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: scrollView,
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }
  }
