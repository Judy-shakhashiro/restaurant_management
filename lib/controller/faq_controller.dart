import 'dart:convert';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/faq_model.dart';

class FaqController extends GetxController {
  // Reactive list to hold the FAQs. Observers will automatically rebuild when this list changes.
  final RxList<Faq> faqs = <Faq>[].obs;

  // Reactive boolean for managing the loading state.
  final RxBool isLoading = true.obs;

  // Reactive string for managing potential error messages.
  final RxString errorMessage = ''.obs;

  // This method is called automatically when the controller is initialized.
  @override
  void onInit() {
    super.onInit();
    fetchFaqs(); // Start fetching FAQs as soon as the controller is ready.
  }

  // Asynchronous function to fetch the FAQ data from the API with retry logic.
  Future<void> fetchFaqs() async {

    const apiUrl = '${Linkapi.backUrl}/faqs';

    const maxRetries = 3;

    const retryDelay = 3;

    // Set loading state to true and clear any previous error messages.
    isLoading.value = true;
    errorMessage.value = '';

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await http.get(Uri.parse(apiUrl),headers: <String,String>{    'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Content-Type':'application/json; charset=UTF-8'});

        if (response.statusCode == 200) {
          // Success: parse the data and update the faqs list.
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          final FaqsResponse faqsResponse = FaqsResponse.fromJson(jsonResponse);
          faqs.assignAll(faqsResponse.faqs);
          // If successful, break the loop and exit the method.
          errorMessage.value = '';
          isLoading.value=false;
          return;
        } else {
          errorMessage.value = 'Failed to load data. Status code: ${response.statusCode} (Attempt $attempt of $maxRetries)';
        }
      } catch (e) {
        // Catch any exceptions (e.g., network issues) and update the error message.
        errorMessage.value = 'Network error: $e (Attempt $attempt of $maxRetries)';
      }

      // If this is not the last attempt, wait before retrying.
      if (attempt < maxRetries) {
        await Future.delayed(const Duration(seconds: retryDelay));
      }
    }

    // If all attempts fail, update the error message for the user.
    errorMessage.value = 'Could not load FAQs after $maxRetries attempts. Please try again later.';

    // Ensure the loading state is turned off.
    isLoading.value = false;
  }
}
