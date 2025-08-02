// cart_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../model/cart_model.dart';
import '../services/cart_service (4).dart';

class CartController extends GetxController {
  final CartService _cartService = Get.put(CartService());


  var cartItems = <CartItem>[].obs;

  var totalCartPrice = 0.0.obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems(); 
  }


  Future<void> fetchCartItems() async {
    isLoading.value = true;
    try {
      final ShowCart response = await _cartService.getCartItems();
      cartItems.assignAll(response.cart.items);
      totalCartPrice.value = response.cart.cartTotalPrice;
      print('Cart items fetched: ${cartItems.length}');
    } catch (e) {
      print('Error fetching cart items: $e');
      Get.snackbar(
        'خطأ',
        'فشل تحميل السلة: ${e.toString().replaceFirst('Exception: ', '')}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteItem(int itemId) async {
    try {
 
      final int index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final CartItem removedItem = cartItems[index];
        cartItems.removeAt(index);
        updateTotalPrice();  
 
        final String message = await _cartService.deleteCartItem(itemId);
        Get.snackbar(
            'success',
            message,
            backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 210, 150), 
          Colors.white
        ]),
            colorText: Colors.black87, 
        duration: const Duration(seconds: 3), 
          );
      }
    } catch (e) {
      print('Error deleting item: $e');
      Get.snackbar(
        'خطأ',
        'فشل حذف المنتج: ${e.toString().replaceFirst('Exception: ', '')}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      fetchCartItems(); 
    } finally {
      fetchCartItems();
    }
  }

 
  Future<void> incrementQuantity(int itemId) async {
    try {
      final int index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        cartItems[index].quantity.value++; 
        cartItems.refresh(); 
        updateTotalPrice(); 

        final String message = await _cartService.incrementCartItem(itemId);
        Get.snackbar(
            'success',
            message,
            backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 210, 150), 
          Colors.white
        ]),
            colorText: Colors.black87, 
        duration: const Duration(seconds: 3), 
          );
      }
    } catch (e) {
      print('Error incrementing quantity: $e');
      Get.snackbar(
        'خطأ',
        'فشل زيادة الكمية: ${e.toString().replaceFirst('Exception: ', '')}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      fetchCartItems(); 
    }
  }


  Future<void> decrementQuantity(int itemId) async {
    try {
      final int index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        if (cartItems[index].quantity > 1) {
          cartItems[index].quantity.value--; 
          cartItems.refresh();
          updateTotalPrice();

          final String message = await _cartService.decrementCartItem(itemId);
          Get.snackbar(
            'success',
            message,
            backgroundGradient: const LinearGradient(colors: [
          Color.fromARGB(255, 255, 210, 150), 
          Colors.white
        ]),
            colorText: Colors.black87, 
        duration: const Duration(seconds: 3), 
          );


        } else {
          deleteItem(itemId);
        }
      }
    } catch (e) {
      print('Error decrementing quantity: $e');
      Get.snackbar(
        'خطأ',
        'فشل تقليل الكمية: ${e.toString().replaceFirst('Exception: ', '')}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      fetchCartItems(); 
    }
  }


Future<void> showProductDetailsBottomSheet(CartItem cartItem) async {
  try {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
      barrierDismissible: false,
    );

    final CartItemDetails details =
        await _cartService.getCartItemDetails(cartItem.id);
    Get.back(); 

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(20.0),  
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),  
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Center(
                child: Container(
                  width: 60,  
                  height: 6,  
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],  
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,  
                textBaseline: TextBaseline.alphabetic,  
                children: [
                  Expanded(
                    child: Text(
                      details.cartItem.name,
                      style: const TextStyle(
                        fontSize: 22, // خط أكبر
                        fontWeight: FontWeight.bold,
                        color: Colors.black, 
                      ),
                      maxLines: 2,  
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                     '${(double.parse(cartItem.totalPrice)).toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      fontSize: 20, 
                    //  fontWeight: FontWeight.bold,
                      color: Colors.deepOrange, 
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              
               
               Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: const Divider(thickness: 2, color: Colors.deepOrange),
                ),
              
              const SizedBox(height: 5),
              
               
              Text(
                details.cartItem.description,
                style: const TextStyle(fontSize: 16, color: Color(0xFFE65100)),
              ),
              
              const SizedBox(height: 10),
          
               
              if (cartItem.selectedAttributes.basic.isNotEmpty) ...[
                const Text(
                  'Basic Attributes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,  
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,  
                  children: cartItem.selectedAttributes.basic
                      .map(
                        (attr) => Chip(
                          label: Text(
                            attr.name,
                            style: const TextStyle(
                              color:  Color(0xFFE65100),  
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: const Color(0xFFFFF3E0),  
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),  
                            side: const BorderSide(
                              color:  Color(0xFFE65100), width: 1 
                            ),
                          ),
                          avatar: const Icon(
                            Icons.check_circle_outline,  
                            size: 18,
                            color: Colors.deepOrange,  
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),  
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),  
              ],
          
             
              if (cartItem.selectedAttributes.additional != null &&
                  cartItem.selectedAttributes.additional!.isNotEmpty) ...[
                const Text(
                  'Additional Attributes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,  
                  ),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),  
                  crossAxisCount: 2, // عدد الأعمدة
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3.5,  
                  children: cartItem.selectedAttributes.additional!.entries.map((entry) {
                    return Chip(
                      label: Text(
                        '${entry.value.name}',
                        style: const TextStyle(
                          color: Color(0xFFE65100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     backgroundColor:  Color(0xFFFFF3E0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFFE65100), width: 1),
                      ),
                      avatar: const Icon(
                        Icons.add_circle_outline,
                        size: 18,
                        color: Colors.deepOrange,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 10), 
              ],
           
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        
                        Get.back();  
                         
                        // Get.to(() => DishDetailsPage(productId: cartItem.id,));
                        print('Edit button pressed for product ID: ${cartItem.id}'); // Placeholder
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF3E0), 
                        foregroundColor: const Color(0xFFE65100),
                        padding: const EdgeInsets.symmetric(vertical: 14), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), 
                          side: const BorderSide(color: Color(0xFFE65100), width: 1.5), 
                        ),
                        elevation: 3,
                      ),
                      child: const Text('Edit Item', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE65100), 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text('Close', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } catch (e) {
    Get.back(); 
    print('Error showing product details: $e');
    Get.snackbar(
      'خطأ',
      'فشل جلب تفاصيل المنتج: ${e.toString().replaceFirst('Exception: ', '')}',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}


  void updateTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += double.parse(item.totalPrice) * item.quantity.value;
    }
    totalCartPrice.value = total;
  }
}