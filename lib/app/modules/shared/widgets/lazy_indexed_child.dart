import 'package:flutter/material.dart';

/// Widget untuk lazy load content di IndexedStack
/// Content hanya di-build saat tab pertama kali aktif
/// State tetap preserved setelah di-build
class LazyIndexedChild extends StatefulWidget {
  final Widget Function() builder;
  final bool isActive;
  
  const LazyIndexedChild({
    super.key,
    required this.builder,
    required this.isActive,
  });
  
  @override
  State<LazyIndexedChild> createState() => _LazyIndexedChildState();
}

class _LazyIndexedChildState extends State<LazyIndexedChild> 
    with AutomaticKeepAliveClientMixin {
  
  Widget? _child;
  bool _hasBuilt = false;
  
  @override
  bool get wantKeepAlive => true; // Keep state alive setelah di-build
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Build hanya saat tab pertama kali aktif
    if (widget.isActive && !_hasBuilt) {
      _child = widget.builder();
      _hasBuilt = true;
    }
    
    // Return empty widget jika belum pernah aktif
    return _child ?? const SizedBox.shrink();
  }
}
