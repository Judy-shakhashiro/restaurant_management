// lib/controller/get_addresses_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../services/address_service.dart'; // For snackbar, if used

class GetAddressesController extends GetxController {
  // Reactive list to hold all saved addresses
  final RxList<Map<String, dynamic>> savedAddresses = <Map<String, dynamic>>[].obs;
  // Reactive variable for the currently selected address in the dropdown
  final Rx<Map<String, dynamic>?> selectedSavedAddress = Rx<Map<String, dynamic>?>(null);
  late  RxList<AddressInShort> addresses = <AddressInShort>[].obs;
  // Reactive variable for the currently selected address in the dropdown
  late final Rx<AddressInShort?> selectedAddress = Rx<AddressInShort?>(null);
  late bool addressesIsEmpty;
  Rx<Address?> selectedAddressDetails=Rx<Address?>(null);
  final AddressService service=AddressService();
  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }
  Future<void> loadAddresses() async{
    addresses.value=(await service.getAddresses())!;
    if(addresses.value.isNotEmpty){
      addressesIsEmpty=false;
    }
    selectedAddress.value=addresses[addresses.length-1];
    fetchSelectedAddressDetails(selectedAddress.value!.id);
  }
  // Asynchronous function to load addresses from SharedPreferences
  Future<void> loadSavedAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? addressesString = prefs.getString('saved_addresses');

      if (addressesString != null && addressesString.isNotEmpty) {
        // Decode the JSON string into a List of dynamic, then cast to List<Map<String, dynamic>>
        final List<dynamic> decodedList = json.decode(addressesString);
        savedAddresses.value = List<Map<String, dynamic>>.from(decodedList);

        if (savedAddresses.isNotEmpty) {
          // Set the default selected address to the last one saved
          selectedSavedAddress.value = savedAddresses.last;
          print("Loaded ${savedAddresses.length} addresses.");
          print("Default selected address label: ${selectedSavedAddress.value?['label']}");
        } else {
          selectedSavedAddress.value = null; // No addresses, clear selection
          print("No saved addresses found after decoding.");
        }
      } else {
        // No addresses found in SharedPreferences
        savedAddresses.value = [];
        selectedSavedAddress.value = null;
        print("No saved addresses string found in SharedPreferences.");
      }
    } catch (e) {
      // Handle any errors during loading/decoding
      print("Error loading saved addresses: $e");
      Get.snackbar(
        'Error',
        'Failed to load saved addresses: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchSelectedAddressDetails(int id) async {
 selectedAddressDetails.value=await service.getAddressById(id);
 print('ttttttttttttttttt${selectedAddressDetails.value!.area}');
 }

}