import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/controller/cart_irem_updat_controller.dart';
import 'package:flutter_application_restaurant/model/cart_details_model.dart';
import 'package:get/get.dart';
import '../core/static/routes.dart';
import '../controller/cart_controller.dart';
import '../controller/orders/get_addresses_controller.dart';
import '../model/cart_model.dart';
import '../services/cart_service.dart';
import 'orders/create_order_page.dart';
import 'orders/delivery_location.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CartService());
    final CartController controller = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16, top: 7),
            child: Text(
              controller.cartItems.length == 1
                  ? '${controller.cartItems.length} item '
                  : '${controller.cartItems.length} items ',
              style: const TextStyle(color: Colors.black, fontFamily: 'Georgia', fontSize: 20),
            ),
          )),
        ],
        centerTitle: false,
      ),
      body: Stack(
        alignment: Alignment.center, // Align children to the center
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.isError.value) {
    // حالة وجود خطأ في الاتصال
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
                      controller.fetchCartItems();
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
  } else if (controller.cartItems.isEmpty) {
    // حالة السلة فارغة                         لا تنسي اللوتي هون
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.deepOrange,
            size: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'سلتك فارغة!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ابدأ بالتسوق'),
          ),
        ],
      ),
    );
  } else {
              // Show the cart items list when loaded
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return Dismissible(
                    key: Key(item.id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      controller.deleteItem(item.id);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: CartItemCard(item: item, controller: controller),
                  );
                },
              );
            }
          }),
        ],
      ),
      bottomNavigationBar: _buildCheckoutBar(controller),
    );
  }
}

//   Widget _buildCheckoutBar(CartController controller) {
//     return Obx(
//           () => Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//                 'Total',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                 )               ),
//             Text(
//               '${controller.totalCartPrice.value.toStringAsFixed(2)}  EGP',
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),


