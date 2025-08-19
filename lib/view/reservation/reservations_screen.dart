import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:flutter_application_restaurant/view/reservation/confirm_reservation_screen.dart';
import 'package:flutter_application_restaurant/view/reservation/reservations_list_page.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controller/reservations/reservation_controller.dart';
import '../../main.dart';

class ReservationsView extends StatelessWidget {
  // Optional parameter to pass initial reservation data for modification
  final dynamic initialData;
  const ReservationsView({Key? key, this.initialData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ReserveController controller = Get.put(ReserveController(initialData: initialData));
    final Color primaryColor = const Color(0xFFFF6200);
    final Color disabledColor = const Color(0xFFFFA270).withOpacity(0.5);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Reservation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Georgia',
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6200), Color(0xFFE53935)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          // The UI rebuilds automatically when any observable in the controller changes.
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
                  const Text(
                    'Guests ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Georgia'),
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
                      icon: Icon(Icons.remove_circle, color: primaryColor),
                    ),
                    Card(
                      elevation: 5,
                      color: Colors.white60,
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
              const Text(
                'Date ',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'Georgia'),
              ),
              const SizedBox(height: 15),
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator(color: Color(0xFFFF6200)))
              else
                Card(
                  elevation: 5,
                  color: Colors.white70,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: controller.focusedDay.value,
                      selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        if (controller.isDayAvailable(selectedDay)) {
                          controller.updateSelectedDay(selectedDay, focusedDay);
                        }
                      },
                      onPageChanged: (focusedDay) {
                        controller.focusedDay.value = focusedDay;
                        controller.resetSelectionsIfNeeded(focusedDay);
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final isAvailable = controller.isDayAvailable(day);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: isAvailable ? Colors.black54 : Colors.grey.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isAvailable ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      calendarStyle: const CalendarStyle(
                        outsideTextStyle: TextStyle(color: Colors.black54, fontFamily: 'Georgia'),
                        weekendTextStyle: TextStyle(color: Colors.black54, fontFamily: 'Georgia'),
                        todayDecoration: BoxDecoration(
                          color: Color(0xFFFFA270),
                          shape: BoxShape.circle,
                        ),
                        tableBorder: TableBorder(
                          top: BorderSide(color: Colors.deepOrange, width: 2),
                        ),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.black, fontFamily: 'Georgia'),
                        weekendStyle: TextStyle(color: Colors.black, fontFamily: 'Georgia'),
                      ),
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        titleTextStyle: TextStyle(color: Colors.deepOrange, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                        formatButtonVisible: false,
                        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.deepOrange),
                        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.deepOrange),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (controller.reservationData.value != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Duration',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Georgia'),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      children: List.generate(
                        controller.reservationData.value!.data.maxRevsDurationHours * 2,
                            (index) => (index + 1) * 30,
                      ).map((minutes) {
                        final formattedDuration = controller.formatDuration(minutes);
                        final bool isSelected = controller.selectedDuration.value == formattedDuration;
                        return ChoiceChip(
                          label: Text(formattedDuration),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.updateSelectedDuration(formattedDuration);
                            }
                          },
                          selectedColor: primaryColor,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: primaryColor, width: 2),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (controller.selectedDay.value == null || controller.selectedGuests.value == null || controller.selectedDuration.value == null)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'يرجى اختيار التاريخ وعدد الأشخاص والمدة لعرض الأوقات المتاحة',
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
                            const Text(
                              'Indoor :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.timeSlots.value!.timeSlots.indoor.map((time) {
                                final isSelected = controller.selectedTime.value == time && controller.selectedType.value == 'indoor';
                                return GestureDetector(
                                  onTap: () => controller.updateSelectedTime(time, 'indoor'),
                                  child: Container(
                                    width: 80,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                      color: isSelected ? primaryColor : Colors.white54,
                                      border: Border.all(color: primaryColor, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        time,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'Georgia',
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      if (controller.timeSlots.value!.timeSlots.outdoor.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Outdoor :',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.timeSlots.value!.timeSlots.outdoor.map((time) {
                                final isSelected = controller.selectedTime.value == time && controller.selectedType.value == 'outdoor';
                                return GestureDetector(
                                  onTap: () => controller.updateSelectedTime(time, 'outdoor'),
                                  child: Container(
                                    width: 80,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                      color: isSelected ? primaryColor : Colors.white54,
                                      border: Border.all(color: primaryColor, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        time,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'Georgia',
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
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
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 5),
                              ): Get.snackbar(
                                'تم تأكيد الحجز',
                                'تم تأكيد الحجز مؤقتًا، يرجى التأكيد خلال ${confirmation.data.confirmationTime} دقائق',
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 5),
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
                                'فشل تأكيد الحجز',
                                'فشل تأكيد الحجز، حاول مرة أخرى',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            disabledBackgroundColor: disabledColor,
                          ),
                          icon: const Icon(Icons.check_circle_outline),
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