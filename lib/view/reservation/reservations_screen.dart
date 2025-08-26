import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/reservation/confirm_reservation_screen.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controller/reservations/reservation_controller.dart';


class ReservationsView extends StatelessWidget {

  final dynamic initialData;
  const ReservationsView({Key? key, this.initialData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ReserveController controller = Get.put(ReserveController(initialData: initialData));
  //  final Color primaryColor = const Color(0xFFFF6200);
    final Color disabledColor = const Color(0xFFFFA270).withOpacity(0.5);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Reservation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.grey.shade300,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.errorMessage.value != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    controller.errorMessage.value!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const  Row(
                    children: [
                      Icon(Icons.arrow_forward,color: Colors.black,),
                       Text(
                        ' Guests :',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Georgia'),
                      ),
                    ],
                  ),
                  Text(
                    '(${controller.reservationData.value?.data.minPeople ?? 2} - ${controller.reservationData.value?.data.maxPeople ?? 20})',
                    style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (controller.reservationData.value != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 45,
                      onPressed: controller.selectedGuests.value > controller.reservationData.value!.data.minPeople
                          ? controller.decrementGuests
                          : null,
                      icon:const Icon(Icons.remove_circle, color: Colors.deepOrange),
                    ),
                    Card(
                      elevation: 5,
                      //Theme.of(context).cardColor
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                        child: Text(
                          controller.selectedGuests.value.toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 40,
                      onPressed: controller.incrementGuests,
                      icon:const Icon(Icons.add_circle, color: Colors.deepOrange),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
             const Row(
                children: [
                  Icon(Icons.arrow_forward,color: Colors.black,),
                   Text(
                    ' Date : ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Georgia'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator(color: Color(0xFFFF6200)))
              else
                
  Card(
    elevation: 10,
    //Theme.of(context).cardColor
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Colors.black54, width: 2), 
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: controller.focusedDay.value,
        selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
      onDaySelected: (selectedDay, focusedDay) {

  if (controller.isDayAvailable(selectedDay)) {
    controller.updateSelectedDay(selectedDay, focusedDay);
  } else {
    Get.snackbar(
      'Alert',
      'This day is not available for booking.',
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }
},
        onPageChanged: (focusedDay) {
          controller.focusedDay.value = focusedDay;
          controller.resetSelectionsIfNeeded(focusedDay);
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final isAvailable = controller.isDayAvailable(day);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isAvailable ? Colors.black87 : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAvailable ? Colors.green.shade600 : Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            return Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6200),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: const TextStyle(color: Colors.deepOrange, fontFamily: 'Georgia', fontWeight: FontWeight.bold),
          todayDecoration: BoxDecoration(
            color: Colors.deepOrange.withOpacity(0.2), 
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
          weekendStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
        ),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          titleTextStyle: TextStyle(color: Colors.deepOrange, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.deepOrange, size: 28),
          rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.deepOrange, size: 28),
        ),
      ),
    ),
  ),


              const SizedBox(height: 20),
              if (controller.reservationData.value != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   const Icon(Icons.arrow_forward,color: Colors.black,),
                    const Text(
                      ' Time :   ',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Georgia'),
                    ),
                    const SizedBox(height: 10),
                     Expanded(
                    child: Card(
                      elevation: 5,
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding:const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        child: DropdownButton<String>(
                          style:const TextStyle(color: Colors.black, fontFamily: 'Georgia'),
                          hint:const Text('Duration', textAlign: TextAlign.center),
                          value: controller.selectedDuration.value, 
                          isExpanded: true,
                          items: List.generate(
                            controller.reservationData.value!.data.maxRevsDurationHours * 2,
                            (index) => (index + 1) * 30,
                          ).map((minutes) {
                            final formattedDuration = controller.formatDuration(minutes);
                            return DropdownMenuItem<String>(
                              value: formattedDuration,
                              child: Text(
                                controller.formatDurationDisplay(minutes),
                                style:const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateSelectedDuration(value);
                            }
                          },
                          underline:const SizedBox(),
                          icon:const Icon(Icons.arrow_drop_down, color: Colors.deepOrange,size: 40,),
                        ),
                      ),
                    ),
                  )
                  ],
                ),
              const SizedBox(height: 20),
              if (controller.selectedDay.value == null || controller.selectedGuests.value == null || controller.selectedDuration.value == null)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Please select the date, number of people and duration to view available times.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                  ),
                ),
              if (controller.selectedDay.value != null && controller.selectedGuests.value != null && controller.selectedDuration.value != null)
                if (controller.timeSlots.value == null)
                  const Center(child: CircularProgressIndicator(color: Color(0xFFFF6200)))
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.timeSlots.value!.timeSlots.indoor.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           const Row(
                              children: [
                                Icon(Icons.arrow_forward,color: Colors.black,),
                                 Text(
                                  ' Indoor :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                   SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.timeSlots.value!.timeSlots.indoor.map((time) {
                        final isSelected = controller.selectedTime.value == time && controller.selectedType.value == 'indoor';
                        return GestureDetector(
                          onTap: () => controller.updateSelectedTime(time, 'indoor'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            width: 90,
                            height: 50,
                            decoration: isSelected
                                ?
                                 BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // gradient: const LinearGradient(
                                    //   colors: [Color(0xFFFFA270), Color(0xFFFF6200)],
                                    //   begin: Alignment.topLeft,
                                    //   end: Alignment.bottomRight,
                                    // ),
                                    color: Colors.deepOrange,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  )
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300),
                                    color: Colors.white,
                                  ),
                            child: Center(
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      if (controller.timeSlots.value!.timeSlots.outdoor.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           const  Row(
                               children: [
                                Icon(Icons.arrow_forward,color: Colors.black,),
                                 Text(
                                  ' Outdoor :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Georgia',
                                  ),
                                                             ),
                               ],
                             ),
                            const SizedBox(height: 20),
                            SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.timeSlots.value!.timeSlots.outdoor.map((time) {
                                final isSelected = controller.selectedTime.value == time && controller.selectedType.value == 'outdoor';
                          return GestureDetector(
                            onTap: () => controller.updateSelectedTime(time, 'outdoor'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(horizontal: 6.0),
                              width: 90,
                              height: 50,
                              decoration: isSelected
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      // gradient: const LinearGradient(
                                      //   colors: [Color(0xFFFFA270), Color(0xFFFF6200)],
                                      //   begin: Alignment.topLeft,
                                      //   end: Alignment.bottomRight,
                                      // ),
                                      color: Colors.deepOrange,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey.shade300),
                                      color: Colors.white,
                                    ),
                              child: Center(
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                                              ],
                        ),
                      if (controller.timeSlots.value!.timeSlots.indoor.isEmpty && controller.timeSlots.value!.timeSlots.outdoor.isEmpty)
                        const Text(
                          'No available time slotes please chosse another duration',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                        ),
                      const SizedBox(height: 20),
                      if (controller.timeSlots.value!.timeSlots.indoor.isNotEmpty || controller.timeSlots.value!.timeSlots.outdoor.isNotEmpty)
                        const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: controller.isConfirmButtonEnabled()
                              ? () async {
                            final bool isModification = initialData != null;
                            final confirmation = await controller.confirmReservation();
                            if (confirmation != null) {
                              isModification?Get.snackbar(
                                'Modified successfully',
                                '',
                                backgroundColor: Colors.green[200],
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 5),
                              ): Get.snackbar(
                                'Success  ',
                                'The reservation has been provisionally confirmed. Please confirm within ${confirmation.data.confirmationTime} minutes',
                                backgroundColor: Colors.green[400],
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );

                             isModification? Get.back(): Get.to(() => ReservationConfirmationScreen(
                                selectedDate: controller.selectedDay.value!.toIso8601String().substring(0, 10),
                                guestsCount: controller.selectedGuests.value,
                                revsDuration: controller.selectedDuration.value!,
                                selectedSlot: controller.selectedTime.value!,
                                type: controller.selectedType.value!,
                                explanatoryNotes: confirmation.data.explanatoryNotes,
                                confirmationTime: confirmation.data.confirmationTime,
                                depositValue: confirmation.data.depositValue,
                                tablesCount: confirmation.data.tablesCount,
                                cancellationInabilityHours: confirmation.data.cancellationInabilityHours,
                                modificationInabilityHours: confirmation.data.modificationInabilityHours,
                                revsId: confirmation.data.revsId,
                              ));
                            } else {
                              Get.snackbar(
                                ' Alert ',
                                'Booking confirmation failed. Try again.',
                                backgroundColor: Colors.red[500],
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            elevation: 6,
                            disabledBackgroundColor: disabledColor,
                          ),
                          icon: const Icon(Icons.check_circle_outline,size: 25,),
                          label: const Text(
                            'Confirm',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                          ),
                        ),
                      ),
                    ],
                  ),
            ],
          );
        }),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_application_restaurant/controller/reservations/reservation_controller.dart';
