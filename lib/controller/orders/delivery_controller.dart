import 'package:flutter_application_restaurant/controller/home_controller.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../view/orders/add_new_address.dart';

const String googlePlacesApiKey = 'AIzaSyD9zQQNoowad3i_Fycd6YrfbR2mfysHtnQ';
const double minZoomLevelForAddress = 16.0;

class DeliveryController extends GetxController {
HomeController homeController =Get.put(HomeController());
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


  late List<List<LatLng>> _serviceAreaBoundaries ;
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
    determinePosition();
    checkLocationCoverage(currentLocation.value);
    getDeliveryZones();
  }
  void getDeliveryZones()async{
    var url='${Linkapi.backUrl}/zones';
    var response=await http.get(Uri.parse(url),
    headers: <String,String>{
      'Accept': 'application/json',
      'Content-Type':'application/json'
    });
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      final List<dynamic> deliveryZones = parsed['delivery_zones'];
      List<List<LatLng>> newBoundaries = [];
      for (var zone in deliveryZones) {
        List<LatLng> zoneCoordinates = [];
        List<dynamic> coordinates = zone['coordinates'];
        for (var coord in coordinates) {
          zoneCoordinates.add(LatLng(coord['lat'], coord['lng']));
        }
        newBoundaries.add(zoneCoordinates);
      }
      _serviceAreaBoundaries = newBoundaries;
      print("Service areas updated successfully.");
      print(_serviceAreaBoundaries);
    } else {
      throw Exception('Failed to load dishes');
    }
  }


  Future<void> determinePosition() async {
    isLoadingLocation.value = true;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      Get.snackbar(
        snackPosition: SnackPosition.BOTTOM,
          'Location Services Disabled', 'Please enable location services for the app.');
      isLoadingLocation.value = false;
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
            'Location Permission Denied', 'Location permissions are denied. Please grant permission in app settings.');
        isLoadingLocation.value = false;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(snackPosition: SnackPosition.BOTTOM,
          'Location Permission Permanently Denied', 'Location permissions are permanently denied, we cannot request permissions. Please enable in app settings.');
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
      Get.snackbar(snackPosition: SnackPosition.BOTTOM,
          'Error', 'Failed to get current location: $e');
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
    _fetchedStreet = '';
    _fetchedArea = '';
    _fetchedLocality = '';

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$googlePlacesApiKey';

    try {
      print(url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the API call was successful and has results.
        if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
          final components = data['results'][0]['address_components'] as List;

          // Loop through the address components to find street, city, and area.
          for (var component in components) {
            final types = component['types'] as List;
            if (types.contains('route')) {
              _fetchedStreet = component['long_name'];
            }
            if (types.contains('sublocality_level_1')) {
              _fetchedArea = component['long_name'];
            }
            if (types.contains('locality')) {
              _fetchedLocality = component['long_name'];
            }
          }

          // Construct a full address string from the extracted components.
          final fullAddress = [
            _fetchedStreet,
            _fetchedArea,
            _fetchedLocality,
          ].where((s) => s.isNotEmpty).join(', ');

          selectedAddress.value = fullAddress.isNotEmpty ? fullAddress : 'Address not found.';
          hasDetailedAddress.value = fullAddress.isNotEmpty;
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
      Get.snackbar(snackPosition: SnackPosition.BOTTOM,
          'Error', 'Please select a valid location first.');
      return;
    }

    // No longer block based on hasDetailedAddress.value.
    // Instead, issue a warning and proceed, letting AddNewAddressPage handle manual input.
    if (!hasDetailedAddress.value) {
      Get.snackbar(
        'Address Details Missing',
        'Could not get precise address details automatically. Please fill them manually.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
    }

    Get.to(() => AddNewAddressPage(
      selectedLocation: selectedMapLocation.value,
      selectedAddress: selectedAddress.value,
      street: fetchedStreet,
      initialArea: fetchedArea,
      initialCity: fetchedLocality,
    ));
  }
  String _fetchedLocality = '';
  String _fetchedArea = '';
  String _fetchedStreet = '';

  String get fetchedLocality => _fetchedLocality; // New getter for locality (city)
  String get fetchedArea => _fetchedArea; // Area (sublocality)
  String get fetchedStreet => _fetchedStreet;

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
          Get.snackbar(snackPosition: SnackPosition.BOTTOM,
              'Error', 'Could not get details for selected place.');
          print("Place Details Error: ${data['status']} - ${data['error_message']}");
        }
      } else {
        Get.snackbar(snackPosition: SnackPosition.BOTTOM,
            'Error', 'Failed to fetch place details.');
        print("HTTP Error fetching details: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          'Error', 'Failed to set location from search: $e');
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

  void checkLocationCoverage(LatLng? location) {
    bool covered = false;
    if(location!=null){
      for (var polygonPoints in _serviceAreaBoundaries) {
        if (_isPointInPolygon(location, polygonPoints)) {
          covered = true;
          break;
        }
      }
    }
    isLocationCovered.value = covered;
    coverageMessage.value = covered
        ? 'This area is covered for delivery.'
        : 'Delivery is not available in this area.';
  }


}
