import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget for displaying shimmer loading effect
///
/// Usage:
/// ```dart
/// ShimmerLoading(
///   isLoading: true,
///   child: Container(
///     width: 100,
///     height: 20,
///     color: Colors.white,
///   ),
/// )
/// ```
class ShimmerLoading extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: child,
      );
    }
    return child;
  }
}
