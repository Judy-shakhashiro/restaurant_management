
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../view/add_new_address.dart';

const String googlePlacesApiKey = 'AIzaSyD9zQQNoowad3i_Fycd6YrfbR2mfysHtnQ';
const double minZoomLevelForAddress = 16.0;

class DeliveryController extends GetxController {
  final RxInt selectedDeliveryIndex = 0.obs;
  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final Rx<LatLng?> selectedMapLocation = Rx<LatLng?>(null);
  final RxString selectedAddress = 'Fetching location...'.obs;
  final RxBool isLoadingLocation = true.obs;
  final RxBool isFetchingAddress = false.obs;
  final RxList<Map<String, dynamic>> autocompletePredictions = <Map<String, dynamic>>[].obs;

  final RxBool isLocationCovered = false.obs;
  final RxString coverageMessage = 'Checking coverage...'.obs;
  final RxBool isZoomedEnough = false.obs;
  final RxString zoomLevelMessage = ''.obs;
  final RxBool hasDetailedAddress = false.obs;

  GoogleMapController? _googleMapController;

  void setGoogleMapController(GoogleMapController controller) {
    _googleMapController = controller;
    checkZoomLevel();
  }

  final List<Map<String, dynamic>> deliveryCategories = [
    {'icon': Icons.delivery_dining, 'title': 'Delivery'},
    {'icon': Icons.fastfood, 'title': 'Pickup'},
    {'icon': Icons.restaurant_menu, 'title': 'Dine-in'},
  ];

  final List<List<LatLng>> _serviceAreaBoundaries = [
    [
      const LatLng(33.3, 36),
      const LatLng(33.512802, 36.4),
      const LatLng(33.512802, 36.8),
      const LatLng(33.8, 36.8),
      const LatLng(34, 35.8),
    ],
    [
      const LatLng(34.040, -118.260),
      const LatLng(34.040, -118.230),
      const LatLng(34.060, -118.230),
      const LatLng(34.060, -118.260),
    ],
  ];

  Set<Polygon> get serviceAreaPolygons {
    return _serviceAreaBoundaries.asMap().entries.map((entry) {
      int index = entry.key;
      List<LatLng> points = entry.value;
      return Polygon(
        polygonId: PolygonId('service_area_$index'),
        points: points,
        strokeColor: Colors.green.shade800,
        strokeWidth: 2,
        fillColor: Colors.green.shade500.withOpacity(0.2),
      );
    }).toSet();
  }


  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  void selectDeliveryCategory(int index) {
    selectedDeliveryIndex.value = index;
    if (deliveryCategories[index]['title'] != 'Delivery') {
      Get.back();
    }
  }

