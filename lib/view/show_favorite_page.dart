import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contr_fav.dart';
import '../model/dish_details_mode.dart';

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
      color: Colors.deepOrange.shade300,
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
              List<Product> favorites = List.from(wishlistController.favoriteProducts);

              if (favorites.isEmpty) {
                return const Center(child: Text('لا يوجد منتجات في المفضلة '));
              }

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
                       Get.snackbar(
                      'Success',
                      'remove ${product.name} from favorite',
                      backgroundGradient: LinearGradient(colors: [Color.fromARGB(255, 255, 210, 150), Colors.white]),
                      snackPosition: SnackPosition.BOTTOM,
                );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade300,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow:const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
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
                                'http://192.168.175.173:8000/api/images/${product.image}',
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
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
                                     Divider(thickness: 2,color: Colors.deepOrange.shade400),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${product.price} \$",
                                      style: const TextStyle(fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
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
                            ),
                          ],
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
        backgroundColor: Colors.deepOrange.shade300,
        onPressed: () {
          setState(() {
            sortByPrice = !sortByPrice;
          });
        },
        child:  Icon(Icons.sort),
        tooltip: "Store by price",
      ),
    );
  }
}



 Future<List<Product>> showFav() async {
  final Dio _dio = Dio();

  var options = Options(
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'guest_token': 'dfsgdfgdfsgerg'
    },
  );

  String url = "http://192.168.175.173:8000/api/wishlists";

  try {
    final response = await _dio.get(url, options: options);

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = response.data['products'];

      return productsJson.map((json) => Product.fromJson(json)).toList();
    }
  } catch (e) {
    print("Error: $e");
  }

  return [];
}
