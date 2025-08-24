import 'package:flutter_application_restaurant/model/cart_details_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'cart_controller.dart'; 

class CartUpdateController extends GetxController {
  final CartItemDetails initialDetails;
  final CartService _cartService = Get.find<CartService>();
  final CartController _cartController = Get.find<CartController>();
  var itemQuantity = 1.obs;
  var selectedBasicOptionId = Rxn<int>();
  var selectedAdditionalOptionIds = <int>[].obs;

  CartUpdateController({required this.initialDetails});

  @override
  void onInit() {
    super.onInit();
    itemQuantity.value = initialDetails.quantity;
    initializeSelections();
  }

  void initializeSelections() {
    final basicAttrs = initialDetails.attributes?.basic;
    if (basicAttrs != null) {
      final sizeSelected = basicAttrs.size?.firstWhereOrNull((item) => item.isSelected);
      final piecesSelected = basicAttrs.piecesNumber?.firstWhereOrNull((item) => item.isSelected);
      selectedBasicOptionId.value = sizeSelected?.id ?? piecesSelected?.id;
    }

    final additionalAttrs = initialDetails.attributes?.additional;
    if (additionalAttrs != null) {
      final sauceSelected = additionalAttrs.sauce?.where((item) => item.isSelected).map((e) => e.id).toList();
      final addonsSelected = additionalAttrs.addons?.where((item) => item.isSelected).map((e) => e.id).toList();
      if (sauceSelected != null) selectedAdditionalOptionIds.addAll(sauceSelected);
      if (addonsSelected != null) selectedAdditionalOptionIds.addAll(addonsSelected);
    }
  }


  void selectBasicOption(int newId) {
    selectedBasicOptionId.value = newId;
    update();
  }


  void toggleAdditionalOption(int id) {
    if (selectedAdditionalOptionIds.contains(id)) {
      selectedAdditionalOptionIds.remove(id);
    } else {
      selectedAdditionalOptionIds.add(id);
    }
    update();
  }

  // void incrementQuantity() {
  //   itemQuantity.value++;
  // }

  // void decrementQuantity() {
  //   if (itemQuantity.value > 1) {
  //     itemQuantity.value--;
  //   }
  // }


  Future<void> updateCartItem() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
        barrierDismissible: false,
      );

      await _cartService.update(
        itemId: initialDetails.id,
        quantity: itemQuantity.value,
        basicOptionId: selectedBasicOptionId.value,
        additionalOptionIds: selectedAdditionalOptionIds.toList(),
      );
      
      Get.back(); 
      Get.back();

   print('تم التعديل بنجاح');
      

      _cartController.fetchCartItems();
    } catch (e) {
      Get.back();
         print('فشل التعديل '); 
      Get.snackbar(
        'Aleret',
        '$e',
        backgroundColor: Colors.red[500],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}