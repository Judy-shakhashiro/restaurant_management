import 'package:flutter/material.dart';
import '../../../core/static/global_service.dart';
import '../../../core/static/routes.dart';
import '../../../model/auth/login/login_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginServ{

  static Future<bool> login(String email, String password) async {

    try {

      final response = await http.post(
        Uri.parse(Linkapi.LoginApi) ,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password' : password
        }),
       );

      if (response.statusCode == 200) {
         Map<String, dynamic> data = jsonDecode(response.body);
        LoginModel authResponse = LoginModel.fromJson(data);
        final myServices = Get.find<GlobalServ>(); 
        print('Login Successful: ${data['message']}');
        myServices.removeToken();
        await myServices.saveToken(authResponse.token);
        print(myServices.getToken());
        Get.snackbar(
          'Success',
          '${authResponse.message}',
          backgroundGradient: LinearGradient(colors: [Colors.yellow , Colors.white]),
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.face_retouching_natural_sharp,color: Colors.black,)
    );
    return true;
      } 
      else if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        print('Error: ${data['message']}');
        Get.snackbar(
          'Failed',
          '${data['message']}',
          backgroundGradient: LinearGradient(colors: [Colors.red, Colors.white]),
          snackPosition: SnackPosition.BOTTOM,
    ); return false;
      } 
      else {
        final data = jsonDecode(response.body);
        print('Unexpected error: ${response.statusCode}');
        print('message: ${data['message']}');
        Get.snackbar(
          'Failed',
          '${data['message']}',
          backgroundGradient: LinearGradient(colors: [Colors.red, Colors.white]),
          snackPosition: SnackPosition.BOTTOM,
    ); return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  
}