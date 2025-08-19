// lib/controller/order_detail_controller.dart
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../services/order_service.dart';
import 'order_controller.dart';

class OrderDetailController extends GetxController {
  final OrderService _orderService = OrderService();

  final Rx<OrderDetail?> orderDetail = Rx<OrderDetail?>(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  final int orderId;

  OrderDetailController({required this.orderId});

  @override
  void onInit() {
    super.onInit();
    fetchOrderDetail(orderId);
  }

  Future<void> fetchOrderDetail(int id) async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final OrderDetail? fetchedDetail = await _orderService.getOrderDetail(id);
      if (fetchedDetail != null) {
        orderDetail.value = fetchedDetail;
      } else {
        hasError.value = true;
      }
    }
    catch (e) {
      hasError.value = true;
      print('Error in controller fetching order details: $e');
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelCurrentOrder() async {
    if (orderDetail.value == null) return;

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
              final bool success = await _orderService.cancelOrder(orderDetail.value!.id);
              if (success) {
                await fetchOrderDetail(orderDetail.value!.id);
                if (Get.isRegistered<OrderController>()) {
                  Get.find<OrderController>().fetchOrders();
                }
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

  Future<void> deleteCurrentOrder() async {
    if (orderDetail.value == null) return;

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
              final bool success = await _orderService.deleteOrder(orderDetail.value!.id);
              if (success) {
                Get.back();
                if (Get.isRegistered<OrderController>()) {
                  Get.find<OrderController>().fetchOrders();
                }
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

// reorderCurrentOrder method removed
}