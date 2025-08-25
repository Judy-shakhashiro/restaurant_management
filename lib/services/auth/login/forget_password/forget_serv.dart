import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/static/global_service.dart';
import '../../../../core/static/routes.dart';
import '../../../../model/auth/login/forget_password/forget_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ForgetServ {
  static Future<bool> forget(String email) async {
    try {
      final response = await http.post(
        Uri.parse(Linkapi.ForgetPasswordApi),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final String? token = data['token'];

        if (token != null) {
          final myServices = Get.find<GlobalServ>();
          await myServices.saveToken(token);
          print('Token saved successfully!');
        } else {
          print('Error: Token not found in response.');
        }

        ForgetModel model = ForgetModel.fromJson(data);
        print('Success: ${model.message}');
        return true;
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