import 'package:flutter/material.dart';
import '../../../core/static/global_service.dart';
import '../../../core/static/routes.dart';
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
<<<<<<< HEAD
          'Accept': 'application/json',
          'guest_token' : 'dfsgdfgdfsgerg',
          'Content-Type': 'application/json'
=======
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
>>>>>>> ae903d2a6fd5356e29e10c15c1e345e48ea0405f
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password' : password
        }),
       );

      if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      
      String? token = data['token']; 
      
      if (token != null) {
        final myServices = Get.find<GlobalServ>(); 
        print('Login Successful: ${data['message']}');
        myServices.removeToken();
        await myServices.saveToken(token); 
        print(myServices.getToken());
<<<<<<< HEAD
        print("نجاحححححح : ${response.body}");
        return true;
      } else {
        print('Error: Token not found in response');
        return false;
=======
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
>>>>>>> ae903d2a6fd5356e29e10c15c1e345e48ea0405f
      }
    } 
    else if (response.statusCode == 401) {
      final data = jsonDecode(response.body);
      print('Error: ${data['message']} ');
      Get.snackbar(
        'Alert',
        '${data['message']}',
        backgroundColor: Colors.red.shade500,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } 
    else {
      final data = jsonDecode(response.body);
      print('Unexpected error: ${response.statusCode} ${response.body}');
      print('message: ${data['message']}');
      Get.snackbar(
        'Alert',
        '${data['message']}',
        backgroundColor: Colors.red.shade500,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
  }}