import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_restaurant/controller/home_controller.dart';
import 'package:flutter_application_restaurant/core/static/global_lotti.dart';
import 'package:flutter_application_restaurant/view/widgets/top_categories.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_restaurant/controller/orders/delivery_controller.dart'; // Import your DeliveryController

class Branch {
  final String id;
  final String name;
  final String address;
  final double distance;
  final String imageUrl;
  final double latitude;
  final double longitude;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.latitude,
    required this.longitude,
    this.imageUrl = 'https://via.placeholder.com/150',
  });
}

class TakeawayController extends GetxController {
  final branchList = <Branch>[].obs;
  final isLoading = false.obs;
  final selectedBranchId = Rxn<String>();

  final Set<Marker> markers = <Marker>{}.obs;
  final Set<Polyline> polylines = <Polyline>{}.obs;
  final RxString travelTime = 'choose a branch'.obs;

  GoogleMapController? mapController;
  LatLng? userLocation;


  final String googleMapsApiKey = "AIzaSyD9zQQNoowad3i_Fycd6YrfbR2mfysHtnQ";

  final DeliveryController deliveryController = Get.put(DeliveryController());

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
    ever(deliveryController.currentLocation, (LatLng? location) {
      if (location != null) {
        userLocation = location;
        if (selectedBranchId.value != null) {
          _addMarkers();
          _getRouteAndTravelTime();
        }
      }
    });
  }

  void fetchBranches() async {
    isLoading.value = true;

    final branches = [
      Branch(id: '1', name: 'Pizza Hut - Damascus Branch', address: 'Omaya Street', distance: 2.5, latitude: 33.7136, longitude: 36.6753),
  ];
    branchList.value = branches;
    isLoading.value = false;
  }

  void selectBranch(String? id) {
    selectedBranchId.value = id;
    travelTime.value='calculating..';
    if (id != null && userLocation != null) {
      _addMarkers();
      _getRouteAndTravelTime();
    } else {
      markers.clear();
      polylines.clear();
    }
  }

  void _addMarkers() {
    if (userLocation == null) return;
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: userLocation!,
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    if (selectedBranchId.value != null) {
      final selectedBranch = branchList.firstWhere((branch) => branch.id == selectedBranchId.value);
      markers.add(
        Marker(
          markerId: const MarkerId('branch_location'),
          position: LatLng(selectedBranch.latitude, selectedBranch.longitude),
          infoWindow: InfoWindow(title: selectedBranch.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  Future<void> _getRouteAndTravelTime() async {
    if (userLocation == null || selectedBranchId.value == null) {
      polylines.clear();
      travelTime.value = 'Select a branch';
      return;
    }

    final selectedBranch = branchList.firstWhere((branch) => branch.id == selectedBranchId.value);

    PolylinePoints polylinePoints = PolylinePoints(apiKey: googleMapsApiKey);
    PolylineRequest polylineRequest = PolylineRequest(
      origin: PointLatLng(userLocation!.latitude, userLocation!.longitude),
      destination: PointLatLng(selectedBranch.latitude, selectedBranch.longitude),
      mode: TravelMode.driving,
    );
    PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(request: polylineRequest);

    polylines.clear();
    if (polylineResult.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = polylineResult.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route_to_branch'),
          color: Colors.deepOrange,
          points: polylineCoordinates,
          width: 5,
        ),
      );
    }

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${userLocation!.latitude},${userLocation!.longitude}&destination=${selectedBranch.latitude},${selectedBranch.longitude}&mode=driving&key=$googleMapsApiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final durationText = data['routes'][0]['legs'][0]['duration']['text'];
        travelTime.value = 'Estimated Driving Time: $durationText';
      } else {
        travelTime.value = 'Could not find a route.';
      }
    } else {
      travelTime.value = 'Error fetching travel time.';
    }

    // Animate camera to show both markers
    if (markers.length == 2) {
      LatLngBounds bounds = _boundsFromMarkers(markers.map((e) => e.position).toList());
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  LatLngBounds _boundsFromMarkers(List<LatLng> locations) {
    if (locations.isEmpty) return LatLngBounds(southwest: const LatLng(0, 0), northeast: const LatLng(0, 0));
    double minLat = locations[0].latitude;
    double maxLat = locations[0].latitude;
    double minLng = locations[0].longitude;
    double maxLng = locations[0].longitude;

    for (var latlng in locations) {
      if (latlng.latitude < minLat) minLat = latlng.latitude;
      if (latlng.latitude > maxLat) maxLat = latlng.latitude;
      if (latlng.longitude < minLng) minLng = latlng.longitude;
      if (latlng.longitude > maxLng) maxLng = latlng.longitude;
    }
    return LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
  }
}

class TakeawayAndMapPage extends StatefulWidget {
  const TakeawayAndMapPage({super.key});

  @override
  _TakeawayAndMapPageState createState() => _TakeawayAndMapPageState();
}

class _TakeawayAndMapPageState extends State<TakeawayAndMapPage> {
  final TakeawayController controller = Get.put(TakeawayController(), permanent: true);
  final HomeController homeController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 12,
                right: 12,
              ),
              child: buildCategoryRow(context,homeController),
            ),
            // Branch Selection Dropdown
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildBranchDropdown(),
            ),

            // Map View
            Expanded(
              child:
              Obx(() {
                if (controller.deliveryController.isLoadingLocation.value) {
                  return MyLottiLoading();
                }
                if (controller.deliveryController.selectedMapLocation.value == null) {
                  return const Center(
                    child: Text(
                      'Could not load map. Please check location permissions.',
                    ),
                  );
                }
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: controller.userLocation!,
                    zoom: 12,
                  ),
                  onMapCreated: (GoogleMapController mapController) {
                    controller.mapController = mapController;
                  },
                  markers: controller.markers,
                  polylines: controller.polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                );
              }),
            ),

            // Travel Time Info at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Animate(
                effects: const [
                  FadeEffect(duration: Duration(milliseconds: 500)),
                  SlideEffect(
                    begin: Offset(0, 0.2),
                    end: Offset(0, 0),
                    duration: Duration(milliseconds: 500),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Obx(
                          () => Text(
                        controller.travelTime.value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));

  }

  Widget _buildBranchDropdown() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Select a Branch'),
            value: controller.selectedBranchId.value,
            items: controller.branchList.map((branch) {
              return DropdownMenuItem<String>(
                value: branch.id,
                child: Text('${branch.name} - ${branch.address}'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              controller.selectBranch(newValue);
            },
          ),
        ),
      );
    });
  }
}