  Future<void> _determinePosition() async {
    isLoadingLocation.value = true;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Services Disabled', 'Please enable location services for the app.');
      isLoadingLocation.value = false;
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location Permission Denied', 'Location permissions are denied. Please grant permission in app settings.');
        isLoadingLocation.value = false;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Location Permission Permanently Denied', 'Location permissions are permanently denied, we cannot request permissions. Please enable in app settings.');
      isLoadingLocation.value = false;
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLocation.value = LatLng(position.latitude, position.longitude);
      selectedMapLocation.value = currentLocation.value;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_googleMapController != null && selectedMapLocation.value != null) {
          _googleMapController!.animateCamera(
            CameraUpdate.newLatLng(selectedMapLocation.value!),
          );
          updateSelectedLocation(selectedMapLocation.value!); // Trigger initial update after map is ready
        }
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
      selectedAddress.value = 'Could not get current location';
      coverageMessage.value = 'Could not determine coverage.';
      zoomLevelMessage.value = 'Cannot fetch address.';
      hasDetailedAddress.value = false;
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<void> checkZoomLevel() async {
    if (_googleMapController == null) {
      isZoomedEnough.value = false;
      zoomLevelMessage.value = 'Map not initialized.';
      return;
    }
    final zoom = await _googleMapController!.getZoomLevel();
    if (zoom >= minZoomLevelForAddress) {
      isZoomedEnough.value = true;
      zoomLevelMessage.value = '';
    } else {
      isZoomedEnough.value = false;
      zoomLevelMessage.value = 'Zoom in closer for precise address details.';
    }
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    isFetchingAddress.value = true;
    hasDetailedAddress.value = false;
    selectedAddress.value = 'Fetching address...';

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googlePlacesApiKey';

    try {
      print(url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the API call was successful and has results.
        if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
          // Get the first result's formatted address.
          final formattedAddress = data['results'][0]['formatted_address'];
          selectedAddress.value = formattedAddress ?? 'Address not found';
          hasDetailedAddress.value = formattedAddress != null;
        } else {
          // If no results or status is not 'OK', set a default message.
          selectedAddress.value = 'No address found for this location.';
          hasDetailedAddress.value = false;
        }
      } else {
        // Handle server errors.
        selectedAddress.value = 'Failed to fetch address. Server error.';
        hasDetailedAddress.value = false;
      }
    } catch (e) {
      // Handle network or parsing errors.
      selectedAddress.value = 'Failed to fetch address. Check network connection.';
      hasDetailedAddress.value = false;
      print('Error fetching address: $e');
    } finally {
      isFetchingAddress.value = false;
    }
  }

  void confirmLocation() {
    if (!isZoomedEnough.value) {
      Get.snackbar(
        'Zoom In Required',
        'Please zoom in closer on the map to get precise address details.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (!isLocationCovered.value) {
      Get.snackbar(
        'Delivery Not Available',
        'The chosen location is outside our service area.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedMapLocation.value == null) {
      Get.snackbar('Error', 'Please select a valid location first.');
      return;
    }

    // No longer block based on hasDetailedAddress.value.
    // Instead, issue a warning and proceed, letting AddNewAddressPage handle manual input.
    if (!hasDetailedAddress.value) {
      Get.snackbar(
        'Address Details Missing',
        'Could not get precise address details automatically. Please fill them manually.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }

    Get.to(() => AddNewAddressPage(
      selectedLocation: selectedMapLocation.value,
      selectedAddress: selectedAddress.value, initialArea: '', initialCity: '',
      // initialArea: fetchedArea, // Commented out as these were not used
      // initialCity: fetchedLocality, // Commented out as these were not used
    ));
  }

  // Changed _fetchedStreet to _fetchedLocality
  String _fetchedLocality = '';
  String _fetchedArea = '';

  String get fetchedLocality => _fetchedLocality; // New getter for locality (city)
  String get fetchedArea => _fetchedArea; // Area (sublocality)

  void updateSelectedLocation(LatLng latLng) {
    selectedMapLocation.value = latLng;
    getAddressFromLatLng(latLng);
    checkLocationCoverage(latLng);
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      autocompletePredictions.clear();
      return;
    }
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String requestUrl = '$baseUrl?input=$query&key=$googlePlacesApiKey';

    try {
      final response = await http.get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          autocompletePredictions.value = List<Map<String, dynamic>>.from(data['predictions']);
        } else {
          print("Places Autocomplete Error: ${data['status']} - ${data['error_message']}");
          autocompletePredictions.clear();
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        autocompletePredictions.clear();
      }
    } catch (e) {
      print("Error during autocomplete: $e");
      autocompletePredictions.clear();
    }
  }

  Future<void> setSelectedLocationFromSearch(Map<String, dynamic> prediction) async {
    final String? placeId = prediction['place_id'];
    if (placeId == null) return;

    const String detailsBaseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    final String requestUrl = '$detailsBaseUrl?place_id=$placeId&key=$googlePlacesApiKey';

    try {
      final response = await http.get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          final geometry = data['result']['geometry']['location'];
          final latLng = LatLng(geometry['lat'], geometry['lng']);
          updateSelectedLocation(latLng);
          autocompletePredictions.clear();
          _searchController.text = prediction['description'] ?? '';
        } else {
          Get.snackbar('Error', 'Could not get details for selected place.');
          print("Place Details Error: ${data['status']} - ${data['error_message']}");
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch place details.');
        print("HTTP Error fetching details: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to set location from search: $e');
      print("Error fetching place details: $e");
    }
  }

  late TextEditingController _searchController;
  set setSearchController(TextEditingController controller) {
    _searchController = controller;
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    bool isInside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      if (((polygon[i].longitude > point.longitude) != (polygon[j].longitude > point.longitude)) &&
          (point.latitude <
              (polygon[j].latitude - polygon[i].latitude) *
                  (point.longitude - polygon[i].longitude) /
                  (polygon[j].longitude - polygon[i].longitude) +
                  polygon[i].latitude)) {
        isInside = !isInside;
      }
    }
    return isInside;
  }

  void checkLocationCoverage(LatLng location) {
    bool covered = false;
    for (var polygonPoints in _serviceAreaBoundaries) {
      if (_isPointInPolygon(location, polygonPoints)) {
        covered = true;
        break;
      }
    }
    isLocationCovered.value = covered;
    coverageMessage.value = covered
        ? 'This area is covered for delivery.'
        : 'Delivery is not available in this area.';
  }


}