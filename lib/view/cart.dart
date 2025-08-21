import 'package:flutter/material.dart';
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
    final adController=Get.put(GetAddressesController());
    final CartController controller = Get.put(CartController());

    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        backgroundColor:Colors.white12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Cart',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),

        // actions: [
        //   Obx(() => Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: CircleAvatar(
        //       backgroundColor: Colors.deepOrange.shade200,
        //       child: Text(
        //         '${controller.cartItems.length}',
        //         style: const TextStyle(
        //           fontSize: 20,
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   )),
        // ],
        centerTitle: false,
      ),

      body: Stack(
        children:[ Column(
          children: [
            Obx(
                    () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.cartItems.isEmpty
                    ? const Center(
                  child: Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
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
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('${item.name} remo ')),
                        // );
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
                      child:
                      CartItemCard(item: item, controller: controller),
                    );
                  },
                )

            ),
            Divider(height: 10,thickness: 8,color: Colors.grey.withAlpha(70),),
            _buildCheckoutBar(controller),

          ],
        ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () {
                  if(adController.addresses.value.isNotEmpty) {
                    Get.to(() => const CreateOrderPage());
                  }

                  else{
                    Get.to( ()=>const DeliveryLocationPage());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 6,
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(()=>
                       Text(
                        controller.cartItems.length==1?  '${controller.cartItems.length} item ':
                        '${controller.cartItems.length} items ',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'Georgia',fontSize: 20)
                      ),
                    ),
                    const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      '        ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),],
      ),
    );
  }

  Widget _buildCheckoutBar(CartController controller) {
    return Obx(
          () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
                'Total',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                )               ),
            Text(
              '${controller.totalCartPrice.value.toStringAsFixed(2)}  EGP',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),


          ],
        ),
      ),
    );
  }
}

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
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    '${Linkapi.backUrl}/images/${item.image}',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),

                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${item.totalPrice.toStringAsFixed(2)} EGP',
                          style: const TextStyle(
                            fontSize: 18,
                            //   fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height:30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.grey.withAlpha(70),blurRadius: 5,spreadRadius: 4)],
                                //color: const Color(0xFFFFE0B2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 15, color: Color(0xFFE65100)),
                                    onPressed: () => controller.decrementQuantity(item.id),
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                  Obx(
                                        () => Text(
                                      item.quantity.value.toString(),
                                      style: const TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 15, color: Color(0xFFE65100)),
                                    onPressed: () => controller.incrementQuantity(item.id),
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8,),

                            GestureDetector(
                              onTap: () => controller.showProductDetailsBottomSheet(item),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                // decoration: BoxDecoration(
                                //   boxShadow: [BoxShadow(color: Colors.grey.withAlpha(70),blurRadius: 5,spreadRadius: 4)],
                                //   borderRadius: BorderRadius.circular(30),
                                // ),
                                child: const Text(
                                  'Details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.deepOrange,
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
                ),

              ],
            ),



          ),


          Positioned(
            top: 10,
            right: 5,
            child: GestureDetector(
              onTap: () => controller.deleteItem(item.id),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}







