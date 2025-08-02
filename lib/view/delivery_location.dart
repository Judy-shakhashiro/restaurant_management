// lib/view/delivery_location_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';
import '../controller/delivery_controller.dart'; // Import for Timer


class DeliveryLocationPage extends StatefulWidget {
  DeliveryLocationPage({Key? key}) : super(key: key);

  @override
  _DeliveryLocationPageState createState() => _DeliveryLocationPageState();
}

class _DeliveryLocationPageState extends State<DeliveryLocationPage> {
  final DeliveryController controller = Get.put(DeliveryController());
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    controller.setSearchController = _searchController;

    controller.selectedMapLocation.listen((LatLng? newLocation) {
      if (newLocation != null && _mapController != null) {
        // 3. When user tap on location to get to, keep the zoom level as it is and animate them to that location
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(newLocation), // Changed from newLatLngZoom to newLatLng
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Delivery Location'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              itemCount: controller.deliveryCategories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final category = controller.deliveryCategories[index];
                return Obx(() {
                  final isSelected = controller.selectedDeliveryIndex.value == index;
                  return Animate(
                    effects: const [
                      SlideEffect(
                        begin: Offset(0, 0.4),
                        end: Offset(0, 0),
                        duration: Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                      ),
                      FadeEffect(duration: Duration(milliseconds: 600))
                    ],
                    delay: Duration(milliseconds: index * 80),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          controller.selectDeliveryCategory(index);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFFE082), Color(0xFFFF7043)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected ? Colors.deepOrange.withOpacity(0.6) : Colors.black26,
                                    blurRadius: isSelected ? 10 : 6,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                                border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                              ),
                              child: Icon(
                                category['icon'],
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.deepOrange : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    controller.autocompletePredictions.clear();
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  controller.searchLocation(value);
                });
              },
              onSubmitted: (value) {
                if (controller.autocompletePredictions.isNotEmpty) {
                  controller.setSelectedLocationFromSearch(controller.autocompletePredictions.first);
                }
                FocusScope.of(context).unfocus();
              },
            ),
          ),

          Obx(() {
            if (controller.autocompletePredictions.isEmpty) {
              return const SizedBox.shrink();
            }
            return Expanded(
              child: ListView.builder(
                itemCount: controller.autocompletePredictions.length,
                itemBuilder: (context, index) {
                  final prediction = controller.autocompletePredictions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(prediction['description'] ?? 'Unknown'),
                    onTap: () {
                      controller.setSelectedLocationFromSearch(prediction);
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            );
          }),

          Expanded(
            flex: 3,
            child: Obx(() {
              if (controller.isLoadingLocation.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.selectedMapLocation.value == null) {
                return const Center(child: Text('Could not load map. Please check location permissions.'));
              }
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: controller.selectedMapLocation.value!,
                  zoom: 16.0,
                ),
                onMapCreated: (GoogleMapController mapController) {
                  _mapController = mapController;
                  controller.setGoogleMapController(_mapController!); // Pass controller to GetX controller

                  // Ensure map is ready and controller has its reference before updating location
                  if (controller.selectedMapLocation.value != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLng(controller.selectedMapLocation.value!),
                    );
                    // Trigger update location after map is ready and zoom is set
                    controller.updateSelectedLocation(controller.selectedMapLocation.value!);
                  }
                },
                onTap: (LatLng latLng) {
                  controller.updateSelectedLocation(latLng);
                },
                onCameraMove: (CameraPosition position) { // Listen to camera moves
                  controller.checkZoomLevel(); // Renamed function call
                },
                markers: {
                  if (controller.selectedMapLocation.value != null)
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: controller.selectedMapLocation.value!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        controller.isLocationCovered.value ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
                      ),
                      infoWindow: InfoWindow(title: controller.selectedAddress.value),
                    ),
                },
                polygons: controller.serviceAreaPolygons, // Add the service area polygons here
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              );
            }),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // New: Line to indicate fetching
                Obx(() => controller.isFetchingAddress.value
                    ? const LinearProgressIndicator(color: Colors.deepOrange)
                    : const SizedBox(height: 4)), // Keep height consistent

                const SizedBox(height: 8), // Add a small space after the indicator
                const Text(
                  'Set Location:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(
                      () => Text(
                    controller.selectedAddress.value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => Text(
                  controller.coverageMessage.value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: controller.isLocationCovered.value ? Colors.green.shade800 : Colors.red.shade700,
                  ),
                )),
                const SizedBox(height: 5),
                Obx(() => Text(
                  controller.zoomLevelMessage.value, // Display zoom level message
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: controller.isZoomedEnough.value && controller.hasDetailedAddress.value
                        ? Colors.transparent // Hidden if both good
                        : Colors.orange.shade700, // Warning color
                  ),
                )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    // Button enabled only if covered AND zoomed enough AND a location is selected
                    onPressed: (controller.isLocationCovered.value &&
                        controller.isZoomedEnough.value &&
                         !controller.isFetchingAddress.value&&// Added this condition back
                        controller.selectedMapLocation.value != null)
                        ? () {
                      controller.confirmLocation();
                    }
                        : null, // Disable button if not covered, not zoomed enough, or no location selected
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor: Colors.grey.shade400,
                      disabledForegroundColor: Colors.grey.shade700,
                    ),
                    child: Text(
                      (controller.isLocationCovered.value && controller.isZoomedEnough.value) // Simplified text logic
                          ? 'Confirm Location'
                          : controller.isZoomedEnough.value
                          ? 'Location Not Covered' // If zoomed but not covered
                          : 'Zoom In Required', // If not zoomed enough
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}