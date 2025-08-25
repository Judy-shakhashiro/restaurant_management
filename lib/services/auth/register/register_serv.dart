import 'package:flutter/material.dart';
import '../../../core/static/routes.dart';
import '../../../model/auth/register/register_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterServ {

  static Future<bool> register(
    String first_name,
    String last_name,
    String mobile,
    String email,
    String password,
    String password_confirmation,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(Linkapi.RegisterApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'first_name': first_name,
          'last_name': last_name,
          'mobile': mobile,
          'email': email,
          'password': password,
          'password_confirmation': password_confirmation,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final registerModel = RegisterModel.fromJson(data);
        print(registerModel.message);
        print('objecttttttttttttt');
        return true;
      } else {
        final data = jsonDecode(response.body);
        print('Registration Error: ${data['message']}');
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
      Get.snackbar(
        'Alert',
        'Failed to connect to the server. Please check your network connection.',
        backgroundColor: Colors.red.shade500,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}