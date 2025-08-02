
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// String baseUrlImage = 'http://10.0.2.2:8000';
// String baseUrl = 'http://10.0.2.2:8000/api'; ///// emulator

// String baseUrlImage = 'http://192.168.1.101:8000';
// String baseUrl = 'http://192.168.1.101:8000/api'; ///// mobilde

// String baseUrlImage = 'https://3b01-185-177-125-71.ngrok-free.app';
// String baseUrl = 'https://3b01-185-177-125-71.ngrok-free.app/api'; ///// server

class Api {
  Future<dynamic> get({
    required String url,
    @required String? token,
  }) async {
    Map<String, String> headers = {};
    // print("My token 2 :$userToken");
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
            print("tokennnnnn"+token);

    }
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    print('url= $url ,headrs=$headers');
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      print('url= $url ,headrs=$headers');
      print(data);
      return data;
    }
    // else if (response.statusCode == 404) {
    //   return [];
    // }
    else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'];
      print(message);
      throw message; ////////////////////////
    }
  }

  Future<dynamic> post({
    required String url,
    @required dynamic? body,
     String? token,  Map<String, String>? headers,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
                  print("tokennnnnn"+token);
    }

    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );

    print('url= $url ,body=$body ,headers=$headers',);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      //token = Response['token']; 
      
      return data;
    } else {
      // throw Exception(
      //   'there is a problem with status code ${response.statusCode}',
      // );
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'];
      throw message;
    }
  }

  Future<dynamic> postMultipart({
    required String url,
    required File imageFile,
    @required String? token,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Error: ${response.statusCode}, $responseBody');
    }
  }
}
