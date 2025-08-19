import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/orders/get_addresses_controller.dart';
import '../../navigation_bar.dart';
import '../../services/address_service.dart';
import '../../services/order_service.dart';
import 'delivery_location.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {

  final GetAddressesController adController = Get.put(GetAddressesController()); // Initialize or find the controller
  RxBool isCash=true.obs;
  final RxMap _deliveryInstructions = {}.obs;
  final List<String> _orderTypes = [
    'Delivery',
    'Pick Up',
    'In Restaurant',
  ];
  late String _selectedOrderType;
  OrderService _orderService=OrderService();
  Future<void> _placeOrder() async {
    // You'll need to gather the actual values from your UI state
    final String receivingMethod = _selectedOrderType; // 'Delivery' or 'Pick Up'
    final String paymentMethod = isCash.value ? 'cash' : 'wallet'; // Based on your RxBool
    final int? addressId = adController.selectedAddress.value?.id; // Get ID from selected address

    List<String> notes = [];
    if (_deliveryInstructions['call_me_when_reach'] == true) {
      notes.add('اتصل عندما تصل');
    }
    if (_deliveryInstructions['do_not_ring_doorbell'] == true) {
      notes.add('لا تقرع الجرس عند الوصول');
    }
    if (_deliveryInstructions['additional_note'] != null && _deliveryInstructions['additional_note'].isNotEmpty) {
      notes.add(_deliveryInstructions['additional_note']);
    }

    if (receivingMethod == 'Delivery' && addressId == null) {
      Get.snackbar('Error', 'Please select an address for delivery.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    bool success = await _orderService.createOrder(
      receivingMethod: receivingMethod.toLowerCase(), // Ensure 'delivery' or 'pick_up'
      paymentMethod: paymentMethod,
      orderNotes: notes.isEmpty ? null : notes, // Pass null if no notes, or the list
      addressId: addressId!, // Ensure it's not null if receivingMethod is 'delivery'
    );

    if (success) {
      Get.snackbar('Success', 'Order created successfully!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      // Navigate to order confirmation page or clear cart
    } else {
      Get.snackbar('Error', 'Failed to create order. Please try again.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
  @override
  void initState() {
    super.initState();
    _selectedOrderType = _orderTypes[0]; // Set default order type
    // Load previously saved instructions for the bottom sheet
   }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Checkout'),
      ),
      body: Stack(
        children:[ ListView(
          children: [
            Container(
              color: Colors.grey.withAlpha(80),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Text(
                'Order type',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepOrange, width: 1),
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      value: _selectedOrderType,
                      underline: const SizedBox(),
                      isExpanded: true,
                      hint: const Text('Delivery', style: TextStyle(fontSize: 20, color: Colors.deepOrange)),
                      items: _orderTypes.map<DropdownMenuItem<String>>((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(fontSize: 20, color: _selectedOrderType == type ? Colors.deepOrange : Colors.black87),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOrderType = newValue!;
                        });
                        // You can add additional logic here
                      },
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.deepOrange),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey.withAlpha(80),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Text(
                'Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepOrange, width: 1),
                    ),
                    child: Obx(
                          () => DropdownButton<AddressInShort>( // Dropdown for saved addresses
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        value: adController.selectedAddress.value, // Use reactive value from controller
                        underline: const SizedBox(),
                        isExpanded: true,
                        hint:  Text('${adController.selectedAddress.value?.name ?? 'Select Address'}', style: TextStyle(fontSize: 20, color: Colors.deepOrange)), // Safely access name
                        items: adController.addresses.map<DropdownMenuItem<AddressInShort>>((AddressInShort address) {
                          return DropdownMenuItem<AddressInShort>(
                            value: address,
                            child: Text(
                              address.name, // Use helper for display
                              style: TextStyle(fontSize: 20, color: adController.selectedAddress.value == address ? Colors.deepOrange : Colors.black87),
                            ),
                          );
                        }).toList(),
                        onChanged: (AddressInShort? newValue) {
                          if (newValue != null) { // Only update if newValue is not null
                            adController.selectedAddress.value = newValue; // Update controller's selected address
                            adController.fetchSelectedAddressDetails(newValue.id);
                          }
                        },
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.deepOrange),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  // Display currently selected address details (optional)
                  Obx(() {
                    final selectedAddressData = adController.selectedAddress.value;
                    final selectedDetails = adController.selectedAddressDetails.value;

                    if (selectedAddressData != null && selectedDetails != null) {
                      final double latitude = double.tryParse(selectedDetails.latitude) ?? 0.0;
                      final double longitude = double.tryParse(selectedDetails.longitude) ?? 0.0;
                      final LatLng mapCenter = LatLng(latitude, longitude);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded( // Use Expanded to prevent overflow
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Label: ${selectedDetails.label}\n'
                                    'City: ${selectedAddressData.city}\n'
                                    'Area: ${selectedAddressData.area}\n'
                                    'Street: ${selectedAddressData.street}\n'
                                    'Additional details: ${selectedDetails.additionalDetails ?? 'لا يوجد'}\n',
                                style: const TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                            ),
                          ),
                          SizedBox(
                            height:140,
                            width:180,
                            child: GoogleMap(
                              key: ValueKey(mapCenter), // Use a key to force rebuild
                              markers: {
                                Marker(
                                  markerId: MarkerId('1'),
                                  position: mapCenter,
                                )
                              },
                              initialCameraPosition: CameraPosition(
                                zoom: 17.0,
                                target: mapCenter,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){Get.to(()=>DeliveryLocationPage());},
                    child: Text('Choose a new address',style: TextStyle(fontSize: 20,color: Colors.deepOrange),),)
                ],
              ),
            ),
            Container(
              color: Colors.grey.withAlpha(80),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  IconButton(icon:Icon(Icons.edit,color: Colors.deepOrange,), onPressed: () {
                    showDeliveryInstructionsBottomSheet(
                      context: context,
                      // Pass initial values from _deliveryInstructions map
                      initialCallMe: _deliveryInstructions['call_me_when_reach'] ?? true,
                      initialNoDoorbell: _deliveryInstructions['do_not_ring_doorbell'] ?? false,
                      initialLeaveAtDoor: _deliveryInstructions['leave_order_at_door'] ?? false,
                      initialNote: _deliveryInstructions['additional_note'] ?? '',
                      onSubmit: (Map<String, dynamic> instructions) {
                        setState(() {
                          _deliveryInstructions.value = instructions; // Update state in parent widget
                        });
                        print('Final Delivery Instructions: $_deliveryInstructions');
                      },
                    );
                  }),
                ],
              ),
            ),
            // Display the selected delivery instructions as chips/tags
            Obx(() { // Use Obx if _deliveryInstructions were in a GetX controller
              // For now, assuming _deliveryInstructions is local state, no Obx needed here.
              // If it's a global Map, you'd need a way to rebuild, or move it to a controller.
              final List<Widget> instructionChips = [];
              if (_deliveryInstructions['call_me_when_reach'] == true) {
                instructionChips.add(_buildInstructionChip('Call me when you reach'));
              }
              if (_deliveryInstructions['do_not_ring_doorbell'] == true) {
                instructionChips.add(_buildInstructionChip('Please don\'t ring the doorbell'));
              }
              if (_deliveryInstructions['leave_order_at_door'] == true) {
                instructionChips.add(_buildInstructionChip('Leave the order in front of the door'));
              }
              if (_deliveryInstructions['additional_note'] != null && _deliveryInstructions['additional_note'].isNotEmpty) {
                instructionChips.add(_buildInstructionChip('Note: ${_deliveryInstructions['additional_note']}'));
              }

              if (instructionChips.isNotEmpty) {
                return
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gap between lines
                      children: instructionChips,
                    ),
                  );
              }
              return const SizedBox.shrink();
            }),
            Container(
              color: Colors.grey.withAlpha(80),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Text('Pay With', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            Row(children: [Obx(()=>
                GestureDetector(
                  onTap: (){

                    if(isCash.value!=true){
                      isCash.value=true;
                    }},
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width/2-20,
                    height: 110,
                    margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: isCash.value?Colors.deepOrange:Colors.transparent ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Image.asset('images/cash.png',width: 80,),
                  ),
                ),
            ),
              Obx(()=>
                  GestureDetector(
                    onTap: (){
                      if(isCash.value!=false){
                        isCash.value=false;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width/2-20,
                      height: 110,
                      margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: !isCash.value?Colors.deepOrange:Colors.transparent ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Image.asset('images/ewallet.png'),
                    ),
                  ),
              )],), SizedBox(height: 100,),
          ],
        ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () {
           _placeOrder();
           Get.off(()=>MyHomePage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),],
      ),
    );
  }

  // Helper function to build a delivery instruction chip
  Widget _buildInstructionChip(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade500,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  // Helper widget to build a consistent checkbox row
  Widget _buildCheckbox({
    required String text,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(text, style: const TextStyle(fontSize: 16)),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading, // Checkbox on the left
      activeColor: Colors.deepOrange, // Color when checked
      checkColor: Colors.white, // Color of the checkmark
    );
  }

  /// Shows a modal bottom sheet for delivery instructions.
  /// Moved inside _CreateOrderPageState to access its StateSetter implicitly
  /// and manage its own state correctly.
  void showDeliveryInstructionsBottomSheet({
    required BuildContext context,
    bool initialCallMe = false,
    bool initialNoDoorbell = false,
    bool initialLeaveAtDoor = false,
    String initialNote = '',
    required Function(Map<String, dynamic>) onSubmit,
  }) {
    // These variables will now persist their state across rebuilds
    // within the StatefulBuilder's scope, as they are not re-initialized
    // on every `builder` call.
    bool _callMe = initialCallMe;
    bool _noDoorbell = initialNoDoorbell;
    bool _leaveAtDoor = initialLeaveAtDoor;
    TextEditingController _noteController = TextEditingController(text: initialNote);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return StatefulBuilder(

          builder: (BuildContext context, StateSetter setStateInBottomSheet) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),

                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Add Delivery Instructions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const Divider(height: 30, thickness: 1),

                      _buildCheckbox(
                        text: 'Call me when you reach',
                        value: _callMe, // Use the stateful variable
                        onChanged: (bool? newValue) {
                          setStateInBottomSheet(() { // Use the sheet's setState
                            _callMe = newValue ?? false;
                          });
                        },
                      ),
                      _buildCheckbox(
                        text: 'Please don\'t ring the doorbell',
                        value: _noDoorbell, // Use the stateful variable
                        onChanged: (bool? newValue) {
                          setStateInBottomSheet(() { // Use the sheet's setState
                            _noDoorbell = newValue ?? false;
                          });
                        },
                      ),
                      _buildCheckbox(
                        text: 'Leave the order in front of the door',
                        value: _leaveAtDoor, // Use the stateful variable
                        onChanged: (bool? newValue) {
                          setStateInBottomSheet(() { // Use the sheet's setState
                            _leaveAtDoor = newValue ?? false;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Additional notes (e.g., "blue door", "beware of dog")',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final Map<String, dynamic> instructions = {
                              'call_me_when_reach': _callMe, // Use final stateful variables
                              'do_not_ring_doorbell': _noDoorbell,
                              'leave_order_at_door': _leaveAtDoor,
                              'additional_note': _noteController.text.trim(),
                            };
                            onSubmit(instructions);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Submit Instructions',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}