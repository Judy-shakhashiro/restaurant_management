import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/controller/favourite_controller.dart';
import 'package:flutter_application_restaurant/core/static/global_lotti.dart';
import 'package:flutter_application_restaurant/view/dish_details.dart';
import 'package:get/get.dart';
import 'package:flutter_application_restaurant/model/favorite_model.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  final WishlistController wishlistController = Get.put(WishlistController());
  bool sortByPrice = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SlideTransition(
            position: _offsetAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade400,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16.0,
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_sharp,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Favorite",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {

              if (wishlistController.isLoading.value) {
                return MyLottiFavorite();
              }

              if (wishlistController.hasError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 20),
                      const Text(
                        'Please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.red)
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                   onPressed: () {
                      wishlistController.ShowFavorite();
                        }, // Retry fetch
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                  
                ),
                    ],
                  ),
                );
              }

              if (wishlistController.favoriteProducts.isEmpty) {
                return MyLottiNodata();
              }

              List<ProductFavorite> favorites = wishlistController.favoriteProducts.toList();
              if (sortByPrice) {
                favorites.sort((a, b) => a.price.compareTo(b.price));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final product = favorites[index];
                  return Dismissible(
                    key: Key(product.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      wishlistController.toggleFavorite(product.id);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade400,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.to(DishDetailsPage(productId: product.id));
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                                child: Image.network(
                                  '${Linkapi.bacUrlImage}${product.image}',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const SizedBox(
                                height: 120,
                                width: 120,
                                child:  Center(
                                  child: MyLottiMario()
                                ),
                              );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 120,
                                      width: 120,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Divider(thickness: 2, color: Colors.deepOrange.shade400),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${product.price} \$",
                                        style: const TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(() {
                                return IconButton(
                                  icon: Icon(
                                    wishlistController.isFavorite(product.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: wishlistController.isFavorite(product.id)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    wishlistController.toggleFavorite(product.id);
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange.shade400,
        onPressed: () {
          setState(() {
            sortByPrice = !sortByPrice;
          });
        },
        child: const Icon(Icons.sort),
        tooltip: "Store by price",
      ),
    );
  }
}
