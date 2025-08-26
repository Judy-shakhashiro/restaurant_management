import 'package:flutter_application_restaurant/model/cart_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';  
import '../services/cart_service.dart';

class CartController extends GetxController {
  final CartService _cartService = Get.put(CartService());
  var cartItems = <CartItem>[].obs;
  var totalCartPrice = 0.0.obs;
  var isLoading = true.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    isLoading.value = true;
    isError.value = false;
    try {
      final ShowCart response = await _cartService.getCartItems();
      cartItems.assignAll(response.cart.items);
      totalCartPrice.value = response.cart.cartTotalPrice;  
      print('تم جلب عناصر السلة بنجاح: ${cartItems.length}');
    } catch (e) {
      print('خطأ في جلب عناصر السلة: $e');
      isError.value = true;
      Get.snackbar(
        'Alert',
        ' $e',
        backgroundColor: Colors.red[500],
         snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

 
  Future<void> deleteItem(int itemId) async {
    try {
      await _cartService.deleteCartItem(itemId);
      await fetchCartItems(); 
      print('نجاح الحذفففففففففف');
    } catch (e) {
     Get.snackbar(
        'Alert',
        ' $e',
        backgroundColor: Colors.red[500],
       snackPosition: SnackPosition.BOTTOM,
      );
      print('فشل : $e');
    }
  }

  Future<void> incrementQuantity(int itemId) async {
    try {
      await _cartService.incrementCartItem(itemId);
      await fetchCartItems(); 
      print('نجاح الزيادةةةةةةةةة');
    } catch (e) {
      Get.snackbar(
        'Alert',
        ' $e',
        backgroundColor: Colors.red[500],
       snackPosition: SnackPosition.BOTTOM,
      );
      print('فشل : $e');
    }
  }

 
  Future<void> decrementQuantity(int itemId) async {
    try {
      await _cartService.decrementCartItem(itemId);
      await fetchCartItems();
      print('نجاح النقصاننننننننننن');  
    } catch (e) {
      Get.snackbar(
        'Alert',
        ' $e',
        backgroundColor: Colors.red[500],
       snackPosition: SnackPosition.BOTTOM,
      );
      print('فشل : $e');
    }
  }
}
 
// Future<void> showProductDetailsBottomSheet(CartItem cartItem) async {
//   try {
//     Get.dialog(
//       const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
//       barrierDismissible: false,
//     );

//     final CartDetails details = await _cartService.getCartItemDetails(cartItem.id);
//     Get.back();

//     if (details.item == null) {
//       Get.snackbar(
//         'خطأ',
//         'تعذر العثور على تفاصيل المنتج',
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     final CartItemDetails productDetails = details.item!;

//     Get.bottomSheet(
//       isScrollControlled: true,
//       Container(
//         padding: const EdgeInsets.all(20.0),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 10,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: Container(
//                   width: 60,
//                   height: 6,
//                   margin: const EdgeInsets.only(bottom: 16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                 textBaseline: TextBaseline.alphabetic,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       productDetails.name,
//                       style: const TextStyle(
//                           fontSize: 22, fontWeight: FontWeight.bold),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Text(
//                     '${cartItem.totalPrice.toStringAsFixed(2)} EGP',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Colors.deepOrange,
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(thickness: 2, color: Colors.deepOrange),
//               const SizedBox(height: 5),
//               Text(
//                 productDetails.description,
//                 style: const TextStyle(fontSize: 16, color: Color(0xFFE65100)),
//               ),
//               const SizedBox(height: 16),

//               // Basic Attributes Section
//               if (productDetails.attributes?.basic != null &&
//                   ((productDetails.attributes!.basic!.size?.isNotEmpty ?? false) ||
//                       (productDetails.attributes!.basic!.piecesNumber?.isNotEmpty ?? false)))
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Basic Attributes',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     if (productDetails.attributes!.basic!.size?.isNotEmpty ?? false)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Size',
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 10,
//                             runSpacing: 8,
//                             children: productDetails.attributes!.basic!.size!
//                                 .map((attr) => Chip(
//                                       label: Text(
//                                         "${attr.name} (+${attr.price})",
//                                         style: TextStyle(
//                                           color: attr.isSelected ? Colors.white : Colors.black54,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       backgroundColor: attr.isSelected ? Colors.deepOrange : Colors.grey.shade200,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                         side: BorderSide(
//                                           color: attr.isSelected ? Colors.deepOrange : Colors.grey,
//                                           width: 1.5,
//                                         ),
//                                       ),
//                                       avatar: Icon(
//                                         attr.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
//                                         size: 18,
//                                         color: attr.isSelected ? Colors.white : Colors.grey,
//                                       ),
//                                     ))
//                                 .toList(),
//                           ),
//                         ],
//                       ),
//                     if ((productDetails.attributes!.basic!.size?.isNotEmpty ?? false) &&
//                         (productDetails.attributes!.basic!.piecesNumber?.isNotEmpty ?? false))
//                       const SizedBox(height: 16),
//                     if (productDetails.attributes!.basic!.piecesNumber?.isNotEmpty ?? false)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Pieces Number',
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 10,
//                             runSpacing: 8,
//                             children: productDetails.attributes!.basic!.piecesNumber!
//                                 .map((attr) => Chip(
//                                       label: Text(
//                                         "${attr.name} (+${attr.price})",
//                                         style: TextStyle(
//                                           color: attr.isSelected ? Colors.white : Colors.black54,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       backgroundColor: attr.isSelected ? Colors.deepOrange : Colors.grey.shade200,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                         side: BorderSide(
//                                           color: attr.isSelected ? Colors.deepOrange : Colors.grey,
//                                           width: 1.5,
//                                         ),
//                                       ),
//                                       avatar: Icon(
//                                         attr.isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
//                                         size: 18,
//                                         color: attr.isSelected ? Colors.white : Colors.grey,
//                                       ),
//                                     ))
//                                 .toList(),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               const SizedBox(height: 16),

//               // Additional Attributes Section
//               if (productDetails.attributes?.additional != null &&
//                   ((productDetails.attributes!.additional!.sauce?.isNotEmpty ?? false) ||
//                       (productDetails.attributes!.additional!.addons?.isNotEmpty ?? false)))
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Additional Attributes',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
                    
//                     // Sauce Section
//                     if (productDetails.attributes!.additional!.sauce?.isNotEmpty ?? false)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Sauces',
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 10,
//                             runSpacing: 8,
//                             children: productDetails.attributes!.additional!.sauce!
//                                 .map(
//                                   (attr) => Chip(
//                                     label: Text(
//                                       attr.name,
//                                       style: TextStyle(
//                                           color: attr.isSelected ? Colors.white : Colors.black54,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     backgroundColor: attr.isSelected ? Colors.deepOrange : Colors.grey.shade200,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                       side: BorderSide(
//                                         color: attr.isSelected ? Colors.deepOrange : Colors.grey,
//                                         width: 1.5,
//                                       ),
//                                     ),
//                                     avatar: Icon(
//                                       attr.isSelected ? Icons.check_circle : Icons.add_circle_outline,
//                                       size: 18,
//                                       color: attr.isSelected ? Colors.white : Colors.deepOrange,
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ],
//                       ),
                      
//                     // Addons Section
//                     if (productDetails.attributes!.additional!.addons?.isNotEmpty ?? false)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Addons',
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                           ),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 10,
//                             runSpacing: 8,
//                             children: productDetails.attributes!.additional!.addons!
//                                 .map(
//                                   (attr) => Chip(
//                                     label: Text(
//                                       attr.name,
//                                       style: TextStyle(
//                                           color: attr.isSelected ? Colors.white : Colors.black54,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     backgroundColor: attr.isSelected ? Colors.deepOrange : Colors.grey.shade200,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                       side: BorderSide(
//                                         color: attr.isSelected ? Colors.deepOrange : Colors.grey,
//                                         width: 1.5,
//                                       ),
//                                     ),
//                                     avatar: Icon(
//                                       attr.isSelected ? Icons.check_circle : Icons.add_circle_outline,
//                                       size: 18,
//                                       color: attr.isSelected ? Colors.white : Colors.deepOrange,
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               const SizedBox(height: 16),

//               // Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Get.to(() => DishDetailsPage(productId: cartItem.id));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFFFF3E0),
//                         foregroundColor: const Color(0xFFE65100),
//                       ),
//                       child: const Text('Edit Item'),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Get.back(),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFE65100),
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text('Close'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   } catch (e) {
//     Get.back();
//     Get.snackbar(
//       'خطأ',
//       'فشل جلب تفاصيل المنتج: ${e.toString()}',
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//   }
// }









