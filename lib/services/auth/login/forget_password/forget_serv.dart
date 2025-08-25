import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/static/global_service.dart';
import '../../../../core/static/routes.dart';
import '../../../../model/auth/login/forget_password/forget_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgetServ{

  static Future<bool> forget(String email) async {
  try {
    final response = await http.post(
      Uri.parse(Linkapi.ForgetPasswordApi),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email}),
    );

    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ForgetModel model = ForgetModel.fromJson(data);
      GlobalServ myServices = Get.put(GlobalServ());
      print('Success: ${model.message}');
    //  myServices.removeToken();

      return true;
    } else {
      print('Error Message: ${data['message']}');
      Get.snackbar(
          'Failed',
          '${data['message']}',
          backgroundGradient: LinearGradient(colors: [Colors.red, Colors.white]),
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