// lib/view/my_orders.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/orders/order_list_controller.dart';
import '../../services/order_service.dart';
import 'order_details_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(OrderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
        } else if (orderController.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load orders.', style: TextStyle(fontSize: 18, color: Colors.red)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => orderController.fetchOrders(), // Retry fetch
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (orderController.orders.isEmpty) {
          return const Center(
            child: Text(
              'You have no orders yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () => orderController.refreshOrders(), // Pull to refresh
            color: Colors.deepOrange,
            child: ListView.builder(
              itemCount: orderController.orders.length,
              itemBuilder: (context, index) {
                final Order order = orderController.orders[index];
                bool isCanceled = order.status.toLowerCase() == 'cancelled';
                print(isCanceled);
                print('rtttttattata');
                bool isPending = order.status.toLowerCase() == 'pending';
                return GestureDetector(
                  onTap: () {
                    Get.to(() => OrderDetailPage(orderId: order.id)); // Pass the order ID
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order #${order.orderNumber}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)), //
                          const SizedBox(height: 8),
                          Text('Status: ${order.status}', style: TextStyle(fontSize: 16, color: isCanceled ? Colors.red : Colors.black)), //
                          Text('Name: ${order.orderName}', style: const TextStyle(fontSize: 16)), //
                          Text('Method: ${order.receivingMethod}', style: const TextStyle(fontSize: 16)), //
                          Text('Price: \$${order.finalPrice}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), //
                          Text('Items: ${order.itemsCount}', style: const TextStyle(fontSize: 16)), //
                          Text('Date: ${order.createdAt}', style: const TextStyle(fontSize: 14, color: Colors.grey)), //
                          if (isCanceled)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [


                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        orderController.deleteOrder(order.id);
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Delete'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child:
                                    ElevatedButton.icon(
                                      onPressed: () {
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Reorder'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepOrange,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (isPending)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        orderController.deleteOrder(order.id);
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Delete'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black54,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        orderController.cancelOrder(order.id);
                                      },
                                      icon: const Icon(Icons.cancel),
                                      label: const Text('Cancel'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black54,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}