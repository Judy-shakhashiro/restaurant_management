import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/homepage_screen.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../navigation_bar.dart';
import '../../services/address_service.dart';

class AddNewAddressPage extends StatefulWidget {
  final LatLng? selectedLocation;
  final String selectedAddress;
  final String initialArea;
  final String initialCity;
  final String street;
  const AddNewAddressPage({
    Key? key,
    this.selectedLocation,
    required this.selectedAddress,
    required this.initialArea,
    required this.initialCity,
    required this.street,
  }) : super(key: key);

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final AddressService _addressService = Get.put(AddressService());

  late TextEditingController _addressController;
  late TextEditingController _labelController;
  late TextEditingController _cityController;
  late TextEditingController _areaController;
  late TextEditingController _streetController;
  late TextEditingController _addressDetailsController;
  late TextEditingController _phoneNumberController;

  bool _isSaving = false; // Add this state variable

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.selectedAddress);
    _labelController = TextEditingController();
    _cityController = TextEditingController(text: widget.initialCity);
    _areaController = TextEditingController(text: widget.initialArea);
    _streetController = TextEditingController(text: widget.street);
    _addressDetailsController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _labelController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _streetController.dispose();
    _addressDetailsController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveAddressLocally(Map<String, dynamic> addressData) async {
    final prefs = await SharedPreferences.getInstance();
    final String? addressesString = prefs.getString('saved_addresses');
    List<Map<String, dynamic>> addresses = [];
    if (addressesString != null) {
      addresses = List<Map<String, dynamic>>.from(json.decode(addressesString));
    }
    addresses.add(addressData);
    await prefs.setString('saved_addresses', json.encode(addresses));
    print('Address saved locally to SharedPreferences!');
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.selectedLocation == null) {
        Get.snackbar('Error', 'No location selected from map.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      setState(() {
        _isSaving = true; // Start loading
      });

      final Map<String, dynamic> addressData = {
        'latitude': widget.selectedLocation!.latitude,
        'longitude': widget.selectedLocation!.longitude,
        'name': 'StaticName',
        'label': _labelController.text,
        'city': _cityController.text,
        'area': _areaController.text,
        'street': _streetController.text,
        'mobile': _phoneNumberController.text.isEmpty ? null : _phoneNumberController.text,
        'additional_details': _addressDetailsController.text.isEmpty ? null : _addressDetailsController.text,
      };

      final bool success = await _addressService.postAddress(
        latitude: widget.selectedLocation!.latitude,
        longitude: widget.selectedLocation!.longitude,
        name: _addressController.text,
        label: _labelController.text,
        city: _cityController.text,
        area: _areaController.text,
        street: _streetController.text,
        mobile: _phoneNumberController.text.isEmpty ? null : _phoneNumberController.text,
        additionalDetails: _addressDetailsController.text.isEmpty ? null : _addressDetailsController.text,
      );

      if (success) {
        await _saveAddressLocally(addressData);
        Get.offAll(() => const MyHomePageScreen());
      } else {
        setState(() {
          _isSaving = false; // Stop loading on failure
        });
        Get.snackbar(
          'Error',
          'Failed to save address. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
      ),
      body: Stack(
        children: [
          // Main content of the page
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _addressController,
                    labelText: 'Full Address',
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == 'Unknown Location' || value == 'Error fetching address' || value == 'Zoom in for address details.') {
                        return 'Please select a valid location on the map.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _labelController,
                    labelText: 'Label',
                    hintText: 'e.g., Home, Work',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Label is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _cityController,
                    labelText: 'City',
                    hintText: 'e.g., Damascus, London',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'City is required (Auto-filled).';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _areaController,
                    labelText: 'Area',
                    hintText: 'e.g., Mezzah, Shagour',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Area is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _streetController,
                    labelText: 'Street Name',
                    hintText: 'e.g., Main Street, Ibn Asaker Street',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Street is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
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
                  _buildTextField(
                    controller: _phoneNumberController,
                    labelText: 'Mobile Number (Optional)',
                    hintText: 'e.g., 0991227770',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveAddress, // Disable button while saving
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
                ],
              ),
            ),
          ),
          // Loading Indicator Overlay
          if (_isSaving)
            const Opacity(
              opacity: 0.6,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (_isSaving)
            const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            ),
        ],
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
      cursorColor: Colors.deepOrange,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.grey),
        hoverColor: Colors.deepOrange,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.deepOrange),
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}