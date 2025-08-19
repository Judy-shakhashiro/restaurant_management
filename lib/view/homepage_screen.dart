import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/reservation/reservations_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../core/static/routes.dart';
import '../controller/favourite_controller.dart';
import '../controller/home_controller.dart';
import '../model/category_model.dart';
import '../model/home_page_model.dart';
import 'cart.dart';
import 'orders/delivery_location.dart';
import 'dish_details.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<Map<String, dynamic>> deliveryCategories = [
    {'title': 'delivery', 'icon': Icons.delivery_dining_sharp,'page':()=>DeliveryLocationPage()},
    const {'title': 'take away', 'icon': Icons.takeout_dining_outlined},
    {'title': 'in restaurant', 'icon': Icons.table_bar_sharp,'page':const ReservationsView()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: InkWell(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)],
              color: Colors.white,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    "Babbila , Damascus",
                    style: TextStyle(color: Colors.grey,fontSize: 18),
                  ),
                ),

              ],
            ),
          ),
        ),
        actions: [
          InkWell(

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)],
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: const Icon(Icons.notifications_none),
            ),
          ),
          InkWell(
           onTap: (){Get.to(CartScreen());},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)],
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: Obx(() {
        // This outer Obx only reacts to isLoading and errorMessage
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(
            child: Text(
              controller.errorMessage.value!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        final HomeModel? homeData = controller.homeData.value;
        final CategoriesResponse? categoriesResponse = controller.categoriesData.value;

        if (homeData == null || categoriesResponse == null) {
          return const Center(child: Text('No data available.'));
        }
    return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    itemCount: deliveryCategories.length + 1,
                    separatorBuilder: (context, index) => const SizedBox(width: 24),
                    itemBuilder: (context, index) {
                      if (index < deliveryCategories.length) {
                        final category = deliveryCategories[index];
                        return Obx(() {
                          // This Obx reacts only to controller.selectedDeliveryIndex.value
                          final isSelected = controller.selectedDeliveryIndex.value == index;
                          return Animate(
                            effects: const [
                              SlideEffect(
                                begin: Offset(0, 0.4),
                                end: Offset(0, 0),
                                duration: Duration(milliseconds: 600),
                                curve: Curves.easeOut,
                              ),
                              FadeEffect(duration: Duration(milliseconds: 600))
                            ],
                            delay: Duration(milliseconds: index * 80),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(category['page']);
                                  controller.selectDeliveryCategory(index);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade100,
                                        // gradient:  LinearGradient(
                                        //   colors: [Colors.deepOrange,Colors.red.shade100],
                                        //   begin: Alignment.topLeft,
                                        //   end: Alignment.bottomRight,
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isSelected ? Colors.deepOrange.withOpacity(0.6) : Colors.grey.shade300,
                                            blurRadius: isSelected ? 6 : 4,
                                            offset: const Offset(2, 4),
                                          ),
                                        ],
                                        border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                                      ),
                                      child: Icon(
                                        category['icon'],
                                        color: Colors.deepOrange,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      category['title'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.deepOrange : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                Obx(() {
                  // This Obx reacts only to controller.isVideoInitialized.value and controller.isVideoPlaying.value
                  return controller.isVideoInitialized.value
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: controller.videoController.value.aspectRatio,
                        child: GestureDetector(
                          onTap: () {
                            controller.toggleVideoPlayPause();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(controller.videoController),
                              if (!controller.isVideoPlaying.value)
                                Container(
                                  color: Colors.black45,
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white,
                                    size: 64,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }),

                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Get.to(() => CartScreen());
                  },
                  child: sectionTitle("Menu"),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                 child:  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriesResponse.categories.length,
                      itemBuilder: (context, index) {
                        final c =categoriesResponse.categories[index];
                        return cate(c);
                      },
                    )
                 ,
                ),
                sectionTitle("Most purchased"),
                const SizedBox(height: 10),
               productList(homeData.data.mostOrderedProducts),
                const SizedBox(height: 20),
                sectionTitle("Latest offers"),
                const SizedBox(height: 10),
               productList(homeData.data.latestProducts),
                const SizedBox(height: 20),
                sectionTitle("Best choices"),
                const SizedBox(height: 10),
              productList(homeData.data.recommendedProducts),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }), // This closes the Obx for isLoading/errorMessage
    );
  }

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Row(
      children: [
        AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              title,
              textStyle: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              colors: [Colors.black, Colors.deepOrangeAccent, Colors.deepOrange],
            )
          ],
          isRepeatingAnimation: true,
        ),
      ],
    ),
  );

  Widget cate(CategoryR c) {
    return
      // This Obx reacts only to controller.selectedCategoryId.value
      GestureDetector(
        onTap: () {
          controller.selectFoodCategory(c.id);
          controller.selectedCategoryId.value = c.id;

          // Get.to(() => CategoryProductsPage(category: c));
        },
        child: Obx((){
          final isSelected = controller.selectedCategoryId.value == c.id;

          return
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 4)],
                    border: Border.all(
                        color: isSelected ? Colors.deepOrange : Colors.deepOrange, width: 3),
                    color: isSelected ? Colors.deepOrange.shade50 : Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('${Linkapi.backUrl}/images/${c.image}'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 80,
                  child: Text(
                    c.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.deepOrange : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );},
        ),
      );
  }

  Widget productList(List<ProductHome> products) {
    return SizedBox(
      height: 370,
      child: ListView.builder(
        itemCount: products.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ProductCard(context, products[index]);
        },
      ),
    );
  }
  Widget ProductCard(BuildContext context,ProductHome product) {
    bool isExpanded = false;
    bool isFavorite = false;
    final WishlistController controller = Get.put(WishlistController());

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 260,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow:  [BoxShadow(color: Colors.grey, blurRadius: 8,)],
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            Get.to(DishDetailsPage(productId: product.id));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  '${Linkapi.backUrl}/images/${product.image}',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(() {
                          bool isFav = controller.isFavorite(product.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              await controller.toggleFavorite(product.id);
                            },
                          );
                        }),


                      ])
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 80),
                child: Divider(thickness: 2,color: Colors.deepOrange,),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: AnimatedCrossFade(
              //     firstChild: Text(
              //       product.description.length > 30
              //           ? product.description.substring(0, 30) + '...'
              //           : product.description,
              //       style: const TextStyle(fontSize: 15, color: Colors.black87),
              //     ),
              //     secondChild: Text(
              //       product.description,
              //       style: const TextStyle(fontSize: 16, color: Colors.black87),
              //     ),
              //     crossFadeState: isExpanded
              //         ? CrossFadeState.showSecond
              //         : CrossFadeState.showFirst,
              //     duration: const Duration(milliseconds: 300),
              //   ),
              // ),
              // if (product.description.length > 30)
              //   Padding(
              //     padding: const EdgeInsets.only(left: 20, top: 5),
              //     child: TextButton(
              //       onPressed: () {
              //         setState(() {
              //           isExpanded = !isExpanded;
              //         });
              //       },
              //       child: Text(
              //         isExpanded ? "عرض أقل" : "عرض المزيد",
              //         style: const TextStyle(color: Colors.black),
              //       ),
              //     ),
              //   ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${product.price} \$",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(DishDetailsPage(productId: product.id));
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: Colors.deepOrange.withOpacity(0.3),
                      highlightColor: Colors.deepOrange.withOpacity(0.1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.deepOrange, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "View",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }
}