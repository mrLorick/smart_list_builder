# Smart List Builder

Smart List Builder is a Flutter UI package that provides animated ListView and SliverList builders with built-in loading shimmer, empty state handling, and item selection animation using GetX.

## Features
- Animated ListView builder
- Animated SliverList builder for CustomScrollView
- Built-in loading shimmer
- Empty state handling
- Item press & selection animation
- Optional controller injection
- Generic and reusable
- Null-safe and GetX powered

## Installation
Add the dependency in your pubspec.yaml:

```yaml
dependencies:
  smart_list_builder: ^1.0.0
# smart_list_builder

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Basic Usage (ListView)

SmartListViewBuilder<String>(
  items: ['Apple', 'Banana', 'Orange'],
  itemBuilder: (item, isSelected, index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(item),
    );
  },
  onItemTap: (index, item) {
    debugPrint('Tapped: $item');
  },
)


Loading State (Shimmer)

final isLoading = true.obs;
SmartListViewBuilder<String>(
  items: [],
  isLoading: isLoading,
  itemBuilder: (_, __, ___) => const SizedBox(),
)


Empty State

SmartListViewBuilder<String>(
  items: [],
  emptyMessage: 'No items available',
  itemBuilder: (_, __, ___) => const SizedBox(),
)

Sliver Usage

CustomScrollView(
  slivers: [
    SmartSliverListViewBuilder<String>(
      items: RxList(['One', 'Two', 'Three']),
      itemBuilder: (item, isSelected, index) {
        return ListTile(title: Text(item));
      },
    ),
  ],
)


Controller Injection

final controller = SmartListController();

SmartListViewBuilder<String>(
  controller: controller,
  items: ['A', 'B', 'C'],
  itemBuilder: (item, isSelected, index) {
    return Text(item);
  },
)


Public API
SmartListViewBuilder
SmartSliverListViewBuilder
SmartListController
SmartListShimmerBuilder
SmartShimmerBox

Requirements
Flutter 3.10+
Dart 3.0+
GetX ^4.6.6# smart_list_builder
