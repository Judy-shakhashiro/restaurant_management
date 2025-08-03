import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/widgets/dish_item.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';


import '../core/static/config.dart';
import '../controller/menu_controller.dart';
import '../globals.dart';
import '../model/favorite_model.dart';
import '../model/menu_item.dart';
import 'dish_details.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MyMenuController c = Get.put(MyMenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Discover Menu'), backgroundColor: Colors.white),
      body: Obx(() {
        // While the very first category is loading, show a full shimmer
        if (c.menuItems.isEmpty) {
          return _buildFullShimmer();

        }

        return Column(
          children: [
            // --- Category selector ─────────────────────────────────
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(38),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withAlpha(80),
                              offset: const Offset(3, 3),
                              blurRadius: 4,
                              spreadRadius: 3,
                            )
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.list_alt_outlined,
                              size: 30, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "menu",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: c.categories.length,
                      itemBuilder: (_, i) {
                        final cat = c.categories[i];
                        return GestureDetector(
                          onTap: () {
                            c.selectedCat.value = cat;
                            // Trigger the scroll using the controller's logic
                            c.scrollToCategory(cat);
                          },
                          child: Obx(() {
                            final isSelected = cat == c.selectedCat.value;
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: isSelected
                                    ? const Border(
                                  bottom: BorderSide(
                                    color: Colors.orange,
                                    width: 3,
                                  ),
                                )
                                    : null,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(38),
                                      border: isSelected
                                          ? Border.all(
                                          color: Colors.orange, width: 2)
                                          : null,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withAlpha(50),
                                          offset: const Offset(3, 3),
                                          blurRadius: 4,
                                          spreadRadius: 3,
                                        )
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: isSelected ? 34 : 32,
                                      backgroundColor: isSelected
                                          ? Colors.orange[100]
                                          : Colors.grey[200],
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(38),
                                          // Ensure backUrl is correctly provided by config.dart
                                          child: Image.network("${Linkapi.backUrl}/images/${cat.image}",
                                            fit: BoxFit.cover, // Ensure image covers the circle
                                            errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image, color: Colors.grey), // Fallback for image load error
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    cat.name,
                                    style: TextStyle(
                                      fontSize: isSelected ? 17 : 16,
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.black54,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // --- Tag selector ──────────────────────────────────────
            Container(
              height: 50,
              margin: const EdgeInsets.all(8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: c.tags.length,
                itemBuilder: (_, i) {
                  final Tag tag = c.tags[i];
                  return GestureDetector(
                    onTap: () {
                      // showDialog(context: context, builder:(BuildContext context){
                      //   return Center(child: Icon(Icons.restaurant));
                      // });
                      c.toggleTag(tag.id);
                    },
                    child: Obx(() {
                      final active = c.selectedTagIds.contains(tag.id);
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.orange
                              : tagColors[i % tagColors.length], // Assuming tagColors is accessible
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag.name,
                          style: TextStyle(
                            fontSize: active ? 16 : 14,
                            color: active ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),

            // --- The interleaved ScrollablePositionedList ──────────────────────────
            Expanded(
            child:  ScrollablePositionedList.builder(
                // Use ItemScrollController and ItemPositionsListener from the controller
                itemScrollController: c.itemScrollController,
                itemPositionsListener: c.itemPositionsListener,
                itemCount: c.menuItems.length,
                itemBuilder: (context, i) {
                  final item = c.menuItems[i];
                  if (item is CategoryHeaderItem) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(40),
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      margin: const EdgeInsets.all(20),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.circle, color: Colors.orange, size: 13),
                          ),
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.circle, color: Colors.orange, size: 13),
                          ),
                        ],
                      ),
                    );
                  }

                  if (item is LoadingItem) {
                    // single-shimmer placeholder for dish items
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 250, // Shimmer height matching DishItemTile approximate height
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  if (item is DishItem) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => DishDetailsPage(productId: item.dish.id));
                      },
                      child: DishItemTile(dish: item.dish),
                    );
                  }
                  else if (item is NoItemsFoundItem) {
                    // NEW: Display a clear message when no dishes are found
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            const Text(
                              'No dishes found for the selected tags.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Please try different filters or clear your selection.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              )
            ),
          ],
        );
      }),
    );
  }

  // --- Shimmer Builders ---
  Widget _buildFullShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // Categories shimmer (adjust height if needed to match actual categories list height)
          SizedBox(
            height: 120, // Match the height of your actual category selector
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Number of shimmer items for categories
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: 64, // CircleAvatar radius * 2
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 50, // Text width
                      height: 16, // Text height
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tags shimmer
          SizedBox(
            height: 50, // Match height of actual tag selector
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Number of shimmer items for tags
              itemBuilder: (_, __) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                width: 70, // Tag button width
                height: 30, // Tag button height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // Dishes shimmer
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Show a few shimmer dish items
              itemBuilder: (_, __) => Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Container(
                  height: 250, // Match DishItemTile height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}