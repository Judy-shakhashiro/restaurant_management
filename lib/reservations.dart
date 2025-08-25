// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_application_restaurant/reservation/available-days_model.dart';
// import 'package:flutter_application_restaurant/reservation/temporery_model.dart';
// import 'package:flutter_application_restaurant/test.dart';
// import 'package:flutter_application_restaurant/reservation/time_model.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:table_calendar/table_calendar.dart';


// class ReservationScreen extends StatefulWidget {
//   @override
//   _ReservationScreenState createState() => _ReservationScreenState();
// }

// class _ReservationScreenState extends State<ReservationScreen> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   AvailableDaysModel? _reservationData;
//   TimeSlotsModel? _timeSlots;
//   int? _selectedGuests = 2;
//   String? _selectedDuration;
//   String? _selectedTime;
//   String? _selectedType;
//   String? _errorMessage;

//   final String _token = '5|YfNZLPJMVoMom3gQSyZSe3URvXOHgxa0hlVwxUa7f12f7d20';
//   final String link='http://192.168.1.106:8000/api';
//   @override
//   void initState() {
//     super.initState();
//     print('Initializing ReservationScreen...');
//     _fetchAvailableDates();
   
    
//   }
  

//   Future<void> _fetchAvailableDates() async {
//     print('Fetching available dates...');
//     try {
//       final response = await http.get(
//         Uri.parse('$link/reservations/available-days'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $_token',
//         },
//       );
//       print('Available dates response: ${response.statusCode} - ${response.body}');
//       if (response.statusCode == 200) {
//         setState(() {
//           _reservationData = AvailableDaysModel.fromJson(jsonDecode(response.body));
//           if (_reservationData!.data.minPeople > 2) {
//             _selectedGuests = _reservationData!.data.minPeople;
//           } else if (_reservationData!.data.maxPeople < 2) {
//             _selectedGuests = _reservationData!.data.maxPeople;
//           }
//           if (_reservationData!.data.maxPeople <= 0) {
//             _reservationData!.data.maxPeople = 10;
//             print('Invalid maxPeople, set to default: 10');
//           }
//           print('Available dates loaded: ${_reservationData!.data.availableDate.length} dates');
//           print('Initialized guests: $_selectedGuests, maxPeople: ${_reservationData!.data.maxPeople}');
//           _errorMessage = null;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'فشل تحميل الأيام المتاحة: ${response.statusCode} - ${response.body}';
//         });
//         print('Failed to fetch available dates: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'خطأ في جلب الأيام: $e';
//       });
//       print('Error fetching available dates: $e');
//     }
//   }

//   Future<void> _fetchTimeSlots(String selectedDate, int guests, String duration) async {
//     print('Fetching time slots for date: $selectedDate, guests: $guests, duration: $duration');
//     try {
//       final response = await http.get(
//         Uri.parse('$link/reservations/available-time-slots?selected_date=$selectedDate&guests_count=$guests&revs_duration=$duration'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $_token',
//         },
//       );
//       print('Time slots response: ${response.statusCode} - ${response.body}');
//       if (response.statusCode == 200) {
//         setState(() {
//           _timeSlots = TimeSlotsModel.fromJson(jsonDecode(response.body));
//           print('Time slots loaded: ${_timeSlots!.timeSlots.indoor.length} indoor, ${_timeSlots!.timeSlots.outdoor.length} outdoor');
//           _errorMessage = null;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'فشل تحميل الأوقات: ${response.statusCode} - ${response.body}';
//         });
//         print('Failed to fetch time slots: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'خطأ في جلب الأوقات: $e';
//       });
//       print('Error fetching time slots: $e');
//     }
//   }

//   Future<ConfirmationResponse?> _confirmReservation() async {
//     print('Confirming reservation...');
//     try {
//       final response = await http.post(
//         Uri.parse('$link/reservations/temp-revs'),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $_token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'selected_date': _selectedDay!.toIso8601String().substring(0, 10),
//           'guests_count': _selectedGuests,
//           'revs_duration': _selectedDuration,
//           'selected_slot': _selectedTime,
//           'type': _selectedType,
//         }),
//       );
//       print('Confirmation response: ${response.statusCode} - ${response.body}');
//       if (response.statusCode == 201) {
//         return ConfirmationResponse.fromJson(jsonDecode(response.body));
//       } else {
//         setState(() {
//           _errorMessage = 'فشل تأكيد الحجز: ${response.statusCode} - ${response.body}';
//         });
//         print('Failed to confirm reservation: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'خطأ في تأكيد الحجز: $e';
//       });
//       print('Error confirming reservation: $e');
//       return null;
//     }
//   }

