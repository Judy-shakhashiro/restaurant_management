import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/dish_details_model.dart';
import '../services/cart_service.dart';
import '../services/dish_details_service.dart';

class DishDetailsController extends GetxController {
  final int productId;
  final DishDetailsService dishDetailsService = DishDetailsService();
  final CartService cartService = CartService();

  var dishDetails = Rx<DishDetails?>(null);
  var isLoading = true.obs;
  var errorMessage = Rx<String?>(null);

  var selectedSize = Rx<AttributeItem?>(null);
  var selectedPiecesNumber = Rx<AttributeItem?>(null);
  var selectedAddons = <AttributeItem>[].obs;
  var selectedSauces = <AttributeItem>[].obs;
  var quantity = 1.obs;
  var totalPrice = 0.0.obs;

  DishDetailsController({required this.productId});

  @override
  void onInit() {
    super.onInit();
    fetchDishDetails();
    everAll([selectedSize, selectedPiecesNumber, selectedAddons, selectedSauces, quantity], (_) => _updatePrice());
  }

  Future<void> fetchDishDetails() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final fetchedDetails = await dishDetailsService.getDishDetails(productId);
      dishDetails.value = fetchedDetails as DishDetails?;
      _initializeSelectionsAndPrice();
    } catch (e) {
      errorMessage.value = 'Failed to load dish details: $e';
      Get.snackbar(
        'Alert',
        ' ${errorMessage.value}',
        backgroundColor: Colors.red[500],
       snackPosition: SnackPosition.BOTTOM,
      );
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeSelectionsAndPrice() {
  if (dishDetails.value == null) return;

  final product = dishDetails.value!.product;
  final basicAttributes = product?.attributes.basic;
  final additionalAttributes = product?.attributes.additional;

  // 1. تحديد الخيار الافتراضي للحجم
  if (basicAttributes?.size != null && basicAttributes!.size!.isNotEmpty) {
    selectedSize.value = basicAttributes.size!.firstWhereOrNull((item) => item.isDefault) ??
        basicAttributes.size!.first;
  } else {
    selectedSize.value = null;
  }

  // 2. تحديد الخيار الافتراضي لعدد القطع
  if (basicAttributes?.piecesNumber != null && basicAttributes!.piecesNumber!.isNotEmpty) {
    selectedPiecesNumber.value = basicAttributes.piecesNumber!.firstWhereOrNull((item) => item.isDefault) ??
        basicAttributes.piecesNumber!.first;
  } else {
    selectedPiecesNumber.value = null;
  }

  // 3. تحديد الإضافات الافتراضية (Addons)
  if (additionalAttributes?.addons != null) {
    selectedAddons.assignAll(additionalAttributes!.addons!.where((item) => item.isDefault).toList());
  } else {
    selectedAddons.clear();
  }

  // 4. تحديد الصلصات الافتراضية (Sauces)
  if (additionalAttributes?.sauce != null) {
    selectedSauces.assignAll(additionalAttributes!.sauce!.where((item) => item.isDefault).toList());
  } else {
    selectedSauces.clear();
  }
}
  void updateSelectedSize(AttributeItem? size) {
    if (selectedSize.value != size) {
      selectedSize.value = size;
    }
  }

  void updateSelectedPiecesNumber(AttributeItem? piecesNumber) {
    if (selectedPiecesNumber.value != piecesNumber) {
      selectedPiecesNumber.value = piecesNumber;
    }
  }

  void toggleAddonSelection(AttributeItem addon, bool isSelected) {
    if (isSelected) {
      if (!selectedAddons.any((item) => item.id == addon.id)) {
        selectedAddons.add(addon);
      }
    } else {
      selectedAddons.removeWhere((item) => item.id == addon.id);
    }
  }

  void toggleSauceSelection(AttributeItem sauce, bool isSelected) {
    if (isSelected) {
      if (!selectedSauces.any((item) => item.id == sauce.id)) {
        selectedSauces.add(sauce);
      }
    } else {
      selectedSauces.removeWhere((item) => item.id == sauce.id);
    }
  }

void _updatePrice() {
  if (dishDetails.value == null) return;

  // ✅ 1. حساب السعر الأساسي بناءً على الخيارات المحددة (size or piecesNumber)
  double calculatedPrice = 0.0;
  
  if (selectedSize.value != null) {
    calculatedPrice = double.parse(selectedSize.value!.price);
  } else if (selectedPiecesNumber.value != null) {
    calculatedPrice = double.parse(selectedPiecesNumber.value!.price);
  } else {
    // إذا لم يكن هناك أي خيار أساسي، نستخدم السعر الأساسي للمنتج
    calculatedPrice = double.parse(dishDetails.value!.product!.price);
  }

  // ✅ 2. إضافة أسعار الإضافات (Addons)
  for (var addon in selectedAddons) {
    calculatedPrice += double.parse(addon.price);
  }

  // ✅ 3. إضافة أسعار الصلصات (Sauces)
  for (var sauce in selectedSauces) {
    calculatedPrice += double.parse(sauce.price);
  }

  // ✅ 4. ضرب المجموع بالكمية
  totalPrice.value = calculatedPrice * quantity.value;
}
  void resetSelections() {
    _initializeSelectionsAndPrice();
  }

  Future<void> addToCart() async {
    int? basicOptionId;
    if (selectedSize.value != null) {
      basicOptionId = selectedSize.value!.id;
    } else if (selectedPiecesNumber.value != null) {
      basicOptionId = selectedPiecesNumber.value!.id;
    }

    List<int> additionalOptions = [];
    additionalOptions.addAll(selectedAddons.map((e) => e.id));
    additionalOptions.addAll(selectedSauces.map((e) => e.id));

    try {
      final String message = await cartService.addProductToCart(
        productId: productId,
        quantity: quantity.value,
        basicOptionId: basicOptionId,
        additionalOptionIds: additionalOptions,
      );
      print('Added to cart! Total: ${totalPrice.value} EGP');
      print('Selected Size: ${selectedSize.value?.name}');
      print('Selected Pieces Number: ${selectedPiecesNumber.value?.name}');
      print('Selected Addons: ${selectedAddons.map((e) => e.name).join(', ')}');
      print('Selected Sauces: ${selectedSauces.map((e) => e.name).join(', ')}');
    } catch (e) {
      Get.snackbar(
        'Alert',
        ' $e',
        backgroundColor: Colors.red[500],
       snackPosition: SnackPosition.BOTTOM,
      );
      print('Error adding to cart: $e');
    }
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}