// import 'package:flutter_application_restaurant/view/reservation/confirm_reservation_screen.dart';
// import 'package:get/get.dart';
// import 'package:table_calendar/table_calendar.dart';


// class ReservationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ReservationController());
//     print('Building ReservationScreen...');
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Reservation',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 25,
//             fontFamily: 'Georgia',
//           ),
//         ),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFFFF6200), Color(0xFFE53935)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         elevation: 10,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Obx(
//           () {
//             if (controller.isLoading.value) {
//               return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6200)));
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (controller.errorMessage.value != null)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Text(
//                       controller.errorMessage.value!,
//                       style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Guests ',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22,
//                           fontFamily: 'Georgia'),
//                     ),
//                     Text(
//                       '(${controller.reservationData.value?.data.minPeople ?? 2} - ${controller.reservationData.value?.data.maxPeople ?? 20})',
//                       style: const TextStyle(
//                           color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       iconSize: 45,
//                       onPressed: controller.selectedGuests.value > controller.reservationData.value!.data.minPeople
//                           ? controller.decrementGuests
//                           : null,
//                       icon: const Icon(Icons.remove_circle, color: Color(0xFFFF6200)),
//                     ),
//                     Card(
//                       elevation: 5,
//                       color: Colors.white60,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 10),
//                         child: Text(
//                           controller.selectedGuests.value.toString(),
//                           style: const TextStyle(color: Colors.black, fontSize: 25),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       iconSize: 40,
//                       onPressed: controller.incrementGuests,
//                       icon: const Icon(Icons.add_circle, color: Color(0xFFFF6200)),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Date ',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22,
//                       fontFamily: 'Georgia'),
//                 ),
//                 const SizedBox(height: 15),
//                 Card(
//                   elevation: 5,
//                   color: Colors.white70,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: TableCalendar(
//                       firstDay: DateTime.utc(2020, 1, 1),
//                       lastDay: DateTime.utc(2030, 12, 31),
//                       focusedDay: controller.focusedDay.value,
//                       selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
//                       onDaySelected: controller.onDaySelected,
//                       onPageChanged: controller.onPageChanged,
//                       calendarBuilders: CalendarBuilders(
//                         defaultBuilder: (context, day, focusedDay) {
//                           if (controller.reservationData.value != null) {
//                             for (var availableDate in controller.reservationData.value!.data.availableDate) {
//                               if (isSameDay(day, availableDate.date)) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       '${day.day}',
//                                       style: const TextStyle(
//                                         color: Colors.black54,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
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
//                           }
//                           return null;
//                         },
//                         selectedBuilder: (context, day, focusedDay) {
//                           return Center(
//                             child: Container(
//                               width: 36,
//                               height: 36,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: const Color(0xFFFF6200), width: 2),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   '${day.day}',
//                                   style: const TextStyle(
//                                     color: Color(0xFFFF6200),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       calendarStyle: const CalendarStyle(
//                         outsideTextStyle: TextStyle(color: Colors.black54, fontFamily: 'Georgia'),
//                         weekendTextStyle: TextStyle(color: Colors.black54, fontFamily: 'Georgia'),
//                         todayDecoration: BoxDecoration(
//                           color: Color(0xFFFFA270),
//                           shape: BoxShape.circle,
//                         ),
//                         tableBorder: TableBorder(
//                           top: BorderSide(color: Colors.deepOrange, width: 2),
//                         ),
//                       ),
//                       daysOfWeekStyle: const DaysOfWeekStyle(
//                         weekdayStyle: TextStyle(color: Colors.black, fontFamily: 'Georgia'),
//                         weekendStyle: TextStyle(color: Colors.black, fontFamily: 'Georgia'),
//                       ),
//                       headerStyle: const HeaderStyle(
//                         titleCentered: true,
//                         titleTextStyle: TextStyle(
//                             color: Colors.deepOrange,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Georgia'),
//                         formatButtonVisible: false,
//                         leftChevronIcon: Icon(Icons.chevron_left, color: Colors.deepOrange),
//                         rightChevronIcon: Icon(Icons.chevron_right, color: Colors.deepOrange),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Time ',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           fontFamily: 'Georgia'),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Card(
//                         elevation: 5,
//                         color: Colors.white60,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
//                           child: DropdownButton<String>(
//                             style: const TextStyle(color: Colors.black, fontFamily: 'Georgia'),
//                             hint: const Text('Duration', textAlign: TextAlign.center),
//                             value: controller.selectedDuration.value,
//                             isExpanded: true,
//                             items: List.generate(
//                               controller.reservationData.value!.data.maxRevsDurationHours * 2,
//                                   (index) => (index + 1) * 30,
//                             ).map((minutes) {
//                               final formattedDuration = controller.formatDuration(minutes);
//                               return DropdownMenuItem<String>(
//                                 value: formattedDuration,
//                                 child: Text(
//                                   controller.formatDurationDisplay(minutes),
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Georgia',
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: controller.onDurationChanged,
//                             underline: const SizedBox(),
//                             icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFF6200)),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 if (controller.selectedDay.value == null ||
//                     controller.selectedGuests.value == null ||
//                     controller.selectedDuration.value == null)
//                   const Padding(
//                     padding: EdgeInsets.only(bottom: 10.0),
//                     child: Text(
//                       'يرجى اختيار التاريخ وعدد الأشخاص والمدة لعرض الأوقات المتاحة',
//                       style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
//                     ),
//                   ),
//                 if (controller.selectedDay.value != null &&
//                     controller.selectedGuests.value != null &&
//                     controller.selectedDuration.value != null)
//                   if (controller.timeSlots.value == null)
//                     const Center(child: CircularProgressIndicator(color: Color(0xFFFF6200)))
//                   else
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (controller.timeSlots.value!.timeSlots.indoor.isNotEmpty)
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Indoor :',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontFamily: 'Georgia',
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Wrap(
//                                 spacing: 8,
//                                 runSpacing: 8,
//                                 children: controller.timeSlots.value!.timeSlots.indoor.map((time) {
//                                   final isSelected =
//                                       controller.selectedTime.value == time && controller.selectedType.value == 'indoor';
//                                   return GestureDetector(
//                                     onTap: () => controller.onTimeSlotSelected(time, 'indoor'),
//                                     child: Container(
//                                       width: 80,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: isSelected ? const Color(0xFFFF6200) : Colors.white54,
//                                         border: Border.all(color: const Color(0xFFFF6200), width: 2),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.withOpacity(0.4),
//                                             spreadRadius: 2,
//                                             blurRadius: 5,
//                                             offset: const Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           time,
//                                           style: TextStyle(
//                                             color: isSelected ? Colors.white : const Color(0xFFFF6200),
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15,
//                                             fontFamily: 'Georgia',
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                               const SizedBox(height: 20),
//                             ],
//                           ),
//                         if (controller.timeSlots.value!.timeSlots.outdoor.isNotEmpty)
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Outdoor :',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontFamily: 'Georgia',
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Wrap(
//                                 spacing: 8,
//                                 runSpacing: 8,
//                                 children: controller.timeSlots.value!.timeSlots.outdoor.map((time) {
//                                   final isSelected =
//                                       controller.selectedTime.value == time && controller.selectedType.value == 'outdoor';
//                                   return GestureDetector(
//                                     onTap: () => controller.onTimeSlotSelected(time, 'outdoor'),
//                                     child: Container(
//                                       width: 80,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: isSelected ? const Color(0xFFFF6200) : Colors.white54,
//                                         border: Border.all(color: const Color(0xFFFF6200), width: 2),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.withOpacity(0.4),
//                                             spreadRadius: 2,
//                                             blurRadius: 5,
//                                             offset: const Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           time,
//                                           style: TextStyle(
//                                             color: isSelected ? Colors.white : const Color(0xFFFF6200),
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15,
//                                             fontFamily: 'Georgia',
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ),
//                         if (controller.timeSlots.value!.timeSlots.indoor.isEmpty &&
//                             controller.timeSlots.value!.timeSlots.outdoor.isEmpty)
//                           const Text(
//                             'No available time slotes please chosse another duration',
//                             style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
//                           ),
//                         const SizedBox(height: 20),
//                         Center(
//                           child: ElevatedButton(
//                             onPressed: controller.isConfirmButtonEnabled()
//                                 ? () async {
//                               print(
//                                   'Confirmed: Day: ${controller.selectedDay.value}, Guests: ${controller.selectedGuests.value}, Duration: ${controller.selectedDuration.value}, Time: ${controller.selectedTime.value}, Type: ${controller.selectedType.value}');
//                               final confirmation = await controller.confirmReservation();
//                               if (confirmation != null) {
//                                 Get.snackbar(
//                                   'تم الحجز',
//                                   'تم تأكيد الحجز مؤقتًا، يرجى التأكيد خلال ${confirmation.data.confirmationTime} دقائق',
//                                   backgroundColor: Colors.green,
//                                   colorText: Colors.white,
//                                   snackPosition: SnackPosition.BOTTOM,
//                                 );
//                                 Get.to(ReservationConfirmationScreen(
//                                   selectedDate: controller.selectedDay.value!.toIso8601String().substring(0, 10),
//                                 guestsCount: controller.selectedGuests.value,
//                                 revsDuration: controller.selectedDuration.value!,
//                                 selectedSlot: controller.selectedTime.value!,
//                                 type: controller.selectedType.value!,
//                                 explanatoryNotes: confirmation.data.explanatoryNotes,
//                                 confirmationTime: confirmation.data.confirmationTime,
//                                 depositValue: confirmation.data.depositValue,
//                                 tablesCount: confirmation.data.tablesCount,
//                                 cancellationInabilityHours: confirmation.data.cancellationInabilityHours,
//                                 modificationInabilityHours: confirmation.data.modificationInabilityHours,
//                                 revsId: confirmation.data.revsId,

//                                 ));
//                               }
//                             }
//                                 : null,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFFFF6200),
//                               padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             ),
//                             child: const Text(
//                               'Confirm Reservation',
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontFamily: 'Georgia'),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }