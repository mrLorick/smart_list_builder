import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_list_builder/src/shimmer/smart_list_shimmer_builder.dart';
import 'package:smart_list_builder/src/shimmer/smart_shimmer_box.dart';

import 'controllers/smart_list_controller.dart';

/// A smart animated ListView builder with:
/// - Loading (shimmer)
/// - Empty state
/// - Selection animation
/// - Tap & long-press handling
class SmartListViewBuilder<T> extends StatelessWidget {

  final List<T> items;
  final RxBool? isLoading;

  final Widget Function(T item, bool isSelected, int index) itemBuilder;
  final Widget Function(int index)? shimmerItemBuilder;

  final String emptyMessage;
  final Widget? emptyWidget;

  final double shrinkScale;
  final Duration animationDuration;
  final Axis scrollDirection;
  final EdgeInsets padding;
  final double itemSpacing;
  final ScrollPhysics? physics;

  final void Function(int index, T item)? onItemTap;
  final SmartListController? controller;

  const SmartListViewBuilder._({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.controller,
    this.isLoading,
    this.shimmerItemBuilder,
    this.emptyMessage = 'No data found.',
    this.emptyWidget,
    this.shrinkScale = 0.95,
    this.animationDuration = const Duration(milliseconds: 150),
    this.scrollDirection = Axis.vertical,
    this.padding = const EdgeInsets.all(8),
    this.itemSpacing = 10,
    this.onItemTap,
    this.physics,
  });

  /// Factory constructor with optional controller injection
  factory SmartListViewBuilder({
    Key? key,
    required List<T> items,
    required Widget Function(T item, bool isSelected, int index) itemBuilder,
    SmartListController? controller,
    RxBool? isLoading,
    Widget Function(int index)? shimmerItemBuilder,
    String emptyMessage = 'No data found.',
    Widget? emptyWidget,
    double shrinkScale = 0.95,
    Duration animationDuration = const Duration(milliseconds: 150),
    Axis scrollDirection = Axis.vertical,
    EdgeInsets padding = const EdgeInsets.all(8),
    double itemSpacing = 10,
    ScrollPhysics? physics,
    void Function(int index, T item)? onItemTap,
  }) {
    final tag = key.toString();
    final resolvedController = controller ?? Get.put(SmartListController(), tag: tag);

    return SmartListViewBuilder._(
      key: key,
      items: items,
      itemBuilder: itemBuilder,
      controller: resolvedController,
      isLoading: isLoading,
      shimmerItemBuilder: shimmerItemBuilder,
      emptyMessage: emptyMessage,
      emptyWidget: emptyWidget,
      shrinkScale: shrinkScale,
      animationDuration: animationDuration,
      scrollDirection: scrollDirection,
      padding: padding,
      itemSpacing: itemSpacing,
      physics: physics,
      onItemTap: onItemTap,
    );
  }

  Future<void> _handleTap(int index, T item) async {
    HapticFeedback.mediumImpact();
    controller?.selectItem(index);
    await Future.delayed(animationDuration);
    controller?.clearSelection();
    onItemTap?.call(index, item);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// -----------------------
      /// Loading state
      /// -----------------------
      if (isLoading?.value == true) {
        return SmartListShimmerBuilder(
          scrollDirection: scrollDirection,
          shimmerItemBuilder: shimmerItemBuilder ??
                  (_) => const SmartShimmerBox(
                width: double.infinity,
                height: 60,
              ),
        );
      }

      /// -----------------------
      /// Empty state
      /// -----------------------
      if (items.isEmpty) {
        return Center(
          child: emptyWidget ??
              Text(
                emptyMessage,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
        );
      }

      /// -----------------------
      /// ListView
      /// -----------------------
      return Padding(
        padding: padding,
        child: ListView.builder(
          shrinkWrap: true,
          physics: physics ?? const NeverScrollableScrollPhysics(),
          scrollDirection: scrollDirection,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Obx(() {
              final isSelected = controller?.isSelected(index);

              return GestureDetector(
                onTap: () => _handleTap(index, item),
                child: AnimatedScale(
                  scale: isSelected == true ? shrinkScale : 1.0,
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom:
                      scrollDirection == Axis.vertical ? itemSpacing : 0,
                      right:
                      scrollDirection == Axis.horizontal ? itemSpacing : 0,
                    ),
                    child: itemBuilder(item, isSelected ?? false, index),
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }
}
