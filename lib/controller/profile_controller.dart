import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:flutter_application_restaurant/main.dart';
import 'package:flutter_application_restaurant/model/profile_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/profile_service.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool status;
  final int statusCode;
  final String message;

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
    );
  }
}


class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profile = Rxn<Profile>();
  var errorMessage = ''.obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final imageController = TextEditingController();
  final  birthdateController = TextEditingController();

  var birthdate = "".obs;

  final String baseUrl = "${Linkapi.backUrl}"; 
@override
  void onInit() {
    super.onInit();
    fetchProfile(); 
  }


  // -------- Get Profile --------
  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value='';
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final profileData = Profile.fromJson(data['profile_info']);
        profile.value = profileData;
        firstNameController.text = profileData.firstName;
        lastNameController.text = profileData.lastName;
        mobileController.text = profileData.mobile;
        birthdateController.text = profileData.birthdate ?? "";
      } else {
        final data = json.decode(response.body);
        errorMessage.value = data['message'] ?? "Failed to load profile";
        print('فشل : ${data["message"]}');
        Get.snackbar("Alert", errorMessage.value,backgroundColor: Colors.red[500],snackPosition: SnackPosition.BOTTOM,);

      }
    } catch (e) {
      errorMessage.value = "Failed to connect to the server: ${e.toString()}";
      print('فشل : ${errorMessage.value}');
      Get.snackbar("Alert", errorMessage.value,backgroundColor: Colors.red[500],snackPosition: SnackPosition.BOTTOM,);
    } finally {
      isLoading.value = false;
    }
  }

  // -------- Update Profile --------
  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "mobile": mobileController.text,
          "birthdate": birthdateController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == true) {
          await fetchProfile(); 
          print('نجاح : ${data["message"]}');
        } else {
          print('فشل : ${data["message"]}');
          Get.snackbar('Alert', data["message"], backgroundColor: Colors.red[500],snackPosition: SnackPosition.BOTTOM,);

        }
      } else {
        final data = json.decode(response.body);
        print('فشل : ${data["message"]}');
        Get.snackbar("Alert",data["message"],backgroundColor: Colors.red[500],snackPosition: SnackPosition.BOTTOM,);
      }
    } catch (e) {
      print('فشل : ${e.toString()}');
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

Future<void> pickDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
        colorScheme:const ColorScheme.light(
        primary: Colors.deepOrange, 
        onPrimary: Colors.white,
        onSurface: Colors.black,
          ),
        dialogBackgroundColor: Colors.white,
                        ),
       child: child!,
                      );
                    },
  );

  if (picked != null) {
    birthdateController.text = picked.toIso8601String().split("T")[0];
  }
}

  Future<ApiResponse> uploadProfileImage( File imageFile) async {
    final String url = '$baseUrl/profile/update-image';
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200||response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return ApiResponse.fromJson(responseData);
        } else {
          throw Exception('The response body is empty.');
        }
      } else {
        throw Exception('Failed to upload image. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> pickAndUploadImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final ApiResponse response = await uploadProfileImage(File(pickedImage.path));
      if (response.status) {
        await fetchProfile();
        print('نجاح : ${response.message}');
      } else {
        Get.snackbar('Error', response.message, backgroundColor: Colors.red[500],snackPosition: SnackPosition.BOTTOM,);
        print('فشل : ${response.message}');
      }

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to upload image: ${e.toString()}', backgroundColor: Colors.red[500],snackPosition: SnackPosition.BOTTOM,);
      print('Error uploading image: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
}