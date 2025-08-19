import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/static/routes.dart';
import '../model/dish_details_model.dart';



class WishlistController extends GetxController {
  var favoriteProductIds = <int>{}.obs;
  var favoriteProducts = <Product>[].obs;

  bool isFavorite(int productId) => favoriteProductIds.contains(productId);

  Future<void> toggleFavorite(int productId) async {
    if (isFavorite(productId)) {
      await removeFromWishlist(productId);
      favoriteProductIds.remove(productId);
      favoriteProducts.removeWhere((product) => product.id == productId);
    } else {
      await addToWishlist(productId);
      favoriteProductIds.add(productId);
      await loadFavorites(); 
    }
  }

  Future<void> addToWishlist(int productId) async {
    final Dio dio = Dio();
    String url = '${Linkapi.backUrl}/wishlists/add-product';

    try {
      final response = await dio.post(
        url,
        data: {'product_id': productId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'guest_token': 'dfsgdfgdfsgerg',
          },
        ),
      );

      if (response.statusCode == 200) {
         Get.snackbar(
          'Success',
          '${response.data['message']}',
          backgroundGradient: LinearGradient(colors: [Color.fromARGB(255, 255, 210, 150), Colors.white]),
          snackPosition: SnackPosition.BOTTOM,
    );
        print('تمت إضافة المنتج بنجاح');
      } else {
        print('فشل في الإضافة: ${response.statusCode}');
        Get.snackbar('خطأ', 'فشل في إضافة المنتج إلى المفضلة');
      }
    } catch (e) {
      print('Exception adding favorite: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء الإضافة');
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    final Dio dio = Dio();
     String url = '${Linkapi.backUrl}/wishlists/remove-product';

    try {
      final response = await dio.post(
        url,
        data: {'product_id': productId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'guest_token': 'dfsgdfgdfsgerg',
          },
        ),
      );

      if (response.statusCode == 200) {
          Get.snackbar(
          'Success',
          '${response.data['message']}',
          backgroundGradient: LinearGradient(colors: [Color.fromARGB(255, 255, 210, 150), Colors.white]),
          snackPosition: SnackPosition.BOTTOM,
    );
        print('تم الحذف بنجاح');
      } else {
        print('فشل في الحذف: ${response.statusCode}');
        Get.snackbar('خطأ', 'فشل في حذف المنتج من المفضلة');
      }
    } catch (e) {
      print('Exception removing favorite: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء الحذف');
    }
  }

  Future<void> loadFavorites() async {
    final Dio dio = Dio();
     String url = '${Linkapi.backUrl}/wishlists';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'guest_token': 'dfsgdfgdfsgerg',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        final List<Product> products = productsJson.map((e) => Product.fromJson(e)).toList();
        favoriteProducts.assignAll(products);
        favoriteProductIds.assignAll(products.map((e) => e.id));
      }
    } catch (e) {
      print("خطأ أثناء تحميل المفضلة: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }
}
