import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/model/cart_details_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../core/static/routes.dart';
import '../model/cart_model.dart';

class CartService extends GetxService {


   final String guest_token = 'dfsgdfgdfsgerg'; 


  Future<String> addProductToCart({
    required int productId,
    required int quantity,
    int? basicOptionId,
    List<int>? additionalOptionIds,
  }) async {
    final url = Uri.parse('${Linkapi.backUrl}/carts/items');
    var request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${token}';
    request.headers['guest_token']='$guest_token';
    request.fields['product_id'] = productId.toString();
    request.fields['quantity'] = quantity.toString();

    if (basicOptionId != null) {
      request.fields['basic_option_id'] = basicOptionId.toString();
    }

    if (additionalOptionIds != null && additionalOptionIds.isNotEmpty) {
      for (int i = 0; i < additionalOptionIds.length; i++) {
        request.fields['additional_option_ids[$i]'] = additionalOptionIds[i].toString();
      }
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Add to Cart - Status Code: ${response.statusCode}');
      print('Add to Cart - Response Body: $responseBody');

      if (responseBody.isEmpty) {
        throw Exception('Empty response body from server for add to cart.');
      }

      final Map<String, dynamic> decodedResponse = json.decode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
       
        final String message = decodedResponse['message'] ?? 'success';
        print('نجاح : ${message}');
        return message; 
      } else {
       
        final String errorMessage = decodedResponse['message'] ?? 'error';
         Get.snackbar(
          'Alert',
          errorMessage,
          backgroundColor: Colors.red[500],
          snackPosition: SnackPosition.BOTTOM,
        );
        throw Exception(errorMessage); 
      }
    } catch (e) {
      print('Error in addProductToCart: $e');
      throw Exception('error');
    }
  }


  Future<ShowCart> getCartItems() async {
  final url = Uri.parse('${Linkapi.backUrl}/carts');
  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${token}',
    'guest_token': '$guest_token'
  });

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('>>> Full API Response for Cart: ${response.body}');
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return ShowCart.fromJson(jsonResponse);
  } else if (response.statusCode == 404) { 
    print('Cart is empty, returning an empty cart object.');
    return ShowCart(
        status: false,
        statusCode: 404,
        message: "No items found in cart",
        cart: Cart(items: [], cartTotalPrice: 0.0, itemsCount: 0)
    );
  } else {
    print('Failed to load cart: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception(
        'Failed to load cart: ${response.statusCode} - ${response.body}');
  }
}

 
  Future<String> deleteCartItem(int itemId) async {
    try {
      final url = Uri.parse('${Linkapi.backUrl}/carts/items/$itemId');
      final response = await http.delete(url, headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ${token }',
        'guest_token':'$guest_token'
      });

      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (response.statusCode == 200|| response.statusCode==201) {
        print('نجاح : ${response.body}');
        return decodedResponse['message'] ?? 'تم حذف المنتج بنجاح.';
      } else {
        final String errorMessage = decodedResponse['message'] ?? 'error';
        print('Failed to delete cart item: ${response.statusCode}');
        print('Response body: ${response.body}');
        Get.snackbar(
          'Alert',
          errorMessage,
          backgroundColor: Colors.red[500],
          snackPosition: SnackPosition.BOTTOM,
        );
        throw Exception(
            decodedResponse['message'] ?? 'فشل حذف المنتج: خطأ غير معروف.');
      }
    } catch (e) {
      print('Error deleting cart item: $e');
      throw Exception('فشل في حذف المنتج: يرجى التحقق من الاتصال.');
    }
  }

 
  Future<String> incrementCartItem(int itemId) async { 
    try {
      final url = Uri.parse('${Linkapi.backUrl}/carts/items/$itemId/increment');
      final response = await http.patch(url, headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ${token}',
        'guest_token':'$guest_token'
      });

      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (response.statusCode == 200|| response.statusCode==201) {
        return decodedResponse['message'] ?? 'تمت زيادة الكمية بنجاح.';
      } else {
        print('Failed to increment cart item: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            decodedResponse['message'] ?? 'فشل زيادة الكمية: خطأ غير معروف.');
      }
    } catch (e) {
      print('Error incrementing cart item: $e');
      throw Exception('فشل في زيادة الكمية: يرجى التحقق من الاتصال.');
    }
  }

 
  Future<String> decrementCartItem(int itemId) async { 
    try {
      final url = Uri.parse('${Linkapi.backUrl}/carts/items/$itemId/decrement');
      final response = await http.patch(url, headers: {
        'Accept': 'application/json',
      'guest_token':'$guest_token',
      'Authorization' : 'Bearer ${token}',

      });

      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (response.statusCode == 200|| response.statusCode==201) {
        return decodedResponse['message'] ?? 'تم تقليل الكمية بنجاح.';
      } else {
        print('Failed to decrement cart item: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            decodedResponse['message'] ?? 'فشل تقليل الكمية: خطأ غير معروف.');
      }
    } catch (e) {
      print('Error decrementing cart item: $e');
      throw Exception('فشل في تقليل الكمية: يرجى التحقق من الاتصال.');
    }
  }

  Future<CartDetails> getCartItemDetails(int itemId) async {
    try {
      final url = Uri.parse('${Linkapi.backUrl}/carts/items/$itemId');
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ${token}',
        'guest_token':'$guest_token'
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return CartDetails.fromJson(jsonResponse);
      } else {
        print('Failed to load cart item details: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to load cart item details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error getting cart item details: $e');
      throw Exception('Error getting cart item details: $e');
    }
  }


Future<String> update({
  required int itemId, 
  required int quantity,
  int? basicOptionId,
  List<int>? additionalOptionIds,
}) async {
  final url = Uri.parse('${Linkapi.backUrl}/carts/items/$itemId'); 
  var request = http.MultipartRequest('POST', url);
  request.headers['Accept'] = 'application/json';
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['guest_token'] = '$guest_token';
  request.fields['quantity'] = quantity.toString();

  if (basicOptionId != null) {
    request.fields['basic_option_id'] = basicOptionId.toString();
  }

  if (additionalOptionIds != null && additionalOptionIds.isNotEmpty) {
    for (int i = 0; i < additionalOptionIds.length; i++) {
      request.fields['additional_option_ids[$i]'] = additionalOptionIds[i].toString();
    }
  }

  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('update Cart - Status Code: ${response.statusCode}');
    print('update Cart - Response Body: $responseBody');

    if (responseBody.isEmpty) {
      throw Exception('Empty response body from server for update cart.');
    }

    final Map<String, dynamic> decodedResponse = json.decode(responseBody);

    if (response.statusCode == 200) {
      final String message = decodedResponse['message'] ?? 'تم تعديل المنتج بنجاح!';
      print('نجاح : $message');
      return message;
    } else {
      final String errorMessage = decodedResponse['message'] ?? 'فشل تعديل المنتج: خطأ غير معروف.';
      Get.snackbar(
          'Alert',
          errorMessage,
          backgroundColor: Colors.red[500],
          snackPosition: SnackPosition.BOTTOM,
        );
      throw Exception(errorMessage);
    }
  } catch (e) {
    print('Error in updateCartItem: $e');
    throw Exception('فشل في تعديل المنتج: يرجى التحقق من الاتصال أو بيانات الطلب.');
  }
}}