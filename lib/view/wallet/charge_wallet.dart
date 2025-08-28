import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChargeController extends GetxController {
  final Rx<File?> proofImage = Rx<File?>(null);
  final RxString transferMethod = ''.obs;
  final RxString amount = ''.obs;
  final RxString note = ''.obs;
  final RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  final String apiUrl = '${Linkapi.backUrl}/wallet/charge';
  final String userToken = '2|mLa89W0gpGq3akyINXE63zBy4e2DKeOV1WcB7QGOc4d75bfc';

  Future<void> pickProofImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      proofImage.value = File(image.path);
    }
  }


  Future<void> submitChargeRequest() async {
    if (proofImage.value == null || transferMethod.isEmpty || amount.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء ملء جميع الحقول المطلوبة.');
      return;
    }

    isLoading.value = true;
    try {
      final uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $userToken'
        ..fields['transfer_method'] = transferMethod.value
        ..fields['amount'] = amount.value
        ..fields['note'] = note.value
        ..files.add(await http.MultipartFile.fromPath(
          'proof_image',
          proofImage.value!.path,
        ));

      var response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar(
          'تم بنجاح',
          'تم إرسال طلب الشحن بنجاح، بانتظار الموافقة.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطأ',
          'فشل إرسال الطلب. رمز الخطأ: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}