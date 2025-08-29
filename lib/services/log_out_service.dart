import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/global_service.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/view/auth/active_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<void> logout_service() async {
  try {
    final GlobalServ myServices = Get.find<GlobalServ>();
  //  final String? token = myServices.sharedPreferences?.getString('token');
    if (token == null) {
      _showSnackbar("Alert", "Token not found.");
      Get.offAll(() =>  ActiveLogin());
      return;
    }
    final response = await http.post(
      Uri.parse("${Linkapi.backUrl}/logout"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String? message = data['message'];
      if (data['status'] == true) {
        _showSnackbar("Success", message ?? "تم تسجيل الخروج بنجاح");
        await myServices.removeToken();
        Get.offAll(() =>  ActiveLogin());
      } else {
        _showSnackbar("Alert", message ?? "فشل تسجيل الخروج");
      }
    } else {
      final data = json.decode(response.body);
      _showSnackbar("Alert", data['message'] ?? "حدث خطأ في الخادم.");
    }
  } catch (e) {
    print("Logout Error: ${e.toString()}");
    _showSnackbar("Alert", "فشل الاتصال بالخادم: ${e.toString()}");
  }
}

void _showSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: (title == "Success") ? Colors.green[500] : Colors.red[500],
    snackPosition: SnackPosition.BOTTOM,
  );
}