//   String _formatDuration(int minutes) {
//     final hours = minutes ~/ 60;
//     final mins = minutes % 60;
//     return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
//   }

//   String _formatDurationDisplay(int minutes) {
//     final hours = minutes ~/ 60;
//     final mins = minutes % 60;
//     if (hours == 0) return '$mins minutes';
//     if (mins == 0) return '$hours hours';
//     return '$hours hours and $mins minutes';
//   }

//   void _resetSelectionsIfNeeded(DateTime newFocusedDay) {
//     if (_selectedDay != null &&
//         (_selectedDay!.year != newFocusedDay.year || _selectedDay!.month != newFocusedDay.month)) {
//       setState(() {
//         _selectedDay = null;
//         _selectedDuration = null;
//         _timeSlots = null;
//         _selectedTime = null;
//         _selectedType = null;
//         _errorMessage = null;
//         if (_reservationData != null) {
//           if (_reservationData!.data.minPeople > 2) {
//             _selectedGuests = _reservationData!.data.minPeople;
//           } else if (_reservationData!.data.maxPeople < 2) {
//             _selectedGuests = _reservationData!.data.maxPeople;
//           } else {
//             _selectedGuests = 2;
//           }
//         }
//         print('Reset selections due to month change, guests: $_selectedGuests');
//       });
//     }
//   }

//   bool _isConfirmButtonEnabled() {
//     return _selectedDay != null &&
//         _selectedGuests != null &&
//         _selectedDuration != null &&
//         _selectedTime != null &&
//         _selectedType != null;
//   }

//   bool _isDayAvailable(DateTime day) {
//     if (_reservationData == null) return false;
//     for (var availableDate in _reservationData!.data.availableDate) {
//       if (isSameDay(day, availableDate.date)) {
//         return availableDate.isAvailable;
//       }
//     }
//     return false;
//   }