//           ],
//         ),
//       ),
//     );
//   }
// }

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartController controller;

  const CartItemCard({Key? key, required this.item, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepOrange, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      '${Linkapi.bacUrlImage}${item.image}',
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(() {
//  final double currentItemPrice = item.totalPrice.toDouble();
  return Text(
    '${item.totalPrice.value.toStringAsFixed(2)} EGP',
    style: const TextStyle(
      fontSize: 20,
      color: Colors.deepOrange,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.deepOrange, width: 1),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 20, color: Color(0xFFE65100)),
                            onPressed: () => controller.decrementQuantity(item.id),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                          ),
                          Obx(
                            () => Text(
                              item.quantity.value.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20, color: Color(0xFFE65100)),
                            onPressed: () => controller.incrementQuantity(item.id),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showProductDetailsBottomSheet(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE0B2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepOrange, width: 1),
                        ),
                        child: const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => controller.deleteItem(item.id),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Obx(() => Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.deepOrange.shade300,
                child: Text(
                  item.quantity.value.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
  
 Widget _buildCheckoutBar(CartController controller) {
  final adController=Get.put(GetAddressesController());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
           'Total  ',
           style: TextStyle(
             color: Colors.black,
             fontSize: 18,
             fontWeight: FontWeight.bold,
           )               ),
           Obx((){
             return Text(
                      '${controller.totalCartPrice.value.toStringAsFixed(2)}  EGP',
                      style: const TextStyle(
             color: Colors.black,
             fontSize: 18,
             fontWeight: FontWeight.bold,
                      ),
                       );
 }),
                      
          
         ElevatedButton.icon(
             onPressed: () {
                  if(adController.addresses.value.isNotEmpty) {
                    Get.to(() => const CreateOrderPage());
                  }

                  else{
                    Get.to( ()=>const DeliveryLocationPage());
                  }
                },
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            label: const Text(
              'Continue',
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }




Future<void> showProductDetailsBottomSheet(CartItem cartItem) async {
  try {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
      barrierDismissible: false,
    );

    final CartService _cartService = Get.put(CartService());
    final CartDetails details = await _cartService.getCartItemDetails(cartItem.id);
    Get.back(); 

    if (details.item == null) {
      Get.snackbar(
        'Alert',
        'No details',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final CartItemDetails productDetails = details.item!;
    final editController = Get.put(CartUpdateController(initialDetails: productDetails));
    Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<CartUpdateController>(
        init: editController,
        builder: (controller) {
          return Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                          productDetails.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 15),
                      
                   Text(
                    '${cartItem.totalPrice} EGP',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                    ),
                  
    ),
  ],
),
                    
                  const Padding(
                     padding: const EdgeInsets.only(right: 180),
                     child: Divider(thickness: 2, color: Colors.deepOrange),
                   ),
                  const SizedBox(height: 5),
                  Text(
                    productDetails.description,
                    style: const TextStyle(fontSize: 16, color: Color(0xFFE65100)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Basic Attributes Section
                  if (productDetails.attributes?.basic != null &&
                      ((productDetails.attributes!.basic!.size?.isNotEmpty ?? false) ||
                          (productDetails.attributes!.basic!.piecesNumber?.isNotEmpty ?? false)))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Basic Attributes :',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        if (productDetails.attributes!.basic!.size?.isNotEmpty ?? false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('--> Size', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,color: Colors.deepOrange)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: productDetails.attributes!.basic!.size!
                                    .map((attr) => ChoiceChip(
                                          label: Text(
                                            "${attr.name} (+${attr.price})",
                                            style: TextStyle(
                                              color: controller.selectedBasicOptionId.value == attr.id ? Colors.white : Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          selected: controller.selectedBasicOptionId.value == attr.id,
                                          onSelected: (bool selected) {
                                            if (selected) {
                                              controller.selectBasicOption(attr.id);
                                            }
                                          },
                                          selectedColor: Colors.deepOrange,
                                          backgroundColor:  Colors.grey[50],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: controller.selectedBasicOptionId.value == attr.id ? Colors.deepOrange : Colors.deepOrange,
                                              width: 1.5,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        if ((productDetails.attributes!.basic!.size?.isNotEmpty ?? false) &&
                            (productDetails.attributes!.basic!.piecesNumber?.isNotEmpty ?? false))
                          const SizedBox(height: 16),
                        if (productDetails.attributes!.basic!.piecesNumber?.isNotEmpty ?? false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('--> Pieces Number', 
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,color: Colors.deepOrange)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: productDetails.attributes!.basic!.piecesNumber!
                                    .map((attr) => ChoiceChip(
                                          label: Text(
                                            "${attr.name} (+${attr.price})",
                                            style: TextStyle(
                                              color: controller.selectedBasicOptionId.value == attr.id ? Colors.white : Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          selected: controller.selectedBasicOptionId.value == attr.id,
                                          onSelected: (bool selected) {
                                            if (selected) {
                                              controller.selectBasicOption(attr.id);
                                            }
                                          },
                                          selectedColor: Colors.deepOrange,
                                          backgroundColor:  Colors.grey[50],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: controller.selectedBasicOptionId.value == attr.id ? Colors.deepOrange : Colors.deepOrange,
                                              width: 1.5,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  
                  // Additional Attributes Section
                  if (productDetails.attributes?.additional != null &&
                      ((productDetails.attributes!.additional!.sauce?.isNotEmpty ?? false) ||
                          (productDetails.attributes!.additional!.addons?.isNotEmpty ?? false)))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Additional Attributes :', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        if (productDetails.attributes!.additional!.sauce?.isNotEmpty ?? false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('--> Sauces', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,color: Colors.deepOrange)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: productDetails.attributes!.additional!.sauce!
                                    .map((attr) => FilterChip(
                                          label: Text(
                                            attr.name,
                                            style: TextStyle(
                                                color: controller.selectedAdditionalOptionIds.contains(attr.id) ? Colors.white : Colors.black87,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          selected: controller.selectedAdditionalOptionIds.contains(attr.id),
                                          onSelected: (bool selected) {
                                            controller.toggleAdditionalOption(attr.id);
                                          },
                                          selectedColor: Colors.deepOrange,
                                         backgroundColor:  Colors.grey[50],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: controller.selectedAdditionalOptionIds.contains(attr.id) ? Colors.deepOrange : Colors.deepOrange,
                                              width: 1.5,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        if (productDetails.attributes!.additional!.addons?.isNotEmpty ?? false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('--> Addons', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,color: Colors.deepOrange)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: productDetails.attributes!.additional!.addons!
                                    .map((attr) => FilterChip(
                                          label: Text(
                                            attr.name,
                                            style: TextStyle(
                                                color: controller.selectedAdditionalOptionIds.contains(attr.id) ? Colors.white : Colors.black87,
                                                fontWeight: FontWeight.bold,fontSize: 15
                                                ),
                                          ),
                                          selected: controller.selectedAdditionalOptionIds.contains(attr.id),
                                          onSelected: (bool selected) {
                                            controller.toggleAdditionalOption(attr.id);
                                          },
                                          selectedColor: Colors.deepOrange,
                                          backgroundColor: Colors.grey.shade50,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: controller.selectedAdditionalOptionIds.contains(attr.id) ? Colors.deepOrange : Colors.deepOrange,
                                              width: 1.5,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.updateCartItem();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            foregroundColor: Colors.black,
                             side:const BorderSide(color: Colors.deepOrange,width: 1.5)
                          ),
                          child: const Text('Edit Item',style: TextStyle(fontSize: 18),),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.grey[500],
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            foregroundColor: Colors.black,
                            side:const BorderSide(color: Colors.black,width: 1.5)
                          ),
                          child: const Text('Close',style: TextStyle(fontSize: 18),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).whenComplete(() {
      Get.delete<CartUpdateController>();
    });
  } catch (e) {
    Get.back();
    Get.snackbar(
      'Alert',
      ' ${e.toString()}',
      backgroundColor: Colors.red[500],
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}