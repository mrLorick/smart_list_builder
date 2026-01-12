import 'package:get/get.dart';

/// Controller used by Smart List Builder widgets
/// to manage selected item state.
class SmartListController extends GetxController {


  /// Currently selected item index
  final RxInt selectedIndex = (-1).obs;

  /// Select an item
  void selectItem(int index) {
    selectedIndex.value = index;
  }

  /// Clear selection
  void clearSelection() {
    selectedIndex.value = -1;
  }

  /// Check if an index is selected
  bool isSelected(int index) {
    return selectedIndex.value == index;
  }
}
