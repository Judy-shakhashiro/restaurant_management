// lib/view/add_new_address.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/address_service.dart';

class AddNewAddressPage extends StatefulWidget {
  final LatLng? selectedLocation;
  final String selectedAddress;
  final String initialArea;
  final String initialCity; // NEW: Added initialCity (locality)

  const AddNewAddressPage({
    Key? key,
    this.selectedLocation,
    required this.selectedAddress,
    required this.initialArea,
    required this.initialCity, // NEW: Required for initialCity
  }) : super(key: key);

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final AddressService _addressService = Get.put(AddressService()); // NEW: Get AddressService instance

  late TextEditingController _addressController;
  late TextEditingController _labelController; // NEW: Label field controller
  late TextEditingController _cityController; // City controller (locality)
  late TextEditingController _areaController; // Area controller (sublocality)
  late TextEditingController _streetController; // Street controller (manual)
  late TextEditingController _addressDetailsController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(
      text: 'full address'
       // text: widget.selectedAddress
    );
    _labelController = TextEditingController(); // Initialize label controller
    _cityController = TextEditingController(
       // text: widget.initialCity
      text: 'damascus'
    ); // Pre-fill with locality
    _areaController = TextEditingController(
      text: 'kafarsosa'
        //text: widget.initialArea
    ); // Pre-fill with sublocality
    _streetController = TextEditingController(); // Street is now manually filled
    _addressDetailsController = TextEditingController(
      text: 'provide clear address details to help the driver finds you easily ,building number,floor number',
    );
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _labelController.dispose(); // Dispose label controller
    _cityController.dispose();
    _areaController.dispose();
    _streetController.dispose();
    _addressDetailsController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
  Future<void> _saveAddressLocally(Map<String, dynamic> addressData) async {
    final prefs = await SharedPreferences.getInstance();
    // Get existing addresses or initialize an empty list
    final String? addressesString = prefs.getString('saved_addresses');
    List<Map<String, dynamic>> addresses = [];
    if (addressesString != null) {
      // Decode the string back into a List of Maps
      addresses = List<Map<String, dynamic>>.from(json.decode(addressesString));
    }

    // Add the new address data
    addresses.add(addressData);

    // Encode the updated list back to a string and save it
    await prefs.setString('saved_addresses', json.encode(addresses));
    print('Address saved locally to SharedPreferences!');
  }

  void _saveAddress() async { // Made async for API call
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ensure a location is selected before trying to save
      if (widget.selectedLocation == null) {
        Get.snackbar('Error', 'No location selected from map.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Collect all address data
      final Map<String, dynamic> addressData = {
        'latitude': widget.selectedLocation!.latitude,
        'longitude': widget.selectedLocation!.longitude,
        'name': 'StaticName', // Static for now
        'label': _labelController.text,
        'city': _cityController.text,
        'area': _areaController.text,
        'street': _streetController.text, // User-provided street
        'mobile': _phoneNumberController.text.isEmpty ? null : _phoneNumberController.text,
        'additional_details': _addressDetailsController.text == 'provide clear address details to help the driver finds you easily ,building number,floor number'
            ? null
            : _addressDetailsController.text,
      };
      final bool success = await _addressService.postAddress(
        latitude: widget.selectedLocation!.latitude,
        longitude: widget.selectedLocation!.longitude,
        name: _addressController.text, // As per your request, static for now
        label: _labelController.text,
        city: _cityController.text,
        area: _areaController.text,
        street: _streetController.text, // User-provided street
        mobile: _phoneNumberController.text.isEmpty ? null : _phoneNumberController.text,
        additionalDetails: _addressDetailsController.text == 'provide clear address details to help the driver finds you easily ,building number,floor number'
            ? null // Don't send default hint text if user didn't type
            : _addressDetailsController.text,
      );

      if (success) {
        await _saveAddressLocally(addressData);
        // Navigate back only on success
        Get.back(); // Go back to DeliveryLocationPage
        Get.back();

      }
    } else {
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Your Delivery Address',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 30),

              // Full Address (Read-only)
              _buildTextField(
                controller: _addressController,
                labelText: 'Full Address (From Map)',
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value == 'Unknown Location' || value == 'Error fetching address' || value == 'Zoom in for address details.') {
                    return 'Please select a valid location on the map.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // NEW: Label Field
              _buildTextField(
                controller: _labelController,
                labelText: 'Label (e.g., Home, Work, Friend\'s)',
                hintText: 'e.g., Home, Work',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Label is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // City (Locality) - Auto-filled
              _buildTextField(
                controller: _cityController,
                labelText: 'City (Locality)',
                hintText: 'e.g., Damascus, London',
                readOnly: true, // Auto-filled
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'City is required (Auto-filled).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Area (Sublocality) - Auto-filled
              _buildTextField(
                controller: _areaController,
                labelText: 'Area (Sublocality)',
                hintText: 'e.g., Old Town, City Center',
                readOnly: true, // Auto-filled
                validator: (value) {
                  if (value == null || value.isEmpty) {

                    return 'Area is required (Auto-filled).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Street - Manually filled
              _buildTextField(
                controller: _streetController,
                labelText: 'Street Name',
                hintText: 'e.g., Main Street, Oak Avenue',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Street is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Address Details
              _buildTextField(
                controller: _addressDetailsController,
                labelText: 'Address Details',
                hintText: 'Building number, floor number, etc.',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty || value == 'provide clear address details to help the driver finds you easily ,building number,floor number') {
                    return 'Please provide address details.';
                  }
                  return null;
                },
                onTap: () {
                  if (_addressDetailsController.text == 'provide clear address details to help the driver finds you easily ,building number,floor number') {
                    _addressDetailsController.clear();
                  }
                },
              ),
              const SizedBox(height: 20),

              // Phone Number (Optional)
              _buildTextField(
                controller: _phoneNumberController,
                labelText: 'Mobile Number (Optional)',
                hintText: 'e.g., +1234567890',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Save Address',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepOrange,
                    side: const BorderSide(color: Colors.deepOrange, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go Back to Map',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    bool readOnly = false,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}