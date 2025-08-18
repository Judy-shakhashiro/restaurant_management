import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/delivery_controller.dart';

final DeliveryController controller = Get.put(DeliveryController());

class DeliveryLocationPage extends StatefulWidget {
  const DeliveryLocationPage({Key? key}) : super(key: key);

  @override
  _DeliveryLocationPageState createState() => _DeliveryLocationPageState();
}

class _DeliveryLocationPageState extends State<DeliveryLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    controller.setSearchController = _searchController;

    controller.selectedMapLocation.listen((LatLng? newLocation) {
      if (newLocation != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(newLocation),
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
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [

          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 12,
              right: 12,
            ),
            child: _buildCategoryRow(),
          ),
          Expanded(
            child: Stack(
              children: [
                Obx(() {
                  if (controller.isLoadingLocation.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.deepOrange,));
                  }
                  if (controller.selectedMapLocation.value == null) {
                    return const Center(
                      child: Text(
                        'Could not load map. Please check location permissions.',
                      ),
                    );
                  }
                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: controller.selectedMapLocation.value!,
                      zoom: 16.0,
                    ),
                    onMapCreated: (GoogleMapController mapController) {
                      _mapController = mapController;
                      controller.setGoogleMapController(_mapController!);
                    },
                    onTap: (LatLng latLng) {
                      controller.updateSelectedLocation(latLng);
                    },
                    onCameraMove: (_) => controller.checkZoomLevel(),
                    markers: {
                      if (controller.selectedMapLocation.value != null)
                        Marker(
                          markerId: const MarkerId('selectedLocation'),
                          position: controller.selectedMapLocation.value!,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            controller.isLocationCovered.value
                                ? BitmapDescriptor.hueGreen
                                : BitmapDescriptor.hueRed,
                          ),
                          infoWindow: InfoWindow(
                            title: controller.selectedAddress.value,
                          ),
                        ),
                    },
                    polygons: controller.serviceAreaPolygons,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  );
                }),
                Positioned(
                  top: 10,
                  left: 12,
                  right: 12,
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      Obx(() {
                        if (controller.autocompletePredictions.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 4),
                              )
                            ],
                          ),
                          constraints: const BoxConstraints(maxHeight: 250),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.autocompletePredictions.length,
                            itemBuilder: (context, index) {
                              final prediction =
                              controller.autocompletePredictions[index];
                              return ListTile(
                                leading: const Icon(Icons.location_on,
                                    color: Colors.deepOrange),
                                title: Text(
                                  prediction['description'] ?? 'Unknown',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  controller.setSelectedLocationFromSearch(
                                      prediction);
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        ).animate().fadeIn(duration: 250.ms);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _buildBottomSection(),
        ],
      ),
    );
  }


  Widget _buildCategoryRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        SizedBox(
          height: 120,
          width: 0.8*MediaQuery.of(context).size.width,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
            itemCount: controller.deliveryCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = controller.deliveryCategories[index];
              return Obx(() {
                final isSelected =
                    controller.selectedDeliveryIndex.value == index;
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () => controller.selectDeliveryCategory(index),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? Colors.deepOrange.withOpacity(0.6)
                                      : Colors.black26,
                                  blurRadius: isSelected ? 10 : 6,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                            ),
                            child: Icon(
                              category['icon'],
                              color: Colors.deepOrange,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category['title'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.deepOrange
                                  : Colors.black87,
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
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
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
          fillColor: Colors.white,
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
            controller.setSelectedLocationFromSearch(
                controller.autocompletePredictions.first);
          }
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => controller.isFetchingAddress.value
              ? const LinearProgressIndicator(color: Colors.deepOrange)
              : const SizedBox(height: 4)),
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
              color: controller.isLocationCovered.value
                  ? Colors.green.shade800
                  : Colors.red.shade700,
            ),
          )),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
              onPressed: (controller.isLocationCovered.value &&
                  controller.isZoomedEnough.value &&
                  !controller.isFetchingAddress.value &&
                  controller.selectedMapLocation.value != null)
                  ? () => controller.confirmLocation()
                  : null,
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
                (controller.isLocationCovered.value &&
                    controller.isZoomedEnough.value)
                    ? 'Confirm Location'
                    : controller.isZoomedEnough.value
                    ? 'Location Not Covered'
                    : 'Zoom In Required',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
