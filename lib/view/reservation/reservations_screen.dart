import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/global_lotti.dart';
import 'package:flutter_application_restaurant/view/reservation/confirm_reservation_screen.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controller/reservations/reservation_controller.dart';
import '../../controller/reservations/reservations_list_controller.dart';


class ReservationsView extends StatelessWidget {
  final dynamic initialData;
  const ReservationsView({Key? key, this.initialData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ReserveController controller = Get.put(ReserveController(initialData: initialData));
    ReservationsController reservationsController = Get.find<ReservationsController>() ;

    const Color primaryColor = Color(0xFFFF6200);
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
                  child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 20),
                      const Text(
                        'Please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.red)
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                   onPressed: () {
                      controller.fetchAvailableDates();
                        }, // Retry fetch
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                  
                ),
                    ],
                  ),
                )
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
                      icon: Icon(Icons.add_circle, color: primaryColor),
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
                const MyLottiLoading()
              else

          Card(
            elevation: 10,
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
                  const MyLottiLoading()
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
                            print('is modifying $isModification');
                            print('confirmation ${confirmation?.statusCode}');
                            if (confirmation != null&&isModification==false) {
                              Get.snackbar(
                              'Success  ',
                              'The reservation has been provisionally confirmed. Please confirm within ${confirmation.data.confirmationTime} minutes',
                              backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );

                               Get.to(() => ReservationConfirmationScreen(
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
                            }
                            else if(confirmation != null&&isModification==true){
                              Get.snackbar(
                                'Modified successfully',
                                '',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );
                              reservationsController.fetchReservations();
                           //   Get.offUntil(GetPageRoute(page: ReservationsListView()), (route) => (route as GetPageRoute).page ==(()=>const MyHomePage()));
                             Get.close(1);
                            }
                            else {
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
                          label:  Text(
                           initialData==null?'Confirm':'Modify',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
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