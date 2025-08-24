// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_restaurant/core/static/routes.dart';
// import 'package:flutter_application_restaurant/main.dart';
// import 'package:flutter_application_restaurant/model/profile_model.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class ApiResponse {
//   final bool status;
//   final int statusCode;
//   final String message;
//   final bool isSuccess;

//   ApiResponse({
//     required this.status,
//     required this.statusCode,
//     required this.message,
//     this.isSuccess = false
//   });

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       status: json['status'],
//       statusCode: json['status_code'],
//       message: json['message'],
//       isSuccess: json['status'] == 'success'
//     );
//   }
// }

// class profileServ {

// Future<ProfileResponse> getProfileData() async {
//   const String url = '${Linkapi.backUrl}/profile';
//   final Map<String, String> headers = {
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $token',
//   };

//   try {
//     final response = await http.get(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       if (response.body.isNotEmpty) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         return ProfileResponse.fromJson(responseData);
//       } else {
//         throw Exception('The response body is empty.');
//       }
//     } else {
//       String errorMessage = 'Failed to load profile data.';
//       try {
//         final Map<String, dynamic> errorData = json.decode(response.body);
//         if (errorData.containsKey('message')) {
//           errorMessage = errorData['message'];
//           print(errorMessage);
//         } else if (errorData.containsKey('error')) {
//           errorMessage = errorData['error'];
//           print(errorMessage);
//         }
//       } catch (e) {
//         errorMessage = 'Failed to load profile data. Status Code: ${response.statusCode}';
//       }
//       Get.snackbar(
//         'Alert',
//         errorMessage,
//         backgroundColor: Colors.red[500],
//         snackPosition: SnackPosition.BOTTOM,
//       );
      
//       throw Exception(errorMessage);
//     }
//   } catch (e) {
//     Get.snackbar(
//       'Error',
//       'Failed to connect to the server: ${e.toString()}',
//       backgroundColor: Colors.red[500],
//       snackPosition: SnackPosition.BOTTOM,
//     );
//     throw Exception('Failed to connect to the server: $e');
//   }
// }


// Future<ApiResponse> updateProfile({
//   required String firstName,
//   required String lastName,
//   String? mobile,
//   String? image,
//   String? birthdate,
// }) async {
//   final url = Uri.parse("${Linkapi.backUrl}/profile");

//   final response = await http.post(
//     url,
//     headers: {
//       "Authorization": "Bearer $token",
//       "Accept": "application/json",
//     },
//     body: jsonEncode({
//       "first_name": firstName,
//       "last_name": lastName,
//       "mobile": mobile,
//       "image": image,
//       "birthdate": birthdate,
//     }),
//   );

//   if (response.statusCode == 200||response.statusCode == 201) {
//     final Map<String, dynamic> responseData = json.decode(response.body);
//     return ApiResponse.fromJson(responseData);
//   } else {
//     throw Exception("فشل في تحديث البروفايل: ${response.body}");
//   }
// }


//   Future<ApiResponse> uploadProfileImage( File imageFile) async {
//    String url = '${Linkapi.backUrl}/profile/update-image';
//     final request = http.MultipartRequest('POST', Uri.parse(url));

//     request.headers.addAll({
//       'Authorization': 'Bearer $token',
//     });

//     request.files.add(await http.MultipartFile.fromPath(
//       'image',
//       imageFile.path,
//     ));

//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200||response.statusCode == 201) {
//         if (response.body.isNotEmpty) {
//           final Map<String, dynamic> responseData = json.decode(response.body);
//           return ApiResponse.fromJson(responseData);
//         } else {
//           throw Exception('The response body is empty.');
//         }
//       } else {
//         throw Exception('Failed to upload image. Status Code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to connect to the server: $e');
//     }
//   }
// }



// import 'dart:convert';
// import 'package:flutter_application_restaurant/core/static/routes.dart';
// import 'package:flutter_application_restaurant/main.dart';
// import 'package:flutter_application_restaurant/model/profile_model.dart';
// import 'package:http/http.dart' as http;


// class ProfileService {
//   static String baseUrl = "${Linkapi.backUrl}"; 

//   Future<ProfileResponse?> getProfile() async {
//     final url = Uri.parse("$baseUrl/profile");

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return ProfileResponse.fromJson(data);
//       } else {
//         print(" فشل في جلب البروفايل: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print(" خطأ أثناء الاتصال بالسيرفر: $e");
//       return null;
//     }
//   }



//   static Future<bool> updateProfile({
//     required String firstName,
//     required String lastName,
//     required String mobile,
//     required String? birthdate,
//   }) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/profile"),
//       headers: {
//         "Authorization": "Bearer $token",
//         "Accept": "application/json",
//       },
//       body: {
//         "first_name": firstName,
//         "last_name": lastName,
//         "mobile": mobile,
//         "birthdate": birthdate ?? "",
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data["status"] == true;
//     } else {
//       return false;
//     }
//   }

// }
