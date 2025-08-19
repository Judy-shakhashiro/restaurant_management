import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../../core/static/routes.dart';
import '../../main.dart';
import '../../model/reservation/reservations_list_model.dart';

class ReservationsController extends GetxController {
  final RxMap<String, List<Reservation>> categorizedReservations = <String, List<Reservation>>{}.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Reservation?> selectedReservation = Rx<Reservation?>(null);
  @override
  void onInit() {
    super.onInit();
    fetchReservations();
  }


  Future<void> fetchReservations() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final Uri uri = Uri.parse('${Linkapi.backUrl}/reservations');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept':'application/json'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == true && data['reservations'] != null) {
          final List<Reservation> fetchedReservations = (data['reservations'] as List)
              .map((e) => Reservation.fromJson(e as Map<String, dynamic>))
              .toList();
          categorizedReservations.clear();
          final now = DateTime.now();
          final upcomingReservations = <Reservation>[];
          final pastReservations = <Reservation>[];

          for (var reservation in fetchedReservations) {
            final reservationDateTime = DateTime.parse('${reservation.revsDate} ${reservation.revsTime}');

            if (reservationDateTime.isBefore(now)) {
              pastReservations.add(reservation);
            } else {
              upcomingReservations.add(reservation);
            }
          }

          if (upcomingReservations.isNotEmpty) {
            categorizedReservations['Upcoming Reservations'] = upcomingReservations;
          }
          if (pastReservations.isNotEmpty) {
            categorizedReservations['Past Reservations'] = pastReservations;
          }

        } else {
          errorMessage.value = data['message'] ?? 'Failed to load reservations.';
        }
      } else {
        errorMessage.value = 'Error ${response.statusCode}: Failed to fetch data.';
      }

    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSingleReservation(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';


      final Uri uri = Uri.parse('${Linkapi.backUrl}/reservations/$id');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept':'application/json'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == true && data['reservation'] != null) {
          selectedReservation.value = Reservation.fromJson(data['reservation'] as Map<String, dynamic>);
        } else {
          errorMessage.value = data['message'] ?? 'Failed to load reservation details.';
        }
      } else {
        errorMessage.value = 'Error ${response.statusCode}: Failed to fetch data.';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> cancelReservation(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Construct the real API URL dynamically for cancellation.
      final Uri uri = Uri.parse('${Linkapi.backUrl}/reservations/$id/cancel');
      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept':'application/json'
        },
      );

      if (response.statusCode == 200) {
        // Assume success if status code is 200.
        // Reload the reservations to reflect the cancellation.
        await fetchReservations();
        // Show a success message.
        Get.snackbar(
          'Success',
          'Reservation #$id has been cancelled.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Handle API errors.
        final Map<String, dynamic> data = json.decode(response.body);
        errorMessage.value = data['message'] ?? 'Failed to cancel reservation.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
