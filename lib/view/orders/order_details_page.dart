// lib/view/order_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/global_lotti.dart';
import 'package:flutter_map/flutter_map.dart' as lat_long2;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as lat_long2;

import '../../controller/orders/order_details_controller.dart';
import '../../services/order_service.dart';

class OrderDetailPage extends StatelessWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final OrderDetailController orderDetailController = Get.put(OrderDetailController(orderId: orderId));
    bool? isCancelled;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Obx(() {
        if (orderDetailController.isLoading.value) {
          return const MyLottiLoading();
        } else if (orderDetailController.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Please try again', style: TextStyle(fontSize: 18, color: Colors.red)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => orderDetailController.fetchOrderDetail(orderId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (orderDetailController.orderDetail.value == null) {
          return const MyLottiNodata();
        } else {
          final OrderDetail order = orderDetailController.orderDetail.value!;
          bool isCancelled =orderDetailController.orderDetail.value!.status=='cancelled'?true:false;

          // Nullable customer and driver locations
          LatLng? customerLocation;
          if (order.address?.longitude != null &&
              double.tryParse(order.address!.latitude!) != null &&
              double.tryParse(order.address!.longitude!) != null) {
            customerLocation = LatLng(
              double.parse(order.address!.latitude!),
              double.parse(order.address!.longitude!),
            );
          }

          LatLng? driverLocation;
          if (order.address?.driverLatitude != null &&
              order.address?.driverLongitude != null &&
              double.tryParse(order.address!.driverLatitude!) != null &&
              double.tryParse(order.address!.driverLongitude!) != null) {
            driverLocation = LatLng(
              double.parse(order.address!.driverLatitude!),
              double.parse(order.address!.driverLongitude!),
            );
          }


          Set<Marker> markers = {};
          if (customerLocation != null && customerLocation.latitude != 0.0 && customerLocation.longitude != 0.0) {
            markers.add(
              Marker(
                markerId: const MarkerId('customerLocation'),
                position: customerLocation,
                infoWindow: InfoWindow(title: 'My Location: ${order.address?.name ?? 'N/A'}'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Customer marker
              ),
            );
          }

          if (driverLocation != null && driverLocation.latitude != 0.0 && driverLocation.longitude != 0.0) {
            markers.add(
              Marker(
                markerId: const MarkerId('driverLocation'),
                position: driverLocation,
                infoWindow: const InfoWindow(title: 'Driver'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Driver marker
              ),
            );
          }

          // Define the polyline for the delivery route
          Set<Polyline> polylines = {};
          if (driverLocation != null && customerLocation != null && customerLocation.latitude != 0.0 && customerLocation.longitude != 0.0 && driverLocation.latitude != 0.0 && driverLocation.longitude != 0.0) {
            polylines.add(
              Polyline(
                polylineId: const PolylineId('deliveryRoute'),
                points: [driverLocation, customerLocation],
                color: Colors.deepOrange,
                width: 4,
              ),
            );
          }

          // Calculate bounds to show both markers
          CameraPosition initialCameraPosition;
          if (customerLocation != null && customerLocation.latitude != 0.0 && customerLocation.longitude != 0.0) {
            if (driverLocation != null && driverLocation.latitude != 0.0 && driverLocation.longitude != 0.0) {
              final lat_long2.LatLngBounds bounds = lat_long2.LatLngBounds.fromPoints([
                lat_long2.LatLng(customerLocation.latitude, customerLocation.longitude),
                lat_long2.LatLng(driverLocation.latitude, driverLocation.longitude),
              ]);
              final centerLat = (bounds.northWest.latitude + bounds.southEast.latitude) / 2;
              final centerLng = (bounds.northWest.longitude + bounds.southEast.longitude) / 2;
              initialCameraPosition = CameraPosition(
                target: LatLng(centerLat, centerLng),
                zoom: 14.0,
              );
            } else {
              initialCameraPosition = CameraPosition(
                target: customerLocation,
                zoom: 15.0,
              );
            }
          } else {
            initialCameraPosition = const CameraPosition(
              target: LatLng(0, 0),
              zoom: 2.0,
            );
          }


          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Order Status Flow (Moved to top)
                _buildSectionTitle('Order Progress'),
                _buildOrderStatusFlow(isCancelled,order.status, order.receivingMethod, order.id, orderDetailController),
                const SizedBox(height: 16),

                // 2. Map (Conditional rendering)
                if (order.receivingMethod.toLowerCase() == 'delivery' && order.address != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Address :', order.address!.name),
                      customerLocation?.latitude!=null?SizedBox(
                        height: 250, // Height for the map
                        width: double.infinity,
                        child: GoogleMap(
                          key: ValueKey('${customerLocation?.latitude ?? ''}-${customerLocation?.longitude ?? ''}-${driverLocation?.latitude ?? ''}-${driverLocation?.longitude ?? ''}'), // Key to force map rebuild
                          initialCameraPosition: initialCameraPosition,
                          markers: markers,
                          polylines: polylines,
                          onMapCreated: (GoogleMapController mapController) {
                            if (customerLocation != null && customerLocation.latitude != 0.0 && customerLocation.longitude != 0.0) {
                              if (driverLocation != null && driverLocation.latitude != 0.0 && driverLocation.longitude != 0.0) {
                                final lat_long2.LatLngBounds bounds = lat_long2.LatLngBounds.fromPoints([
                                  lat_long2.LatLng(customerLocation.latitude, customerLocation.longitude),
                                  lat_long2.LatLng(driverLocation.latitude, driverLocation.longitude),
                                ]);
                                mapController.animateCamera(CameraUpdate.newLatLngBounds(
                                  LatLngBounds(
                                    southwest: LatLng(bounds.southWest.latitude, bounds.southWest.longitude),
                                    northeast: LatLng(bounds.northEast.latitude, bounds.northEast.longitude),
                                  ),
                                  50, // padding
                                ));
                              } else {
                                mapController.animateCamera(CameraUpdate.newLatLngZoom(customerLocation, 15.0));
                              }
                            }
                          },
                        ),
                      ):SizedBox.shrink(),
                      const SizedBox(height: 16),
                    ],
                  ),


                // Other sections remain below the map
                _buildSectionTitle('Order Information'),
                _buildInfoRow('Order Number:', order.orderNumber),
                _buildInfoRow('Status:', order.status),
                _buildInfoRow('Method:', order.receivingMethod),
                _buildInfoRow('Payment:', order.paymentMethod),
                _buildInfoRow('Created At:', order.createdAt),
                _buildInfoRow('Estimated Arrival:', order.estimatedReceivingTime),
                _buildInfoRow('Items Count:', order.itemsCount.toString()),
                const SizedBox(height: 16),
                const Divider(color: Colors.grey),
                _buildSectionTitle('Price Details'),
                _buildInfoRow('Total Price:', '\$${order.totalPrice}'),
                _buildInfoRow('Delivery Fee:', '\$${order.deliveryFee}'),
                _buildInfoRow('Discount:', '\$${order.discount}'),
                _buildInfoRow('Final Price:', '\$${order.finalPrice}', isBold: true, color: Colors.deepOrange),
                const SizedBox(height: 16),
                const Divider(color: Colors.grey),

                _buildSectionTitle('Order Items'),
                if (order.items.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final OrderItem item = order.items[index];
                      return Card(
                        color: Colors.deepOrange.withAlpha(40),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.name} x${item.quantity}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              if (item.selectedAdditionalOptions != null && item.selectedAdditionalOptions!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text('Options: ${item.selectedAdditionalOptions}'),
                                ),
                              _buildInfoRow('Base Price:', '\$${item.basePrice}'),
                              _buildInfoRow('Extra Price:', '\$${item.extraPrice}'),
                              _buildInfoRow('Item Total:', '\$${item.totalPrice}', isBold: true),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                if (order.items.isEmpty)
                  const Text('No items found for this order.', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modified Widget: Order Status Flow to include actions for canceled/deletable orders
  Widget _buildOrderStatusFlow(bool isCancelled,String currentStatus, String receivingMethod, int orderId, OrderDetailController controller) {
    List<String> deliveryFlow = [
      !isCancelled ?'Order Placed':'Cancelled',
      'Preparation Underway',
      'Out for Delivery',
      'Delivered',
    ];
    List<String> pickupFlow = [
      !isCancelled ?'Order Placed':'Cancelled',
      'Preparation Underway',
      'Ready for Pickup',
      'Picked Up',
    ];
    List<String> dineInFlow = [
      !isCancelled ?'Order Placed':'Cancelled',
      'Preparation Underway',
      'Ready for Table',
      'Completed',
    ];

    List<String> flowSteps;
    int activeStep = 0;
    bool isCanceled = currentStatus.toLowerCase() == 'canceled';

    if (isCanceled) {
      flowSteps = ['Order Canceled']; // Only display this step for canceled orders
      activeStep = 0;
    } else {
      switch (receivingMethod.toLowerCase()) {
        case 'delivery':
          flowSteps = deliveryFlow;
          switch (currentStatus.toLowerCase()) {
            case 'pending':
              activeStep = 0;
              break;
            case 'preparing':
              activeStep = 1;
              break;
            case 'delivering':
              activeStep = 2;
              break;
            case 'delivered':
              activeStep = 3;
              break;
            default:
              activeStep = 0;
          }
          break;
        case 'pick up':
          flowSteps = pickupFlow;
          switch (currentStatus.toLowerCase()) {
            case 'pending':
              activeStep = 0;
              break;
            case 'preparing':
              activeStep = 1;
              break;
            case 'ready for pickup':
              activeStep = 2;
              break;
            case 'picked up':
              activeStep = 3;
              break;
            default:
              activeStep = 0;
          }
          break;
        case 'in restaurant':
          flowSteps = dineInFlow;
          switch (currentStatus.toLowerCase()) {
            case 'pending':
              activeStep = 0;
              break;
            case 'preparing':
              activeStep = 1;
              break;
            case 'ready for table':
              activeStep = 2;
              break;
            case 'completed':
              activeStep = 3;
              break;
            default:
              activeStep = 0;
          }
          break;
        default:
          flowSteps = ['Status: $currentStatus'];
          activeStep = 0;
      }
    }

    return Column(
      children: [
        ...List.generate(flowSteps.length, (index) {
          bool isActive = index <= activeStep;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.radio_button_off,
                      color: isActive ? Colors.deepOrange : Colors.grey,
                      size: 24,
                    ),
                    if (index < flowSteps.length - 1 && !isCanceled)
                      const Text('|', style: TextStyle(fontSize: 25, color: Colors.grey)),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    flowSteps[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isActive ? Colors.black87 : Colors.grey,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        // Action buttons based on status
        if (isCanceled)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Reorder button removed
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.deleteCurrentOrder(); // Calls delete with confirmation
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Permanently'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          )
        else if (currentStatus.toLowerCase() == 'pending')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.cancelCurrentOrder(); // Calls cancel with confirmation
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.deleteCurrentOrder(); // Calls delete with confirmation
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Permanently'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}