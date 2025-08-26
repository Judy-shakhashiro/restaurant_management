import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:flutter_application_restaurant/core/static/global_service.dart';
import 'package:flutter_application_restaurant/model/reservation/available-days_model.dart';
import 'package:flutter_application_restaurant/model/reservation/temporery_model.dart';
import 'package:flutter_application_restaurant/model/reservation/time_model.dart';
import '../../main.dart';
import '../../model/reservation/modify_model.dart';

class ReserveController extends GetxController {

  var focusedDay = DateTime.now().obs;
  var selectedDay = Rxn<DateTime>();
  var reservationData = Rxn<AvailableDaysModel>();
  var timeSlots = Rxn<TimeSlotsModel>();
  var selectedGuests = 2.obs;
  var selectedDuration = Rxn<String>();
  var selectedTime = Rxn<String>();
  var selectedType = Rxn<String>();
  var errorMessage = Rxn<String>();

  var isLoading = true.obs;

  GlobalServ myServices = Get.find<GlobalServ>();
  final String link = Linkapi.backUrl;

  final dynamic initialData;

  ReserveController({this.initialData});

  @override
  void onInit() {
    super.onInit();
    print('Initializing ReservationsController...');

    if (initialData != null) {
      _initializeFromModificationData(initialData);
    } else {
      fetchAvailableDates();
    }

    everAll([selectedDay, selectedDuration, selectedGuests], (_) {
      if (selectedDay.value != null &&
          selectedDuration.value != null &&
          selectedGuests.value != null) {
        fetchTimeSlots();
      }
    });
  }

  void _initializeFromModificationData(Map<String, dynamic> data) {
    try {
      final modData = ReservationModificationData.fromJson(data);

      selectedGuests.value = modData.revsData.guestsCount;
      selectedDay.value = DateTime.parse(modData.revsData.revsDate);
      focusedDay.value = selectedDay.value!;
      selectedDuration.value = modData.revsData.revsDuration.substring(0,5);
      selectedTime.value = modData.revsData.revsTime.substring(0, 5); // Format the time
      selectedType.value = modData.revsData.type;
      print('selectedDuration.value is ${selectedDuration.value} ${modData.revsData.revsDuration}');
      reservationData.value = AvailableDaysModel(
        status: true,
        statusCode: 200,
        message: "Data from modification response",
        data: Data(
          minPeople: modData.minPeople,
          maxPeople: modData.maxPeople,
          maxRevsDurationHours: modData.maxRevsDurationHours,
          availableDate: modData.availableDates,
        ),
      );


      timeSlots.value = modData.timeSlots;
      isLoading(false);
      print('Controller initialized with modification data.');
    } catch (e) {
      errorMessage.value = 'خطأ في تهيئة البيانات الأولية: $e';
      Get.snackbar(
        'Alert',
        ' $e',
        backgroundColor: Colors.red[500],
         snackPosition: SnackPosition.BOTTOM,
      );
      print('Error initializing with modification data: $e');
      isLoading(false);
    }
  }


