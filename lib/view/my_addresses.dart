import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/orders/delivery_location.dart';
import 'package:get/get.dart';
import '../../controller/orders/get_addresses_controller.dart';
import '../services/address_service.dart';


class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final GetAddressesController adController = Get.put(GetAddressesController());
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
  //  adController.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
      ),
      body: Obx(() {
        if (adController.addresses.isEmpty) {
          return const Center(child: Text('No addresses found. Add a new one!'));
        } else {
          return ListView.builder(
            itemCount: adController.addresses.length,
            itemBuilder: (context, index) {
              final address = adController.addresses[index];
              final isExpanded = index == _expandedIndex;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_expandedIndex == index) {
                        _expandedIndex = null;
                      } else {
                        _expandedIndex = index;
                        adController.fetchSelectedAddressDetails(address.id);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                address.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                _deleteAddress(context, address.id);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${address.street}, ${address.area}, ${address.city}',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (isExpanded)
                          _buildExpandedDetails(address),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
         Get.to(const DeliveryLocationPage());
        },
        label: const Text('Add New Address',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'Georgia',fontSize: 20),),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  Widget _buildExpandedDetails(AddressInShort address) {
    return Obx(() {
      final details = adController.selectedAddressDetails.value;
      if (details == null || details.id != address.id) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 20, thickness: 1),
          _buildDetailRow('Label:', details.label),
          _buildDetailRow('Additional Details:', details.additionalDetails ?? 'N/A'),
          _buildDetailRow('Mobile:', details.mobile??'No mobile provided'),
         _buildDetailRow('Is Deliverable:', details.is_deliverable.toString()),
        ],
      );
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _deleteAddress(BuildContext context, int addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () async {
              bool? success = await adController.service.deleteAddress(addressId);
              if (success!) {
                adController.loadAddresses();
                _expandedIndex = null;
              }
              adController.addresses.removeWhere((addr) => addr.id == addressId);
              _expandedIndex = null;
              Navigator.of(context).pop();
           },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