//   void _showSnackBar(BuildContext context, String message) {
//     print('Attempting to show SnackBar: $message');
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       Builder(
//         builder: (BuildContext scaffoldContext) {
//           ScaffoldMessenger.of(scaffoldContext).removeCurrentSnackBar();
//           ScaffoldMessenger.of(scaffoldContext).showSnackBar(
//             SnackBar(
//               content: Text(
//                 message,
//                 style: TextStyle(color: Colors.white),
//               ),
//               backgroundColor: Colors.red,
//               duration: Duration(seconds: 3),
//             ),
//           );
//           print('SnackBar displayed: $message');
//           return SizedBox.shrink();
//         },
//       );
//     });
//   }



//   @override
//   Widget build(BuildContext context) {
//     print('Building ReservationScreen...');
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//   title:const Text(
//     'Reservation',
//     style: TextStyle(
//       color: Colors.white, 
//       fontWeight: FontWeight.bold,
//       fontSize: 25,
//       fontFamily: 'Georgia',
//     ),
//   ),
//   centerTitle: true,
//   flexibleSpace: Container(
//     decoration:const BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color(0xFFFF6200), Color(0xFFE53935)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     ),
//   ),
//   elevation: 10,  
//   iconTheme:const IconThemeData(color: Colors.white),  
// ),
//       body: SingleChildScrollView(
//         padding:const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_errorMessage != null)
//               Padding(
//                 padding: EdgeInsets.only(bottom: 10.0),
//                 child: Text(
//                   _errorMessage!,
//                   style:const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                const Text(
//                   'Guests ',
//                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22,fontFamily: 'Georgia'),
//                 ),
//                 Text(
//                   '(${_reservationData?.data.minPeople ?? 2} - ${_reservationData?.data.maxPeople ?? 20})',
//                   style:const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 15),
//                 ),
//               ],
//             ),
//            const SizedBox(height: 15),
//             if (_reservationData != null)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                             iconSize: 45,
//                             onPressed: _selectedGuests != null &&
//                                     _selectedGuests! > _reservationData!.data.minPeople
//                                 ? () {
//                                     setState(() {
//                                       _selectedGuests = _selectedGuests! - 1;
//                                       _timeSlots = null;
//                                       _selectedTime = null;
//                                       _selectedType = null;
//                                       _errorMessage = null;
//                                       if (_selectedDay != null && _selectedDuration != null) {
//                                         _fetchTimeSlots(
//                                           _selectedDay!.toIso8601String().substring(0, 10),
//                                           _selectedGuests!,
//                                           _selectedDuration!,
//                                         );
//                                       }
//                                       print('Guests updated to: $_selectedGuests');
//                                     });
//                                   }
//                                 : null,
//                             icon:const Icon(Icons.remove_circle, color: Color(0xFFFF6200)),
//                           ),
//                   Card(
//                     elevation: 5,
//                     color: Colors.white60,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                     child: Padding(
//                       padding:const EdgeInsets.symmetric(horizontal: 90,vertical: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
                          
//                           Text(
//                             _selectedGuests.toString(),
//                             style: TextStyle(color: Colors.black, fontSize: 25),
//                           ),
                          
//                         ],
//                       ),
//                     ),
//                   ),
//                  IconButton(
//   iconSize: 40,
//   onPressed: () {
  
//     if (_selectedGuests == null || _reservationData == null) {
//       return;
//     }

//     final int maxAllowedGuests = (_reservationData!.data.maxPeople < 20
//         ? _reservationData!.data.maxPeople
//         : 20);

//     final int newGuests = _selectedGuests! + 1;

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
//     setState(() {
//       _selectedGuests = newGuests;
//       _timeSlots = null;
//       _selectedTime = null;
//       _selectedType = null;
//       _errorMessage = null;

//       if (_selectedDay != null && _selectedDuration != null) {
//         _fetchTimeSlots(
//           _selectedDay!.toIso8601String().substring(0, 10),
//           _selectedGuests!,
//           _selectedDuration!,
//         );
//       }
//       print('Guests updated to: $_selectedGuests');
//     });
//   },
//   icon: const Icon(Icons.add_circle, color: Color(0xFFFF6200)),
// )
//                 ],
//               ),
//           const  SizedBox(height: 20),
//             const Text(
//                   'Date ',
//                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22,fontFamily: 'Georgia'),
//                 ),
//                 const SizedBox(height: 15),
//             _reservationData == null
//                 ?const Center(child: CircularProgressIndicator(color: Color(0xFFFF6200)))
//                 : Card(
//                     elevation: 5,
//                     color: Colors.white70,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                     child: Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: TableCalendar(
//                         firstDay: DateTime.utc(2020, 1, 1),
//                         lastDay: DateTime.utc(2030, 12, 31),
//                         focusedDay: _focusedDay,
//                         selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                         onDaySelected: (selectedDay, focusedDay) {
//                           print('Selected day: $selectedDay');
//                          if (!_isDayAvailable(selectedDay)) {
//                           Get.snackbar(
//                             'تنبيه',
//                             'هذا اليوم غير متاح للحجز',
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                             snackPosition: SnackPosition.BOTTOM,
//                           );
//                           return;
//                         }
//                                                 setState(() {
//                             _selectedDay = selectedDay;
//                             _focusedDay = focusedDay;
//                             _timeSlots = null;
//                             _selectedTime = null;
//                             _selectedType = null;
//                             _errorMessage = null;
//                             if (_selectedGuests != null && _selectedDuration != null) {
//                               _fetchTimeSlots(
//                                 selectedDay.toIso8601String().substring(0, 10),
//                                 _selectedGuests!,
//                                 _selectedDuration!,
//                               );
//                             } else {
//                               print('Guests or duration not selected yet');
//                             }
//                           });
//                         },
//                         onPageChanged: (focusedDay) {
//                           print('Page changed to: $focusedDay');
//                           _focusedDay = focusedDay;
//                           _resetSelectionsIfNeeded(focusedDay);
//                         },
//                         calendarBuilders: CalendarBuilders(
//                           defaultBuilder: (context, day, focusedDay) {
//                             for (var availableDate in _reservationData!.data.availableDate) {
//                               if (isSameDay(day, availableDate.date)) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       '${day.day}',
//                                       style:const TextStyle(
//                                         color: Colors.black54,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                    const SizedBox(height: 4),
//                                     Container(
//                                       width: 6,
//                                       height: 6,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: availableDate.isAvailable ? Colors.green : Colors.red,
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }
//                             }
//                             return null;
//                           },
//                           selectedBuilder: (context, day, focusedDay) {
//                             return Center(
//                               child: Container(
//                                 width: 36,
//                                 height: 36,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(color: Color(0xFFFF6200), width: 2),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     '${day.day}',
//                                     style:const TextStyle(
//                                       color: Color(0xFFFF6200),
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         calendarStyle:const CalendarStyle(
//                           outsideTextStyle: TextStyle(color: Colors.black54,fontFamily: 'Georgia'),
//                           weekendTextStyle: TextStyle(color: Colors.black54,fontFamily: 'Georgia'),
//                           todayDecoration: BoxDecoration(
//                             color: Color(0xFFFFA270),
//                             shape: BoxShape.circle,
//                           ),
//                           tableBorder: TableBorder(
//                            top: BorderSide(color: Colors.deepOrange, width: 2),
//                            // bottom: BorderSide(color: Colors.black, width: 1),
//                           ),
//                         ),
                        
//                         daysOfWeekStyle:const DaysOfWeekStyle(
//                           weekdayStyle: TextStyle(color: Colors.black, fontFamily: 'Georgia', ),
//                           weekendStyle: TextStyle(color: Colors.black, fontFamily: 'Georgia', ),
//                         ),
//                         headerStyle:const HeaderStyle(
//                           titleCentered: true,
//                           titleTextStyle: TextStyle(color: Colors.deepOrange, fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'Georgia'),
//                           formatButtonVisible: false,
//                           leftChevronIcon: Icon(Icons.chevron_left, color: Colors.deepOrange),
//                           rightChevronIcon: Icon(Icons.chevron_right, color: Colors.deepOrange),
//                         ),
//                       ),
//                     ),
//                   ),
//           const  SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//               const  Text(
//                   'Time ',
//                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Georgia'),
//                 ),
//                const SizedBox(width: 10),
//                 if (_reservationData != null)
//                   Expanded(
//                     child: Card(
//                       elevation: 5,
//                       color: Colors.white60,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
//                         child: DropdownButton<String>(
//                                 style: TextStyle(color: Colors.black,fontFamily: 'Georgia'),
//                           hint: Text('Duration',textAlign: TextAlign.center,),
//                           value: _selectedDuration,
//                           isExpanded: true,
//                           items: List.generate(
//                             _reservationData!.data.maxRevsDurationHours * 2,
//                             (index) => (index + 1) * 30,
//                           ).map((minutes) {
//                             final formattedDuration = _formatDuration(minutes);
//                             return DropdownMenuItem<String>(
//                               value: formattedDuration,
//                               child: Text(
//                                 _formatDurationDisplay(minutes),
//                                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'Georgia',),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             print('Selected duration: $value');
//                             setState(() {
//                               _selectedDuration = value;
//                               _timeSlots = null;
//                               _selectedTime = null;
//                               _selectedType = null;
//                               _errorMessage = null;
//                               if (_selectedDay != null && _selectedGuests != null) {
//                                 _fetchTimeSlots(
//                                   _selectedDay!.toIso8601String().substring(0, 10),
//                                   _selectedGuests!,
//                                   _selectedDuration!,
//                                 );
//                               }
//                             });
//                           },
//                           underline: SizedBox(),
//                           icon: Icon(Icons.arrow_drop_down, color: Color(0xFFFF6200)),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           const  SizedBox(height: 20),
  
//             if (_selectedDay == null || _selectedGuests == null || _selectedDuration == null)
//             const  Padding(
//                 padding: EdgeInsets.only(bottom: 10.0),
//                 child: Text(
//                   'يرجى اختيار التاريخ وعدد الأشخاص والمدة لعرض الأوقات المتاحة',
//                   style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontFamily: 'Georgia'),
//                 ),
//               ),
//             if (_selectedDay != null && _selectedGuests != null && _selectedDuration != null)
//               if (_timeSlots == null)
//               const  Center(child: CircularProgressIndicator(color: Color(0xFFFF6200)))
//               else
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (_timeSlots!.timeSlots.indoor.isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                        const   Text(
//                             'Indoor :',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                               fontFamily: 'Georgia'
//                             ),
//                           ),
//                         const  SizedBox(height: 10),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: _timeSlots!.timeSlots.indoor.map((time) {
//                               final isSelected = _selectedTime == time && _selectedType == 'indoor';
//                               return GestureDetector(
//                                 onTap: () {
//                                   print('Selected indoor time: $time');
//                                   setState(() {
//                                     _selectedTime = time;
//                                     _selectedType = 'indoor';
//                                   });
//                                 },
//                                 child: Container(
//                                   width: 80,
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.circular(5),
//                                     color: isSelected ? Color(0xFFFF6200) : Colors.white54,
//                                     border: Border.all(color: Color(0xFFFF6200), width: 2),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.4),
//                                         spreadRadius: 2,
//                                         blurRadius: 5,
//                                         offset: Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       time,
//                                       style: TextStyle(
//                                         color: isSelected ? Colors.white : Color(0xFFFF6200),
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15,
//                                         fontFamily: 'Georgia'
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         const  SizedBox(height: 20),
//                         ],
//                       ),
//                     if (_timeSlots!.timeSlots.outdoor.isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                          const Text(
//                             'Outdoor :',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                               fontFamily: 'Georgia'
//                             ),
//                           ),
//                         const  SizedBox(height: 10),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: _timeSlots!.timeSlots.outdoor.map((time) {
//                               final isSelected = _selectedTime == time && _selectedType == 'outdoor';
//                               return GestureDetector(
//                                 onTap: () {
//                                   print('Selected outdoor time: $time');
//                                   setState(() {
//                                     _selectedTime = time;
//                                     _selectedType = 'outdoor';
//                                   });
//                                 },
//                                 child: Container(
//                                   width: 80,
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.circular(5),
//                                     color: isSelected ? Color(0xFFFF6200) : Colors.white54,
//                                     border: Border.all(color: Color(0xFFFF6200), width: 2),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.4),
//                                         spreadRadius: 2,
//                                         blurRadius: 5,
//                                         offset: Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       time,
//                                       style: TextStyle(
//                                         color: isSelected ? Colors.white : Color(0xFFFF6200),
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15,
//                                         fontFamily: 'Georgia'
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                     if (_timeSlots!.timeSlots.indoor.isEmpty && _timeSlots!.timeSlots.outdoor.isEmpty)
//                     const  Text(
//                         'No available time slotes please chosse another duration',
//                         style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontFamily: 'Georgia'),
//                       ),
//                       const SizedBox(height: 20),
//                     if (_timeSlots!.timeSlots.indoor.isNotEmpty || _timeSlots!.timeSlots.outdoor.isNotEmpty)
//                      const SizedBox(height: 20),
//                     Center(
//                       child: Builder(
//                         builder: (BuildContext scaffoldContext) {
//                           return ElevatedButton(
//                             onPressed: _isConfirmButtonEnabled()
//                                 ? () async {
//                                     print('Confirmed: Day: $_selectedDay, Guests: $_selectedGuests, Duration: $_selectedDuration, Time: $_selectedTime, Type: $_selectedType');
//                                     final confirmation = await _confirmReservation();
//                                     if (confirmation != null) {
//                                       _showSnackBar(
//                                         scaffoldContext,
//                                         'تم تأكيد الحجز مؤقتًا، يرجى التأكيد خلال ${confirmation.data.confirmationTime} دقائق',
//                                       );
//                              Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ReservationConfirmationScreen(
//                                 selectedDate: _selectedDay!.toIso8601String().substring(0, 10),
//                                 guestsCount: _selectedGuests!,
//                                 revsDuration: _selectedDuration!,
//                                 selectedSlot: _selectedTime!,
//                                 type: _selectedType!,
//                                 explanatoryNotes: confirmation.data.explanatoryNotes,
//                                 confirmationTime: confirmation.data.confirmationTime,
//                                 depositValue: confirmation.data.depositValue,
//                                 tablesCount: confirmation.data.tablesCount,
//                                 cancellationInabilityHours: confirmation.data.cancellationInabilityHours,
//                                 modificationInabilityHours: confirmation.data.modificationInabilityHours,
//                                 revsId: confirmation.data.revsId, // معرف الحجز
//                               ),
//                             ),
//                           );
//                                                                     } else {
//                                       _showSnackBar(scaffoldContext, 'فشل تأكيد الحجز، حاول مرة أخرى');
//                                     }
//                                   }
//                                 : null,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xFFFF6200),
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                               elevation: 4,
//                               disabledBackgroundColor: Color(0xFFFFA270).withOpacity(0.5),
//                             ),
//                             child:const Text(
//                               'Confirm',
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Georgia'),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }

