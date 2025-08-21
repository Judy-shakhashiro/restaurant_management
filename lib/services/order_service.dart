import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../core/static/routes.dart';
import '../controller/cart_controller.dart';

class Order {
  final int id;
  final String orderName;
  final String orderNumber;
  final String status;
  final String receivingMethod;
  final String finalPrice; // Keep as String as per your JSON, convert to double if needed for calculations
  final String createdAt;
  final int itemsCount;

  Order({
    required this.id,
    required this.orderName,
    required this.orderNumber,
    required this.status,
    required this.receivingMethod,
    required this.finalPrice,
    required this.createdAt,
    required this.itemsCount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderName: json['order_name'],
      orderNumber: json['order_number'],
      status: json['status'],
      receivingMethod: json['receiving_method'],
      finalPrice: json['final_price'].toString(), // Ensure it's a string
      createdAt: json['created_at'],
      itemsCount: json['items_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_name': orderName,
      'order_number': orderNumber,
      'status': status,
      'receiving_method': receivingMethod,
      'final_price': finalPrice,
      'created_at': createdAt,
      'items_count': itemsCount,
    };
  }
}


class OrderItem {
  final String name;
  final int quantity;
  final String basePrice;
  final String extraPrice;
  final String totalPrice;
  final String? selectedAdditionalOptions; // Nullable

  OrderItem({
    required this.name,
    required this.quantity,
    required this.basePrice,
    required this.extraPrice,
    required this.totalPrice,
    this.selectedAdditionalOptions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      quantity: json['quantity'],
      basePrice: json['base_price'].toString(),
      extraPrice: json['extra_price'].toString(),
      totalPrice: json['total_price'].toString(),
      selectedAdditionalOptions: json['selected_additional_options']?.toString(), // Handle potential null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'base_price': basePrice,
      'extra_price': extraPrice,
      'total_price': totalPrice,
      'selected_additional_options': selectedAdditionalOptions,
    };
  }
}

class OrderDetail {
  final int id;
  final String orderNumber;
  final String status;
  final String receivingMethod;
  final String paymentMethod;
  final String createdAt;
  final String estimatedReceivingTime;
  final int itemsCount;
  final double totalPrice;
  final double deliveryFee;
  final double discount;
  final double finalPrice;
  final List<OrderItem> items;
  final OrderAddress? address; // Made nullable

  OrderDetail({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.receivingMethod,
    required this.paymentMethod,
    required this.createdAt,
    required this.estimatedReceivingTime,
    required this.itemsCount,
    required this.totalPrice,
    required this.deliveryFee,
    required this.discount,
    required this.finalPrice,
    required this.items,
    this.address, // Now nullable
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<OrderItem> orderItems = itemsList.map((i) => OrderItem.fromJson(i)).toList();

    return OrderDetail(
      id: json['id'],
      orderNumber: json['order_number'],
      status: json['status'],
      receivingMethod: json['receiving_method'],
      paymentMethod: json['payment_method'],
      createdAt: json['created_at'],
      estimatedReceivingTime: json['estimated_receiving_time'],
      itemsCount: json['items_count'],
      totalPrice: double.parse(json['total_price'].toString()),
      deliveryFee: double.parse(json['delivery_fee'].toString()),
      discount: double.parse(json['discount'].toString()),
      finalPrice: double.parse(json['final_price'].toString()),
      items: orderItems,
      address:  OrderAddress.fromJson(json['address']), // Handle null address
    );
  }
}
class OrderAddress {
  final String name;
  final String? latitude;
  final String? longitude;
  final String? driverLatitude; // Nullable as it might not always be present
  final String? driverLongitude; // Nullable

  OrderAddress({
    required this.name,
     this.latitude,
     this.longitude,
    this.driverLatitude,
    this.driverLongitude,
  });

  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    return OrderAddress(
      name: json['name'],
      latitude: json['latitude']??null,
      longitude: json['longitude']??null,
      driverLatitude: json['driver_latitude']?.toString(), // Handle potential null
      driverLongitude: json['driver_longitude']?.toString(), // Handle potential null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'driver_latitude': driverLatitude,
      'driver_longitude': driverLongitude,
    };
  }
}
class CheckoutDetails{
  final int itemsCount;
  final int price;
  final String? distance;
  final int deliveryFees;
  final String? estimatedDeliveryTime;
  final int discount;
  final int totalPrice;
  CheckoutDetails({
    required this.itemsCount,
    required this.price,
    required this.distance,
    required this.deliveryFees,
    required this.estimatedDeliveryTime,
    required this.discount,
    required this.totalPrice,
  });
  factory CheckoutDetails.fromJson(Map<String,dynamic> json){
    return CheckoutDetails(
        itemsCount: json['items_count'],
        price: json['total_price'],
        discount: json['discount'],
        deliveryFees: json['delivery_fee'],
        estimatedDeliveryTime: json['estimated_delivery_driver_time'],
        distance: json['distance'],
        totalPrice:json['final_price']
    );
  }
}
class OrderService {
  final CartController cartController = Get.put(CartController());
  Future<bool> createOrder({
    required String receivingMethod,
    required String paymentMethod,
    List<String>? orderNotes,
    required int addressId,
  }) async {
    final uri = Uri.parse('${Linkapi.backUrl}/orders');

    final Map<String, String> fields = {
      'receiving_method': receivingMethod,
      'payment_method': paymentMethod,
      'address_id': addressId.toString(),
    };

   var request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${token}';
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add multiple order_notes[] fields
    if (orderNotes != null) {
      for (var note in orderNotes) {
        request.fields.addAll({'order_notes[]': note}); // Use addAll to handle multiple entries
      }
    }


    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Order created successfully: $responseBody');
        cartController.cartItems.clear();
       return true;
      } else {
        print('Failed to create order. Status code: ${response.statusCode}');
        print('Response body: $responseBody');
        return false;
      }
    } catch (e) {
      print('Error creating order: $e');
      Get.snackbar(
        'Error',
        'Error creating order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<List<Order>?> getOrders() async {
    final uri = Uri.parse('${Linkapi.backUrl}/orders');

    if ({token} == null) {
      Get.snackbar(
        'Authentication Error',
        'User not authenticated. Please log in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token}', // Add the Bearer Token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['orders'] != null) {
          List<dynamic> ordersJson = jsonResponse['orders'];
          return ordersJson.map((json) => Order.fromJson(json)).toList();
        } else {
          print('API returned success: ${jsonResponse['status']} but no orders or unexpected structure.');
          return []; // Return an empty list if no orders or unexpected structure
        }
      } else {
        print('Failed to load orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to load orders: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print('Error fetching orders: $e');
      Get.snackbar(
        'Error',
        'Error fetching orders: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  Future<OrderDetail?> getOrderDetail(int orderId) async {
    final uri = Uri.parse('${Linkapi.backUrl}/orders/$orderId');

    if ({token} == null) {
      Get.snackbar(
        'Authentication Error',
        'User not authenticated. Please log in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['order'] != null) {
          return OrderDetail.fromJson(jsonResponse['order']);
        } else {
          print('API returned success: ${jsonResponse['status']} but no order data or unexpected structure.');
          return null;
        }
      } else {
        print('Failed to load order details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to load order details: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
   }
    catch(e){
      print('Error fetching order details: $e');
      Get.snackbar(
        'Error',
        'Error fetching order details: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }


  }

  Future<bool> cancelOrder(int orderId) async {
    final uri = Uri.parse('${Linkapi.backUrl}/orders/$orderId');

    if ({token} == null) {
      Get.snackbar(
        'Authentication Error',
        'User not authenticated. Please log in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      // The screenshot shows a PATCH request for canceling.
      // Assuming no specific body is needed beyond the URL,
      // but if your API requires a status update in the body, add it here.
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        // body: json.encode({'status': 'canceled'}), // Example if API requires body
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return true;
        } else {
          Get.snackbar(
            'Failed',
            jsonResponse['message'] ?? 'Failed to cancel order.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        print('Failed to cancel order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to cancel order: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error cancelling order: $e');
      Get.snackbar(
        'Error',
        'Error cancelling order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
  Future<bool> deleteOrder(int orderId) async {
    final uri = Uri.parse('${Linkapi.backUrl}/orders/$orderId');


    if ({token} == null) {
      Get.snackbar(
        'Authentication Error',
        'User not authenticated. Please log in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return true;
        } else {
          Get.snackbar(
            'Failed',
            jsonResponse['message'] ?? 'Failed to delete order.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        print('Failed to delete order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to delete order: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error deleting order: $e');
      Get.snackbar(
        'Error',
        'Error deleting order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
  Future<CheckoutDetails?> getCheckoutDetails(String receivingMethod,int addressId) async {
    String url='';
    if(receivingMethod=='Delivery'){
      receivingMethod='delivery';
      url='${Linkapi.backUrl}/orders/creating-details?receiving_method=$receivingMethod&address_id=$addressId';
    }
    else if (receivingMethod=='Pick Up'){
      receivingMethod='pick_up';
      url='${Linkapi.backUrl}/orders/creating-details?receiving_method=$receivingMethod';

    }
  // try{
  print(url);
      final response = await http.get(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return CheckoutDetails.fromJson(jsonResponse['details']); }
    // }
    // catch(e){
    //   print('Error getting checkout details: $e');
    //   Get.snackbar(
    //     'Error',
    //     'Error getting checkout details: $e',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    // }
  return null;
  }
}