import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/services/order_service.dart';
import 'package:get/get.dart';
import '../home_controller.dart';
import 'get_addresses_controller.dart';

class CheckoutController extends GetxController{
  final GetAddressesController adController = Get.find();
  Rxn<CheckoutDetails> checkoutDetails=Rxn<CheckoutDetails>(null);
  OrderService service=Get.put(OrderService());
  RxBool isCash=true.obs;
  final RxMap deliveryInstructions = {}.obs;
  final List<String> orderTypes = [
    'Delivery',
    'Pick Up',
  ];
  // Make selectedOrderType reactive
  RxString selectedOrderType=RxString('');
  @override
  void onInit() {
    if(selectedDeliveryIndex.value==0) {
      selectedOrderType = 'Delivery'.obs;
    }
    else{
      selectedOrderType = 'Pick Up'.obs;
    }
    getCheckoutDetails();
    ever(selectedOrderType, (_) {
      getCheckoutDetails();
    });
    ever(adController.selectedAddress, (_) {
      getCheckoutDetails();
    });
    super.onInit();
  }
  getCheckoutDetails() async {
   if (selectedOrderType.value == 'Delivery' && adController.selectedAddress.value == null) {
      checkoutDetails.value = null;
      return;
    }
    checkoutDetails.value=await service.getCheckoutDetails(selectedOrderType.value, adController.selectedAddress.value!.id);
  }
  Future<void> placeOrder() async {
    // You'll need to gather the actual values from your UI state
    final String receivingMethod = selectedOrderType.value; // 'Delivery' or 'Pick Up'
    final String paymentMethod = isCash.value ? 'cash' : 'wallet'; // Based on your RxBool
    final int? addressId = adController.selectedAddress.value?.id; // Get ID from selected address

    List<String> notes = [];
    if (deliveryInstructions['call_me_when_reach'] == true) {
      notes.add('اتصل عندما تصل');
    }
    if (deliveryInstructions['do_not_ring_doorbell'] == true) {
      notes.add('لا تقرع الجرس عند الوصول');
    }
    if (deliveryInstructions['additional_note'] != null && deliveryInstructions['additional_note'].isNotEmpty) {
      notes.add(deliveryInstructions['additional_note']);
    }

    if (receivingMethod == 'Delivery' && addressId == null) {
      Get.snackbar('Error', 'Please select an address for delivery.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    bool success = await service.createOrder(
      receivingMethod: receivingMethod.toLowerCase(), // Ensure 'delivery' or 'pick_up'
      paymentMethod: paymentMethod,
      orderNotes: notes.isEmpty ? null : notes, // Pass null if no notes, or the list
      addressId: addressId!, // Ensure it's not null if receivingMethod is 'delivery'
    );

    if (success) {
    } else {
      Get.snackbar('Error', 'Failed to create order. Please try again.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}