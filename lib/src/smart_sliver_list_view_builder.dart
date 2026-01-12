import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controllers/smart_list_controller.dart';
import 'shimmer/smart_shimmer_box.dart';

/// A smart animated SliverList builder with:
/// - Loading (shimmer)
/// - Empty state
/// - Selection animation
/// - Tap & long-press handling
class SmartSliverListViewBuilder<T> extends StatelessWidget {
  final RxList<T> items;
  final RxBool? isLoading;

  final Widget Function(T item, bool isSelected, int index) itemBuilder;
  final Widget Function(int index)? shimmerItemBuilder;

  final String emptyMessage;

  final double shrinkScale;
  final Duration animationDuration;
  final double itemSpacing;
  final EdgeInsets padding;
  final ScrollPhysics? physics;

  final void Function(int index, T item)? onItemTap;
  final SmartListController controller;

  const SmartSliverListViewBuilder._({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.controller,
    this.isLoading,
    this.shimmerItemBuilder,
    this.emptyMessage = 'No data found.',
    this.shrinkScale = 0.96,
    this.animationDuration = const Duration(milliseconds: 150),
    this.itemSpacing = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.onItemTap,
    this.physics,
  });

  /// Factory constructor with optional controller injection
  factory SmartSliverListViewBuilder({
    Key? key,
    required RxList<T> items,
    required Widget Function(T item, bool isSelected, int index) itemBuilder,
    SmartListController? controller,
    RxBool? isLoading,
    Widget Function(int index)? shimmerItemBuilder,
    String emptyMessage = 'No data found.',
    double shrinkScale = 0.96,
    Duration animationDuration = const Duration(milliseconds: 150),
    double itemSpacing = 10,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8),
    ScrollPhysics? physics,
    void Function(int index, T item)? onItemTap,
  }) {
    final tag = key.toString();

    final SmartListController resolvedController =
        controller ?? Get.put(SmartListController(), tag: tag);

    return SmartSliverListViewBuilder._(
      key: key,
      items: items,
      itemBuilder: itemBuilder,
      controller: resolvedController,
      isLoading: isLoading,
      shimmerItemBuilder: shimmerItemBuilder,
      emptyMessage: emptyMessage,
      shrinkScale: shrinkScale,
      animationDuration: animationDuration,
      itemSpacing: itemSpacing,
      padding: padding,
      physics: physics,
      onItemTap: onItemTap,
    );
  }

  Future<void> _handleTap(int index, T item) async {
    HapticFeedback.mediumImpact();
    controller.selectItem(index);
    await Future.delayed(animationDuration);
    controller.clearSelection();
    onItemTap?.call(index, item);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// -----------------------
      /// Loading state
      /// -----------------------
      if (isLoading?.value == true) {
        return SliverPadding(
          padding: padding,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: itemSpacing),
                  child: shimmerItemBuilder != null
                      ? shimmerItemBuilder!(index)
                      : const SmartShimmerBox(
                    width: double.infinity,
                    height: 60,
                  ),
                );
              },
              childCount: 6,
            ),
          ),
        );
      }

      /// -----------------------
      /// Empty state
      /// -----------------------
      if (items.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
      }

      /// -----------------------
      /// Sliver list
      /// -----------------------
      return SliverPadding(
        padding: padding,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final item = items[index];

              return Obx(() {
                final isSelected = controller.isSelected(index);

                return GestureDetector(
                  onTap: () => _handleTap(index, item),
                  child: AnimatedScale(
                    scale: isSelected ? shrinkScale : 1.0,
                    duration: animationDuration,
                    curve: Curves.easeInOut,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: itemSpacing),
                      child: itemBuilder(item, isSelected, index),
                    ),
                  ),
                );
              });
            },
            childCount: items.length,
          ),
        ),
      );
    });
  }
}
