



import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../core/static/config.dart';
import '../model/cart_model.dart';

class CartService extends GetxService {


   final String _guestToken = 'dfsgdfgdfsgerg'; 


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

      if (response.statusCode >= 200 && response.statusCode < 300) {
       
        final String message = decodedResponse['message'] ?? 'تمت إضافة المنتج بنجاح!';
        return message; 
      } else {
       
        final String errorMessage = decodedResponse['message'] ?? 'فشل إضافة المنتج: خطأ غير معروف.';
        throw Exception(errorMessage); 
      }
    } catch (e) {
      print('Error in addProductToCart: $e');
      throw Exception('فشل في إضافة المنتج: يرجى التحقق من الاتصال أو بيانات الطلب.');
    }
  }


  Future<ShowCart> getCartItems() async { 
    try {
      final url = Uri.parse('${Linkapi.backUrl}/carts');
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ${token}',
      });

     if (response.statusCode == 200) {
  print('>>> Full API Response for Cart: ${response.body}'); 
  final Map<String, dynamic> jsonResponse = json.decode(response.body);
  return ShowCart.fromJson(jsonResponse);
}else {
        print('Failed to load cart: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to load cart: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error getting cart: $e');
      throw Exception('Error getting cart: $e');
    }
  }

 
  Future<String> deleteCartItem(int itemId) async {
    try {
      final url = Uri.parse('${Linkapi.backUrl}/carts/items/$itemId');
      final response = await http.delete(url, headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ${token }',
      });

      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse['message'] ?? 'تم حذف المنتج بنجاح.';
      } else {
        print('Failed to delete cart item: ${response.statusCode}');
        print('Response body: ${response.body}');
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
      });

      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
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

      'Authorization' : 'Bearer ${token}',

      });

      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
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

  Future<CartItemDetails> getCartItemDetails(int itemId) async {
    try {
      final url = Uri.parse('${Linkapi.backUrl}/carts/items/$itemId');
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer ${token}',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return CartItemDetails.fromJson(jsonResponse);
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
    required int quantity,
    int? basicOptionId,
    List<int>? additionalOptionIds,
  }) async {
    final url = Uri.parse('${Linkapi.backUrl}/carts/items');
    var request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${token}';

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
        throw Exception('Empty response body from server for add to cart.');
      }

      final Map<String, dynamic> decodedResponse = json.decode(responseBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
       
        final String message = decodedResponse['message'] ?? 'تمت إضافة المنتج بنجاح!';
        return message; 
      } else {
    
        final String errorMessage = decodedResponse['message'] ?? 'فشل إضافة المنتج: خطأ غير معروف.';
        throw Exception(errorMessage); 
      }
    } catch (e) {
      print('Error in addProductToCart: $e');
      throw Exception('فشل في إضافة المنتج: يرجى التحقق من الاتصال أو بيانات الطلب.');
    }
  }
}