  Future<void> fetchAvailableDates() async {
    isLoading(true);
    print('Fetching available dates...');
    try {
      final response = await http.get(
        Uri.parse('${Linkapi.availableDates}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Available dates response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        reservationData.value = AvailableDaysModel.fromJson(jsonDecode(response.body));
        if (reservationData.value!.data.minPeople > 2) {
          selectedGuests.value = reservationData.value!.data.minPeople;
        } else if (reservationData.value!.data.maxPeople < 2) {
          selectedGuests.value = reservationData.value!.data.maxPeople;
        }
        if (reservationData.value!.data.maxPeople <= 0) {
          reservationData.value!.data.maxPeople = 10;
          print('Invalid maxPeople, set to default: 10');
        }
        print('Available dates loaded: ${reservationData.value!.data.availableDate.length} dates');
        print('Initialized guests: ${selectedGuests.value}, maxPeople: ${reservationData.value!.data.maxPeople}');
        errorMessage.value = null;
      } else {
        errorMessage.value = 'failed to load available days :  ${response.body}';
        Get.snackbar(
        'Alert',
        ' ${errorMessage.value}',
        backgroundColor: Colors.red[500],
        colorText: Colors.white,
         snackPosition: SnackPosition.BOTTOM,
      );
        print('Failed to fetch available dates: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'خطأ في جلب الأيام: $e';
      Get.snackbar(
        'Alert',
        ' $e',
        backgroundColor: Colors.red[500],
        colorText: Colors.white,
      );
      print('Error fetching available dates: $e');
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchTimeSlots() async {
    if (selectedDay.value == null || selectedGuests.value == null || selectedDuration.value == null) {
      return;
    }

    print('Fetching time slots for date: ${selectedDay.value}, guests: ${selectedGuests.value}, duration: ${selectedDuration.value}');
    try {
      final response = await http.get(
        Uri.parse('${Linkapi.timeSlots}?selected_date=${selectedDay.value!.toIso8601String().substring(0, 10)}&guests_count=${selectedGuests.value}&revs_duration=${selectedDuration.value}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Time slots response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        timeSlots.value = TimeSlotsModel.fromJson(jsonDecode(response.body));
        print('Time slots loaded: ${timeSlots.value!.timeSlots.indoor.length} indoor, ${timeSlots.value!.timeSlots.outdoor.length} outdoor');
        errorMessage.value = null;
      } else {
        errorMessage.value = 'فشل تحميل الأوقات: ${response.statusCode} - ${response.body}';
        print('Failed to fetch time slots: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'خطأ في جلب الأوقات: $e';
      print('Error fetching time slots: $e');
    }
  }

  Future<ConfirmationResponse?> confirmReservation() async {
    print('Confirming reservation...');


    final bool isModification = initialData != null;
    final int? reservationId = isModification ? ReservationModificationData.fromJson(initialData).revsData.id : null;
print('id is ${reservationId }');
    String apiUrl;
    if (isModification && reservationId != null) {
      print('id is ${Linkapi.backUrl}/reservations/$reservationId');
      apiUrl = '${Linkapi.backUrl}/reservations/$reservationId';
    } else {

      apiUrl = Linkapi.confirmReservation;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'selected_date': selectedDay.value!.toIso8601String().substring(0, 10),
          'guests_count': selectedGuests.value,
          'revs_duration': selectedDuration.value,
          'selected_slot': selectedTime.value,
          'type': selectedType.value,
        }),
      );
      print('Confirmation response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ConfirmationResponse.fromJson(jsonDecode(response.body));
      } else {
        errorMessage.value = 'فشل تأكيد الحجز: ${response.statusCode} - ${response.body}';
        print('Failed to confirm reservation: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      errorMessage.value = 'خطأ في تأكيد الحجز: $e';
      print('Error confirming reservation: $e');
      return null;
    }
  }


  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }


  String formatDurationDisplay(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours == 0) return '$mins minutes';
    if (mins == 0) return '$hours hours';
    return '$hours hours and $mins minutes';
  }


  void resetSelectionsIfNeeded(DateTime newFocusedDay) {
    if (selectedDay.value != null &&
        (selectedDay.value!.year != newFocusedDay.year || selectedDay.value!.month != newFocusedDay.month)) {
      selectedDay.value = null;
      selectedDuration.value = null;
      timeSlots.value = null;
      selectedTime.value = null;
      selectedType.value = null;
      errorMessage.value = null;
      if (reservationData.value != null) {
        if (reservationData.value!.data.minPeople > 2) {
          selectedGuests.value = reservationData.value!.data.minPeople;
        } else if (reservationData.value!.data.maxPeople < 2) {
          selectedGuests.value = reservationData.value!.data.maxPeople;
        } else {
          selectedGuests.value = 2;
        }
      }
      print('Reset selections due to month change, guests: ${selectedGuests.value}');
    }
  }

  bool isDayAvailable(DateTime day) {
    if (reservationData.value == null) return false;
    for (var availableDate in reservationData.value!.data.availableDate) {
      if (isSameDay(day, availableDate.date)) {
        return availableDate.isAvailable;
      }
    }
    return false;
  }

  bool isConfirmButtonEnabled() {
    return selectedDay.value != null &&
        selectedGuests.value != null &&
        selectedDuration.value != null &&
        selectedTime.value != null &&
        selectedType.value != null;
  }

  void incrementGuests() {
    if (reservationData.value == null) return;

    final int maxAllowedGuests = (reservationData.value!.data.maxPeople < 20
        ? reservationData.value!.data.maxPeople
        : 20);

    final int newGuests = selectedGuests.value + 1;

    if (newGuests > maxAllowedGuests) {
      Get.snackbar(
        'Alert',
        'The number of people cannot exceed  $maxAllowedGuests',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.info_outline, color: Colors.black),
      );
      return;
    }

    selectedGuests.value = newGuests;
    resetTimeSlots();
    if (selectedDay.value != null && selectedDuration.value != null) {
      fetchTimeSlots();
    }
  }

  void decrementGuests() {
    if (reservationData.value != null && selectedGuests.value > reservationData.value!.data.minPeople) {
      selectedGuests.value = selectedGuests.value - 1;
      resetTimeSlots();
      if (selectedDay.value != null && selectedDuration.value != null) {
        fetchTimeSlots();
      }
    }
  }

  void resetTimeSlots() {
    timeSlots.value = null;
    selectedTime.value = null;
    selectedType.value = null;
    errorMessage.value = null;
  }

void updateSelectedDay(DateTime newSelectedDay, DateTime newFocusedDay) {
  selectedDay.value = newSelectedDay;
  focusedDay.value = newFocusedDay;
  resetTimeSlots();
  if (selectedGuests.value != null && selectedDuration.value != null) {
    fetchTimeSlots();
  }
}

  void updateSelectedDuration(String? newDuration) {
    selectedDuration.value = newDuration;
    resetTimeSlots();
    if (selectedDay.value != null && selectedGuests.value != null) {
      fetchTimeSlots();
    }
  }

  void updateSelectedTime(String time, String type) {
    selectedTime.value = time;
    selectedType.value = type;
  }
}



// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_restaurant/core/static/routes.dart';
// import 'package:flutter_application_restaurant/main.dart';
// import 'package:flutter_application_restaurant/model/reservation/available-days_model.dart';
// import 'package:flutter_application_restaurant/model/reservation/temporery_model.dart';
// import 'package:flutter_application_restaurant/model/reservation/time_model.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:table_calendar/table_calendar.dart';


// class ReservationController extends GetxController {
//   // المتغيرات التي ستتم مراقبتها
//   final focusedDay = DateTime.now().obs;
//   final selectedDay = Rxn<DateTime>();
//   final reservationData = Rxn<AvailableDaysModel>();
//   final timeSlots = Rxn<TimeSlotsModel>();
//   final selectedGuests = 2.obs;
//   final selectedDuration = Rxn<String>();
//   final selectedTime = Rxn<String>();
//   final selectedType = Rxn<String>();
//   final errorMessage = Rxn<String>();
//   final isLoading = true.obs;

//   // المتغيرات الثابتة
// //  final String _token = '5|YfNZLPJMVoMom3gQSyZSe3URvXOHgxa0hlVwxUa7f12f7d20';
// //  final String link = 'http://192.168.1.106:8000/api';

//   @override
//   void onInit() {
//     super.onInit();
//     print('Initializing ReservationController...');
//     fetchAvailableDates();
//   }

//   // الدوال
//   Future<void> fetchAvailableDates() async {
//     isLoading(true);
//     print('Fetching available dates...');
//     try {
//       final response = await http.get(
//         Uri.parse('${Linkapi.backUrl}/reservations/available-days'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       print('Available dates response: ${response.statusCode} - ${response.body}');
//       if (response.statusCode == 200) {
//         reservationData.value = AvailableDaysModel.fromJson(jsonDecode(response.body));
//         if (reservationData.value!.data.minPeople > 2) {
//           selectedGuests.value = reservationData.value!.data.minPeople;
//         } else if (reservationData.value!.data.maxPeople < 2) {
//           selectedGuests.value = reservationData.value!.data.maxPeople;
//         }
//         if (reservationData.value!.data.maxPeople <= 0) {
//           reservationData.value!.data.maxPeople = 10;
//           print('Invalid maxPeople, set to default: 10');
//         }
//         print('Available dates loaded: ${reservationData.value!.data.availableDate.length} dates');
//         errorMessage.value = null;
//       } else {
//         errorMessage.value = 'فشل تحميل الأيام المتاحة: ${response.statusCode}';
//         print('Failed to fetch available dates: ${response.statusCode}');
//       }
//     } catch (e) {
//       errorMessage.value = 'خطأ في جلب الأيام: $e';
//       print('Error fetching available dates: $e');
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> fetchTimeSlots() async {
//     if (selectedDay.value == null || selectedGuests.value == null || selectedDuration.value == null) {
//       return;
//     }
//     timeSlots.value = null;
//     selectedTime.value = null;
//     selectedType.value = null;
//     errorMessage.value = null;

//     print('Fetching time slots for date: ${selectedDay.value!.toIso8601String().substring(0, 10)}, guests: ${selectedGuests.value}, duration: ${selectedDuration.value}');
//     try {
//       final response = await http.get(
//         Uri.parse('${Linkapi.backUrl}/reservations/available-time-slots?selected_date=${selectedDay.value!.toIso8601String().substring(0, 10)}&guests_count=${selectedGuests.value}&revs_duration=${selectedDuration.value}'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       print('Time slots response: ${response.statusCode} - ${response.body}');
//       if (response.statusCode == 200) {
//         timeSlots.value = TimeSlotsModel.fromJson(jsonDecode(response.body));
//         print('Time slots loaded: ${timeSlots.value!.timeSlots.indoor.length} indoor, ${timeSlots.value!.timeSlots.outdoor.length} outdoor');
//         errorMessage.value = null;
//       } else {
//         errorMessage.value = 'فشل تحميل الأوقات: ${response.statusCode}';
//         print('Failed to fetch time slots: ${response.statusCode}');
//       }
//     } catch (e) {
//       errorMessage.value = 'خطأ في جلب الأوقات: $e';
//       print('Error fetching time slots: $e');
//     }
//   }

//   Future<ConfirmationResponse?> confirmReservation() async {
//     print('Confirming reservation...');
//     try {
//       final response = await http.post(
//         Uri.parse('${Linkapi.backUrl}/reservations/temp-revs'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'selected_date': selectedDay.value!.toIso8601String().substring(0, 10),
//           'guests_count': selectedGuests.value,
//           'revs_duration': selectedDuration.value,
//           'selected_slot': selectedTime.value,
//           'type': selectedType.value,
//         }),
//       );
//       print('Confirmation response: ${response.statusCode} - ${response.body}');
//       if (response.statusCode == 201) {
//         return ConfirmationResponse.fromJson(jsonDecode(response.body));
//       } else {
//         errorMessage.value = 'فشل تأكيد الحجز: ${response.statusCode}';
//         print('Failed to confirm reservation: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       errorMessage.value = 'خطأ في تأكيد الحجز: $e';
//       print('Error confirming reservation: $e');
//       return null;
//     }
//   }

//   void onDaySelected(DateTime day, DateTime focused) {
//     if (!isDayAvailable(day)) {
//       Get.snackbar(
//         'تنبيه',
//         'هذا اليوم غير متاح للحجز',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//     selectedDay.value = day;
//     focusedDay.value = focused;
//     fetchTimeSlots();
//   }

//   void onPageChanged(DateTime newFocusedDay) {
//     focusedDay.value = newFocusedDay;
//     resetSelectionsIfNeeded(newFocusedDay);
//   }

//   void incrementGuests() {
//     if (reservationData.value == null) return;
//     final int maxAllowedGuests = (reservationData.value!.data.maxPeople < 20
//         ? reservationData.value!.data.maxPeople
//         : 20);

//     final int newGuests = selectedGuests.value + 1;

//     if (newGuests > maxAllowedGuests) {
//       Get.snackbar(
//         'تنبيه',
//         'عدد الأشخاص لا يمكن أن يتجاوز $maxAllowedGuests',
//         backgroundColor: Colors.red,
//         snackPosition: SnackPosition.BOTTOM,
//         icon: const Icon(
//           Icons.info_outline,
//           color: Colors.red,
//         ),
//       );
//       return;
//     }
//     selectedGuests.value = newGuests;
//     fetchTimeSlots();
//   }

//   void decrementGuests() {
//     if (reservationData.value == null) return;
//     if (selectedGuests.value > reservationData.value!.data.minPeople) {
//       selectedGuests.value--;
//       fetchTimeSlots();
//     }
//   }

//   void onDurationChanged(String? value) {
//     selectedDuration.value = value;
//     fetchTimeSlots();
//   }

//   void onTimeSlotSelected(String time, String type) {
//     selectedTime.value = time;
//     selectedType.value = type;
//   }

//   bool isDayAvailable(DateTime day) {
//     if (reservationData.value == null) return false;
//     for (var availableDate in reservationData.value!.data.availableDate) {
//       if (isSameDay(day, availableDate.date)) {
//         return availableDate.isAvailable;
//       }
//     }
//     return false;
//   }

//   bool isConfirmButtonEnabled() {
//     return selectedDay.value != null &&
//         selectedGuests.value != null &&
//         selectedDuration.value != null &&
//         selectedTime.value != null &&
//         selectedType.value != null;
//   }

//   void resetSelectionsIfNeeded(DateTime newFocusedDay) {
//     if (selectedDay.value != null &&
//         (selectedDay.value!.year != newFocusedDay.year || selectedDay.value!.month != newFocusedDay.month)) {
//       selectedDay.value = null;
//       selectedDuration.value = null;
//       timeSlots.value = null;
//       selectedTime.value = null;
//       selectedType.value = null;
//       errorMessage.value = null;
//       if (reservationData.value != null) {
//         if (reservationData.value!.data.minPeople > 2) {
//           selectedGuests.value = reservationData.value!.data.minPeople;
//         } else if (reservationData.value!.data.maxPeople < 2) {
//           selectedGuests.value = reservationData.value!.data.maxPeople;
//         } else {
//           selectedGuests.value = 2;
//         }
//       }
//       print('Reset selections due to month change, guests: ${selectedGuests.value}');
//     }
//   }

//   String formatDuration(int minutes) {
//     final hours = minutes ~/ 60;
//     final mins = minutes % 60;
//     return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
//   }

//   String formatDurationDisplay(int minutes) {
//     final hours = minutes ~/ 60;
//     final mins = minutes % 60;
//     if (hours == 0) return '$mins minutes';
//     if (mins == 0) return '$hours hours';
//     return '$hours hours and $mins minutes';
//   }
// }