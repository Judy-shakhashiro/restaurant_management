import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/model/favorite_model.dart';
import 'package:get/get.dart';

import '../core/static/routes.dart'; // تأكد من المسار



class WishlistController extends GetxController {
  var favoriteProductIds = <int>{}.obs;
  var favoriteProducts = <ProductFavorite>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;


  bool isFavorite(int productId) => favoriteProductIds.contains(productId);

  Future<void> toggleFavorite(int productId) async {
    if (isFavorite(productId)) {
      await removeFromFavorite(productId);
      favoriteProductIds.remove(productId);
      favoriteProducts.removeWhere((product) => product.id == productId);
    } else {
      await addToFavorite(productId);
      await ShowFavorite();
    }
  }

  Future<void> addToFavorite(int productId) async {
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
        print('تمت إضافة المنتج بنجاح');
      } else {
        print('فشل في الإضافة: ${response.statusCode}');
        String errorMessage = response.data?['message'] ?? ' error ';
        Get.snackbar(
          'Alert',
          errorMessage,
          backgroundColor: Colors.red[500],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioError catch (e) {
      print('$e');
    }
  }

  Future<void> removeFromFavorite(int productId) async {
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
        print('تم الحذف بنجاح');
      } else {
        print('فشل في الحذف: ${response.statusCode}');
        String errorMessage = response.data?['message'] ?? ' error';
        Get.snackbar(
          'Alert',
          errorMessage,
          backgroundColor: Colors.red[500],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioError catch (e) {
     print('$e');
    }
  }

   Future<void> ShowFavorite() async {
    isLoading.value = true;
    hasError.value = false;
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
        final wishlistResponse = WishlistResponse.fromJson(response.data);
        final List<ProductFavorite> products = wishlistResponse.products;
        
        favoriteProducts.assignAll(products);
        favoriteProductIds.assignAll(products.map((e) => e.id));
        
        isLoading.value = false; 
        print('تم تحميل ${products.length} منتج مفضل بنجاح.');
      } else {
        isLoading.value = false;
        hasError.value = true; 
        print('فشل تحميل المفضلة: ${response.statusCode}');
      }
    } on DioError catch (e) {
      isLoading.value = false;
      hasError.value = true; 
      print("خطأ أثناء تحميل المفضلة (DioError): ${e.message}");
    } catch (e) {
      isLoading.value = false;
      hasError.value = true; 
      print("خطأ غير متوقع أثناء تحميل المفضلة: $e");
    }
  }


  @override
  void onInit() {
    super.onInit();
    ShowFavorite();
  }
}