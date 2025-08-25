import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/static/global_service.dart';
import '../../../../core/static/routes.dart';
import '../../../../model/auth/login/forget_password/verify_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// The corrected `VerifyServ` class
class VerifyServ {

  static Future<bool> verify(String email,String OTP) async {
    try {
      final response = await http.post(
        Uri.parse(Linkapi.verificationApi),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
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
        final myServices = Get.find<GlobalServ>();
        VerifyModel model = VerifyModel.fromJson(data);

        // ✅ Extract the token from the response data
        String? token = data['token'];

        if (token != null) {
            print('Success: ${model.message}');
            print('token: ${model.token}');
            await myServices.removeToken();
            await myServices.saveToken(token); // ✅ Use the extracted token here
            print(token);
            return true;
        } else {
             print('Error: Token not found in response');
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