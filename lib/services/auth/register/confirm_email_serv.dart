import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/static/global_service.dart';
import '../../../core/static/routes.dart';
import '../../../model/auth/register/confirn_email_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ConfirmEmailServ{

  static Future<bool> confirm(String email,String OTP) async {
  try {
    final response = await http.post(
      Uri.parse(Linkapi.ConfirmEamilApi),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'OTP':OTP

        }),
    );

    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    final data = jsonDecode(response.body);
  print(OTP);
    if (response.statusCode == 200) {
      GlobalServ myServices = Get.put(GlobalServ());
      EmailConfirmModel model = EmailConfirmModel.fromJson(data);
      print('Success: ${model.message}');
      print('token: ${model.token}');
      myServices.removeToken();
      myServices.saveToken(model.token);
      myServices.getToken();
      Get.snackbar(
          'Success',
          '${model.message}',
          backgroundGradient: LinearGradient(colors: [Colors.yellow , Colors.white]),
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.face_retouching_natural_sharp,color: Colors.black,)
    );
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