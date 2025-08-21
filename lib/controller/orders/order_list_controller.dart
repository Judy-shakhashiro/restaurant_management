// lib/controller/order_list_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../services/order_service.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();

  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final List<Order>? fetchedOrders = await _orderService.getOrders();
      if (fetchedOrders != null) {
        orders.assignAll(fetchedOrders);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print('Error in controller fetching orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await fetchOrders();
  }

  Future<void> cancelOrder(int orderId) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              isLoading.value = true;
              final bool success = await _orderService.cancelOrder(orderId);
              if (success) {
                await fetchOrders();
              }
              isLoading.value = false;
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteOrder(int orderId) async {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this order permanently? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              isLoading.value = true;
              final bool success = await _orderService.deleteOrder(orderId);
              if (success) {
                orders.removeWhere((order) => order.id == orderId);
              }
              isLoading.value = false;
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );
  }


}