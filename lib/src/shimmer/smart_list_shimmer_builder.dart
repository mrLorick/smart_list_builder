import 'package:flutter/material.dart';

/// A reusable shimmer list builder used by SmartList widgets
/// to display loading placeholders.
class SmartListShimmerBuilder extends StatelessWidget {
  final Widget Function(int index) shimmerItemBuilder;
  final Axis scrollDirection;
  final int itemCount;
  final EdgeInsets padding;
  final double itemSpacing;
  final ScrollPhysics? physics;

  const SmartListShimmerBuilder({
    super.key,
    required this.shimmerItemBuilder,
    this.scrollDirection = Axis.vertical,
    this.itemCount = 6,
    this.padding = const EdgeInsets.all(8),
    this.itemSpacing = 10,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ListView.builder(
        shrinkWrap: true,
        physics: physics ?? const NeverScrollableScrollPhysics(),
        scrollDirection: scrollDirection,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: scrollDirection == Axis.vertical ? itemSpacing : 0,
              right: scrollDirection == Axis.horizontal ? itemSpacing : 0,
            ),
            child: shimmerItemBuilder(index),
          );
        },
      ),
    );
  }
}
