import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/main.dart';
import '../../../core/static/global_service.dart';
import '../../../core/static/routes.dart';
import '../../../model/auth/register/confirn_email_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ConfirmEmailServ{

  static Future<bool> confirm(String email, String OTP) async {
    try {
      final response = await http.post(
        Uri.parse(Linkapi.ConfirmEamilApi),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', 
        },
        body: jsonEncode({
          'email': email,
          'OTP': OTP,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      final data = jsonDecode(response.body);
      print(OTP);

      if (response.statusCode == 200) {
        GlobalServ myServices = Get.find<GlobalServ>(); 
        EmailConfirmModel model = EmailConfirmModel.fromJson(data);
        String? token = data['token']; 
        
        if (token != null) {
          print('Success: ${model.message}');
          print('token: $token');
          await myServices.removeToken();
          await myServices.saveToken(token); 
          print('Saved Token: ${await myServices.getToken()}');
          return true;
        } else {
          print('Error: Token not found in response.');
          Get.snackbar(
            'Alert',
            'Token not found.',
            backgroundColor: Colors.red.shade500,
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      } else {
        print('Error Message: ${data['message']}');
        Get.snackbar(
          'Alert',
          '${data['message']}',
          backgroundColor: Colors.red.shade500,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}