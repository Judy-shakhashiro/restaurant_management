import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/controller/dish_details_controller.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../model/category.dart';
import '../model/favorite_model.dart';
import '../model/menu_item.dart';
import '../services/api_service.dart';
import '../services/category_service.dart';

class MyMenuController extends GetxController {
  // Observables for UI
  final categories = <CategoryMenu>[].obs;
  final menuItems = <MenuItem>[].obs; // The flattened list of menu items (headers, dishes, loading)
  final selectedCat = CategoryMenu().obs; // For the highlighted category in the horizontal list
  final selectedTagIds = <int>[].obs;// For active tags
  final tags = <Tag>[].obs;

  // Controllers for ScrollablePositionedList
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  // Internal state flags
  final RxBool _isLoadingCategoryDishes = false.obs; // Prevents concurrent dish fetching
  final RxInt _nextSequentialCategoryIndex = 0.obs; // Tracks the next category to load during sequential scrolling
  final RxBool _isProgrammaticScrolling = false.obs; // Prevents _onScroll from triggering during jump-to

  // A map to track which categories have had their dishes loaded
  final _loadedCategoryIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  // --- Initial Data Loading (Categories, Tags, ALL Placeholders, FIRST Category Dishes) ---
  Future<void> _loadInitialData() async {

    _isProgrammaticScrolling.value = true;

    categories.value = await CategoryService().fetchCategories();
    tags.value = await ApiService().fetchTags();
    print('Initial data loaded: ${categories.length} categories, ${tags.length} tags.');

    _populateAllCategoryPlaceholders();

    if (categories.isNotEmpty) {
      selectedCat.value = categories.first;
      await _loadDishesForCategory(categories.first);
      _nextSequentialCategoryIndex.value = 1;
    }

    // NEW: Check for empty menu state after initial load
    _handleEmptyMenuState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemPositionsListener.itemPositions.addListener(_onScroll);
      print('Added _onScroll listener after initial data load (post-frame callback).');
      _isProgrammaticScrolling.value = false;
    });


  }

  void _populateAllCategoryPlaceholders() async{

    menuItems.clear();
    _loadedCategoryIds.clear();


    for (var category in categories) {
      menuItems.add(CategoryHeaderItem(title: category.name, categoryId: category.id));
      for (var i = 0; i < category.productsCount; i++) {
        menuItems.add(LoadingItem());
      }
    }
    print('All category headers and dish placeholders added. Total items: ${menuItems.length}');
  }

  // --- Core Logic for Fetching Dishes for a Specific Category ---
  Future<void> _loadDishesForCategory(CategoryMenu categoryToLoad) async {
    if (_isLoadingCategoryDishes.value) {
      print('Already loading dishes. Skipping request for ${categoryToLoad.name}.');
      return;
    }
    if (_loadedCategoryIds.contains(categoryToLoad.id)) {
      print('Dishes for ${categoryToLoad.name} already loaded. Skipping.');
      return;
    }
    _isLoadingCategoryDishes.value = true;
    print('Starting to load dishes for category: ${categoryToLoad.name} (ID: ${categoryToLoad.id})');

    try {
      final dishes = await ApiService().fetchDishesByCategory(categoryToLoad.id, selectedTagIds);
      print('API returned ${dishes.length} dishes for ${categoryToLoad.name}.');

      int categoryHeaderIndexInMenuItems = -1;
      for (int i = 0; i < menuItems.length; i++) {
        if (menuItems[i] is CategoryHeaderItem && (menuItems[i] as CategoryHeaderItem).categoryId == categoryToLoad.id) {
          categoryHeaderIndexInMenuItems = i;
          break;
        }
      }

      if (categoryHeaderIndexInMenuItems != -1) {
        final int startIndexToReplace = categoryHeaderIndexInMenuItems + 1;
        final int originalPlaceholderCount = categoryToLoad.productsCount;

        // NEW LOGIC: If no dishes are returned for this category with selected tags, remove its header and placeholders.
        if (dishes.isEmpty) {
          print('Category ${categoryToLoad.name} has no dishes for selected tags. Removing header and placeholders.');
          int itemsToRemoveFromThisBlock = 0;
          for (int i = categoryHeaderIndexInMenuItems; i < menuItems.length; i++) {
            if (menuItems[i] is CategoryHeaderItem && (menuItems[i] as CategoryHeaderItem).categoryId == categoryToLoad.id) {
              itemsToRemoveFromThisBlock++;
            } else if (menuItems[i] is LoadingItem) {
              itemsToRemoveFromThisBlock++;
            } else if (menuItems[i] is CategoryHeaderItem) {
              break;
            }
          }

          for (int i = 0; i < itemsToRemoveFromThisBlock; i++) {
            menuItems.removeAt(categoryHeaderIndexInMenuItems);
          }
          _loadedCategoryIds.add(categoryToLoad.id);
          print('Category ${categoryToLoad.name} and its items removed. menuItems length now: ${menuItems.length}');

          // Check for empty menu state after removing a category that had no dishes
          // This ensures that if the removal makes the entire menu empty, the message appears.
          _handleEmptyMenuState();
          return;
        }

        // Existing logic: Remove placeholders and insert actual dishes (only if dishes is NOT empty)
        int actualRemovedCount = 0;
        if (startIndexToReplace < menuItems.length) {
          for (int i = startIndexToReplace; i < menuItems.length && actualRemovedCount < originalPlaceholderCount; i++) {
            if (menuItems[i] is LoadingItem) {
              menuItems.removeAt(i);
              actualRemovedCount++;
              i--;
            } else if (menuItems[i] is CategoryHeaderItem && (menuItems[i] as CategoryHeaderItem).categoryId != categoryToLoad.id) {
              print('Reached next category header prematurely, stopping placeholder removal for ${categoryToLoad.name}');
              break;
            }
          }
        }
        print('  Actually removed $actualRemovedCount LoadingItems for ${categoryToLoad.name}.');

        menuItems.insertAll(startIndexToReplace, dishes.map((d) => DishItem(dish: d, categoryId: categoryToLoad.id)));
        _loadedCategoryIds.add(categoryToLoad.id);
        print('Dishes inserted for ${categoryToLoad.name}. menuItems length now: ${menuItems.length}');

      } else {
        print('ERROR: Category header for ${categoryToLoad.name} not found in menuItems for dish insertion.');
      }
    } catch (error) {
      print('ERROR fetching dishes for category ${categoryToLoad.name}: $error');
    } finally {
      _isLoadingCategoryDishes.value = false;
    }
  }

  // NEW: Helper to display a message if no items are left
  void _handleEmptyMenuState() {
    // If the list is empty (after potential category removals)
    // AND it doesn't already contain our no-items message
    if (menuItems.isEmpty) {
      print('Menu items list is empty after processing. Displaying "No items found" message.');
      menuItems.add(NoItemsFoundItem());
    } else {
      // If it's not empty, ensure no previous NoItemsFoundItem is lingering
      menuItems.removeWhere((item) => item is NoItemsFoundItem);
    }
  }

  // --- Helper to Update selectedCat based on Scroll Position ---
  void _updateSelectedCategoryFromScroll() {
    if (itemPositionsListener.itemPositions.value.isEmpty) {
      return;
    }

    final firstVisibleCategoryHeaderPosition = itemPositionsListener.itemPositions.value.firstWhereOrNull(
          (position) =>
      position.itemLeadingEdge >= 0 &&
          position.itemLeadingEdge < 0.2 &&
          position.index < menuItems.length &&
          menuItems[position.index] is CategoryHeaderItem,
    );

    if (firstVisibleCategoryHeaderPosition != null) {
      final CategoryHeaderItem currentHeader = menuItems[firstVisibleCategoryHeaderPosition.index] as CategoryHeaderItem;
      final CategoryMenu? currentCategory = categories.firstWhereOrNull((cat) => cat.id == currentHeader.categoryId);

      if (currentCategory != null && selectedCat.value != currentCategory) {
        selectedCat.value = currentCategory;
        print('Selected category updated to: ${currentCategory.name}');
      }
    } else {
      ItemPosition? highestVisibleCategoryHeaderPosition;

      for (final position in itemPositionsListener.itemPositions.value) {
        if (position.index < menuItems.length &&
            menuItems[position.index] is CategoryHeaderItem &&
            position.itemTrailingEdge > 0)
        {
          if (highestVisibleCategoryHeaderPosition == null || position.index < highestVisibleCategoryHeaderPosition.index) {
            highestVisibleCategoryHeaderPosition = position;
          }
        }
      }

      if (highestVisibleCategoryHeaderPosition != null) {
        final CategoryHeaderItem currentHeader = menuItems[highestVisibleCategoryHeaderPosition.index] as CategoryHeaderItem;
        final CategoryMenu? currentCategory = categories.firstWhereOrNull((cat) => cat.id == currentHeader.categoryId);
        if (currentCategory != null && selectedCat.value != currentCategory) {
          selectedCat.value = currentCategory;
          print('Selected category updated to: ${currentCategory.name} (fallback from highest visible header)');
        }
      }
    }
  }


  // --- Hybrid Scrolling Logic (`_onScroll`) ---
  void _onScroll() {
    if (_isProgrammaticScrolling.value || _isLoadingCategoryDishes.value) {
      return;
    }

    if (itemPositionsListener.itemPositions.value.isEmpty) {
      return;
    }

    _updateSelectedCategoryFromScroll();

    final Iterable<ItemPosition> visiblePositions = itemPositionsListener.itemPositions.value
        .where((position) => position.itemTrailingEdge > 0 && position.itemLeadingEdge < 1);

    CategoryMenu? categoryToFetchByVisibility;

    for (final position in visiblePositions) {
      if (position.index < menuItems.length) {
        final item = menuItems[position.index];
        CategoryMenu? identifiedCategory;

        if (item is CategoryHeaderItem) {
          identifiedCategory = categories.firstWhereOrNull((cat) => cat.id == item.categoryId);
        } else if (item is LoadingItem) {
          for (int i = position.index - 1; i >= 0; i--) {
            if (menuItems[i] is CategoryHeaderItem) {
              final precedingHeader = menuItems[i] as CategoryHeaderItem;
              identifiedCategory = categories.firstWhereOrNull((cat) => cat.id == precedingHeader.categoryId);
              break;
            }
          }
        }

        if (identifiedCategory != null && !_loadedCategoryIds.contains(identifiedCategory.id)) {
          categoryToFetchByVisibility = identifiedCategory;
          break;
        }
      }
    }

    if (categoryToFetchByVisibility != null) {
      print('User visible unfetched content for category: ${categoryToFetchByVisibility.name} (ID: ${categoryToFetchByVisibility.id}). Triggering load...');
      _loadDishesForCategory(categoryToFetchByVisibility).then((_) {
        int categoryMasterIndex = categories.indexOf(categoryToFetchByVisibility!);
        if (categoryMasterIndex != -1 && categoryMasterIndex == _nextSequentialCategoryIndex.value) {
          _nextSequentialCategoryIndex.value++;
          print('Advanced _nextSequentialCategoryIndex to ${_nextSequentialCategoryIndex.value} (category: ${categories.length > _nextSequentialCategoryIndex.value ? categories[_nextSequentialCategoryIndex.value].name : 'End'}) after _onScroll loaded ${categoryToFetchByVisibility.name}.');
        }
      });
      return;
    }


    final lastVisibleItem = visiblePositions.isNotEmpty ? visiblePositions.reduce((min, position) => position.index > min.index ? position : min) : null;

    if (lastVisibleItem == null) {
      return;
    }

    final int lastVisibleItemIndex = lastVisibleItem.index;

    if (_nextSequentialCategoryIndex.value >= categories.length) {
      return;
    }

    final nextSequentialCategory = categories[_nextSequentialCategoryIndex.value];

    int nextSequentialCatHeaderIndexInMenuItems = -1;
    for (int i = 0; i < menuItems.length; i++) {
      if (menuItems[i] is CategoryHeaderItem && (menuItems[i] as CategoryHeaderItem).categoryId == nextSequentialCategory.id) {
        nextSequentialCatHeaderIndexInMenuItems = i;
        break;
      }
    }

    if (nextSequentialCatHeaderIndexInMenuItems != -1) {
      const int loadMoreThresholdItems = 5;

      if (lastVisibleItemIndex >= nextSequentialCatHeaderIndexInMenuItems - loadMoreThresholdItems &&
          !_loadedCategoryIds.contains(nextSequentialCategory.id)) {
        print('User approaching next sequential category ${nextSequentialCategory.name} (from _nextSequentialCategoryIndex). Triggering load...');
        _loadDishesForCategory(nextSequentialCategory).then((_) {
          if (_loadedCategoryIds.contains(nextSequentialCategory.id)) {
            _nextSequentialCategoryIndex.value++;
            print('Advanced _nextSequentialCategoryIndex to ${_nextSequentialCategoryIndex.value} (category: ${categories.length > _nextSequentialCategoryIndex.value ? categories[_nextSequentialCategoryIndex.value].name : 'End'}) after _onScroll loaded ${nextSequentialCategory.name}.');
          } else {
            print('Failed to load ${nextSequentialCategory.name}, _nextSequentialCategoryIndex not advanced.');
          }
        });
      }
    } else {
      print('Warning: Next sequential category header ${nextSequentialCategory.name} not found in menuItems for sequential check.');
    }
  }

  // --- Jump to Specific Category Logic (`scrollToCategory`) ---
  void scrollToCategory(CategoryMenu category) async {
    print('Attempting to scroll to category: ${category.name}');

    _isProgrammaticScrolling.value = true;
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    print('Removed _onScroll listener temporarily for programmatic scroll.');

    int targetHeaderIndex = -1;
    for (int i = 0; i < menuItems.length; i++) {
      if (menuItems[i] is CategoryHeaderItem && (menuItems[i] as CategoryHeaderItem).categoryId == category.id) {
        targetHeaderIndex = i;
        break;
      }
    }

    if (targetHeaderIndex != -1) {
      if (!_loadedCategoryIds.contains(category.id)) {
        print('Dishes for ${category.name} not loaded. Fetching them before scrolling...');
        await _loadDishesForCategory(category);

        int newTargetHeaderIndex = -1;
        for (int i = 0; i < menuItems.length; i++) {
          if (menuItems[i] is CategoryHeaderItem && (menuItems[i] as CategoryHeaderItem).categoryId == category.id) {
            newTargetHeaderIndex = i;
            break;
          }
        }
        targetHeaderIndex = newTargetHeaderIndex;
        if (targetHeaderIndex == -1) {
          print('ERROR: Target category header vanished after loading dishes for ${category.name}. Cannot scroll.');
          itemPositionsListener.itemPositions.addListener(_onScroll);
          _isProgrammaticScrolling.value = false;
          return;
        }
      }

      print('Scrolling to category ${category.name} at index $targetHeaderIndex.');
      try {
        await itemScrollController.scrollTo(
          index: targetHeaderIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
        print('Scroll to category ${category.name} complete.');

        int categoryIndexInMasterList = categories.indexWhere((cat) => cat.id == category.id);
        if (categoryIndexInMasterList != -1) {
          _nextSequentialCategoryIndex.value = categoryIndexInMasterList + 1;
          print('Updated _nextSequentialCategoryIndex to ${categories.length > _nextSequentialCategoryIndex.value ? categories[_nextSequentialCategoryIndex.value].name : 'End'} (index ${_nextSequentialCategoryIndex.value}) after programmatic jump.');
        } else {
          _nextSequentialCategoryIndex.value = categories.length;
          print('Warning: Category not found in master list during _nextSequentialCategoryIndex update.');
        }

        _updateSelectedCategoryFromScroll();

      } catch (e) {
        print('Error during programmatic scroll: $e');
      } finally {
        itemPositionsListener.itemPositions.addListener(_onScroll);
        print('Re-added _onScroll listener.');
        _isProgrammaticScrolling.value = false;
        print('_isProgrammaticScrolling released.');
      }
    } else {
      print('ERROR: Category header for ${category.name} not found in menuItems at all. Cannot scroll.');
      itemPositionsListener.itemPositions.addListener(_onScroll);
      _isProgrammaticScrolling.value = false;
    }
  }

  // --- Tag Filtering Logic (`toggleTag`) ---
  void toggleTag(int tagId) async {
    if (selectedTagIds.contains(tagId)) {
      selectedTagIds.remove(tagId);
    } else {
      selectedTagIds.add(tagId);
    }
    print('Tags toggled. New selected tags: ${selectedTagIds.toList()}');

    itemPositionsListener.itemPositions.removeListener(_onScroll);
    print('Removed _onScroll listener during tag toggle.');

    _nextSequentialCategoryIndex.value = 0;
    _isLoadingCategoryDishes.value = false;
    _isProgrammaticScrolling.value = false;
    _loadedCategoryIds.clear();
    _populateAllCategoryPlaceholders();

    if (categories.isNotEmpty) {
      selectedCat.value = categories.first;
      await _loadDishesForCategory(categories.first);
      _nextSequentialCategoryIndex.value = 1;
    }

    // NEW: Check for empty menu state after tag filtering
    _handleEmptyMenuState();

    if (itemScrollController.isAttached) {
      try {
         itemScrollController.jumpTo(
          index: 0,

        );
        print('Scrolled to top after tag toggle.');
      } catch (e) {
        print('Error scrolling to top after tag toggle: $e');
      }

    }

    itemPositionsListener.itemPositions.addListener(_onScroll);
    print('Re-added _onScroll listener after tag toggle.');
  }

  @override
  void onClose() {
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.onClose();
  }
}