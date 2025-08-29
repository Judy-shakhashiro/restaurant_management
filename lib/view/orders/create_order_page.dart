import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/orders/checkout_controller.dart';
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

  final CheckoutController controller = Get.put(CheckoutController()); 

  @override
  void initState() {
    super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stack(
        children:[ Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
               decoration:  BoxDecoration(
                 color: Colors.grey.withAlpha(40),
                   borderRadius: BorderRadius.circular(10),
                  ),
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
                        border: Border.all( width: 1,color: Colors.grey.shade300),
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        value: controller.selectedOrderType.value,
                        underline: const SizedBox(),
                        isExpanded: true,
                        hint: Obx(()=> Text(controller.selectedOrderType.value, style: const TextStyle(fontSize: 20))),
                        items: controller.orderTypes.map<DropdownMenuItem<String>>((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(fontSize: 20, color:  Colors.black87),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            controller.selectedOrderType.value = newValue!;

                          });
                          // You can add additional logic here
                        },
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration:  BoxDecoration(
                  color: Colors.grey.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
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
                        border: Border.all( width: 1,color: Colors.grey.shade300),
                      ),
                      child: Obx(
                            () => DropdownButton<AddressInShort>( // Dropdown for saved addresses
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          value: controller.adController.selectedAddress.value, // Use reactive value from controller
                          underline: const SizedBox(),
                          isExpanded: true,
                          hint:  Text('${controller.adController.selectedAddress.value?.name ?? 'Select Address'}', style: TextStyle(fontSize: 20)), // Safely access name
                          items: controller.adController.addresses.map<DropdownMenuItem<AddressInShort>>((AddressInShort address) {
                            return DropdownMenuItem<AddressInShort>(
                              value: address,
                              child: Text(
                                address.name, // Use helper for display
                                style: TextStyle(fontSize: 20, color:  Colors.black87),
                              ),
                            );
                          }).toList(),
                          onChanged: (AddressInShort? newValue) {
                            if (newValue != null) {
                              controller.adController.selectedAddress.value = newValue;
                              controller.adController.fetchSelectedAddressDetails(newValue.id);
                            }
                          },
                          icon: const Icon(Icons.arrow_drop_down),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    // Display currently selected address details (optional)
                    Obx(() {
                      final selectedAddressData = controller.adController.selectedAddress.value;
                      final selectedDetails = controller.adController.selectedAddressDetails.value;

                      if (selectedAddressData != null && selectedDetails != null) {
                        final double latitude = double.tryParse(selectedDetails.latitude) ?? 0.0;
                        final double longitude = double.tryParse(selectedDetails.longitude) ?? 0.0;
                        final LatLng mapCenter = LatLng(latitude, longitude);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
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
                decoration:  BoxDecoration(
                  color: Colors.grey.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    IconButton(icon:Icon(Icons.edit,color: Colors.deepOrange,), onPressed: () {
                      showDeliveryInstructionsBottomSheet(
                        context: context,
                        // Pass initial values from _deliveryInstructions map
                        initialCallMe: controller.deliveryInstructions['call_me_when_reach'] ?? true,
                        initialNoDoorbell: controller.deliveryInstructions['do_not_ring_doorbell'] ?? false,
                        initialLeaveAtDoor: controller.deliveryInstructions['leave_order_at_door'] ?? false,
                        initialNote: controller.deliveryInstructions['additional_note'] ?? '',
                        onSubmit: (Map<String, dynamic> instructions) {
                          setState(() {
                            controller.deliveryInstructions.value = instructions; // Update state in parent widget
                          });
                          print('Final Delivery Instructions: $controller.deliveryInstructions');
                        },
                      );
                    }),
                  ],
                ),

              ),
              Obx(() {
               final List<Widget> instructionChips = [];
                if (controller.deliveryInstructions['call_me_when_reach'] == true) {
                  instructionChips.add(_buildInstructionChip('Call me when you reach'));
                }
                if (controller.deliveryInstructions['do_not_ring_doorbell'] == true) {
                  instructionChips.add(_buildInstructionChip('Please don\'t ring the doorbell'));
                }
                if (controller.deliveryInstructions['leave_order_at_door'] == true) {
                  instructionChips.add(_buildInstructionChip('Leave the order in front of the door'));
                }
                if (controller.deliveryInstructions['additional_note'] != null &&controller.deliveryInstructions['additional_note'].isNotEmpty) {
                  instructionChips.add(_buildInstructionChip('Note: ${controller.deliveryInstructions['additional_note']}'));
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
              const SizedBox(
              height: 20,
              ),
              Container(
                decoration:  BoxDecoration(
                  color: Colors.grey.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text('Pay With', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [Obx(()=>
                  GestureDetector(
                    onTap: (){

                      if(controller.isCash.value!=true){
                        controller.isCash.value=true;
                      }},
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width/2-40,
                      height: 110,
                      margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: controller.isCash.value?Colors.deepOrange:Colors.transparent ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Image.asset('assets/cash.png',width: 80,),
                    ),
                  ),
              ),
                Obx(()=>
                    GestureDetector(
                      onTap: (){
                        if(controller.isCash.value!=false){
                          controller.isCash.value=false;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width/2-40,
                        height: 110,
                        margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: !controller.isCash.value?Colors.deepOrange:Colors.transparent ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Image.asset('assets/ewallet.png'),
                      ),
                    ),
                )],),
              SizedBox(height: 20,),
              Container(
                decoration:  BoxDecoration(
                  color: Colors.grey.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text('Checkout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              Obx(() {
                if (controller.checkoutDetails.value == null) {
                  return const Center(child: CircularProgressIndicator()); // Show loading indicator
                }
                return Card(
                  margin: const EdgeInsets.all(12.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildRow("Items", "${controller.checkoutDetails.value!.itemsCount}"),
                        _buildRow("Price", "\$${controller.checkoutDetails.value!.price}"),
                        controller.checkoutDetails.value!.distance!=null?_buildRow("Distance", controller.checkoutDetails.value!.distance!):const SizedBox.shrink(),
                        _buildRow("Delivery Fees", "\$${controller.checkoutDetails.value!.deliveryFees}"),
                        controller.checkoutDetails.value!.estimatedDeliveryTime!=null?_buildRow("Estimated Time", controller.checkoutDetails.value!.estimatedDeliveryTime!):SizedBox.shrink(),
                        _buildRow("Discount", "-\$${controller.checkoutDetails.value!.discount}"),
                        const Divider(),
                        _buildRow("Total", "\$${controller.checkoutDetails.value!.totalPrice}", highlight: true),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 100,),
            ],
          ),
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
                  controller.placeOrder();
           Get.off(()=>MyHomePageScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 6,
                ),
                child:  const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Place Order',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'Georgia',fontSize: 20)
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

  void showDeliveryInstructionsBottomSheet({
    required BuildContext context,
    bool initialCallMe = false,
    bool initialNoDoorbell = false,
    bool initialLeaveAtDoor = false,
    String initialNote = '',
    required Function(Map<String, dynamic>) onSubmit,
  }) {

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
                      const Align(
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
  Widget _buildRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                  color: highlight ? Colors.green : Colors.black)),
        ],
      ),
    );
  }
}