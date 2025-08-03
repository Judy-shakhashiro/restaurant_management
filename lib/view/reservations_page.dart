import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // A dependency for a nice loading spinner
import '../controller/reservations_controller.dart';
import '../model/reservations_model.dart';
class ReservationsView extends StatelessWidget {
  // Instantiate the controller. GetX will manage its lifecycle.
  final ReservationsController controller = Get.put(ReservationsController());

  ReservationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Reservations'),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        // Obx listens to the observable variables in the controller and
        // rebuilds its widget tree automatically when they change.
        body: Obx(() {
          if (controller.isLoading.value) {
            // Show a loading spinner while data is being fetched.
            return const Center(
              child: SpinKitFadingCube(
                color: Colors.deepOrange,
                size: 50.0,
              ),
            );
          } else if (controller.errorMessage.isNotEmpty) {
            // Show an error message if something went wrong.
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (controller.categorizedReservations.isEmpty) {
            // Handle the case where there are no reservations.
            return const Center(
              child: Text(
                'No reservations found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            // Display the list of reservations using a TabBarView
            return TabBarView(
              children: [
                // Upcoming Reservations Tab
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.categorizedReservations['Upcoming Reservations']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final reservation = controller.categorizedReservations['Upcoming Reservations']![index];
                    return ReservationCard(reservation: reservation);
                  },
                ),
                // Past Reservations Tab
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.categorizedReservations['Past Reservations']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final reservation = controller.categorizedReservations['Past Reservations']![index];
                    return ReservationCard(reservation: reservation);
                  },
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  const ReservationCard({super.key, required this.reservation});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'not_confirmed':
        return Colors.orange;
      case 'pending':
        return Colors.yellow.shade800;
      case 'cancelled':
        return Colors.white;
      case 'accepted':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Fetch the detailed reservation and navigate to the details view
        Get.find<ReservationsController>().fetchSingleReservation(reservation.id);
        Get.to(() => const ReservationDetailsView());
      },
      child: Card(
        color: Colors.white,
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for the reservation ID and status.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reservation #${reservation.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(reservation.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      GetStringUtils(reservation.status.replaceAll('_', ' ')).capitalizeFirst!,
                      style: TextStyle(
                        color:reservation.status=='cancelled'? Colors.black54:Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              // Row for date and time.
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.deepOrange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${reservation.revsDate} at ${reservation.revsTime}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row for guests and duration.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.people, color: Colors.deepOrange, size: 20),
                        const SizedBox(width: 8),
                        Expanded( // Fix applied here
                          child: Text(
                            'Guests: ${reservation.guestsCount}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.deepOrange, size: 20),
                        const SizedBox(width: 8),
                        Expanded( // Fix applied here
                          child: Text(
                            'Duration: ${reservation.revsDuration}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row for tables count and deposit value.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.table_restaurant, color: Colors.deepOrange, size: 20),
                        const SizedBox(width: 8),
                        Expanded( // Fix applied here
                          child: Text(
                            'Tables: ${reservation.tablesCount}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.deepOrange, size: 20),
                        const SizedBox(width: 8),
                        Expanded( // Fix applied here
                          child: Text(
                            'Deposit: \$${reservation.depositValue?.toStringAsFixed(2) ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Display cancellability and modifiability status
              if (reservation.acceptedCancellability == true || reservation.acceptedModifiability == true || reservation.status == 'not_confirmed')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Wrap(
                      spacing: 8.0, // Gap between adjacent buttons
                      runSpacing: 4.0, // Gap between rows of buttons
                      children: [
                        if (reservation.acceptedModifiability == true)
                          ElevatedButton(
                            onPressed: () {
                              if (reservation.modifiabilityNow == true) {
                                Get.defaultDialog(
                                  title: "Confirm Modification",
                                  cancelTextColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  titleStyle: const TextStyle(fontSize: 16),
                                  middleText: "Are you sure you want to modify reservation #${reservation.id}?",
                                  confirm: TextButton(
                                    onPressed: () {
                                      Get.back(); // Close the dialog
                                      // In a real app, you would call a modify API here
                                      Get.snackbar('Success', 'Your reservation has been modified successfully.', backgroundColor: Colors.green, colorText: Colors.white);
                                    },
                                    child: const Text("Yes", style: TextStyle(color: Colors.deepOrange)),
                                  ),
                                  cancel: TextButton(
                                    onPressed: () {
                                      Get.back(); // Close the dialog
                                    },
                                    child: const Text("No",style: TextStyle(color: Colors.black87)),
                                  ),
                                );
                              } else {
                                Get.defaultDialog(
                                  title: "Modification Not Allowed",
                                  backgroundColor: Colors.white,
                                  titleStyle: const TextStyle(fontSize: 16),
                                  cancelTextColor: Colors.black,
                                  middleText: "You cannot modify this reservation. The time limit for modification has been reached.",
                                  confirm: TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("OK", style: TextStyle(color: Colors.deepOrange)),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Modify'),
                          ),
                        if (reservation.acceptedCancellability == true)
                          ElevatedButton(
                            onPressed: () {
                              if (reservation.cancellabilityNow == true) {
                                // Show confirmation dialog before canceling
                                Get.defaultDialog(
                                  backgroundColor: Colors.white,
                                  title: "Cancel Reservation",
                                  cancelTextColor: Colors.black,
                                  titleStyle: const TextStyle(fontSize: 16),
                                  middleText: "Are you sure you want to cancel reservation #${reservation.id}?",
                                  confirm: TextButton(
                                    onPressed: () {
                                      Get.back(); // Close the dialog
                                      Get.find<ReservationsController>().cancelReservation(reservation.id);
                                    },
                                    child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                  ),
                                  cancel: TextButton(
                                    onPressed: () {
                                      Get.back(); // Close the dialog
                                    },
                                    child: const Text("No",style: TextStyle(color: Colors.black87)),
                                  ),
                                );
                              } else {
                                Get.defaultDialog(
                                  backgroundColor: Colors.white,
                                  title: "Cancellation Not Allowed",
                                  titleStyle: const TextStyle(fontSize: 16),
                                  middleText: "You cannot cancel this reservation. The time limit for cancellation has been reached.",
                                  confirm: TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("OK", style: TextStyle(color: Colors.deepOrange)),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white38,
                              foregroundColor: Colors.black54,
                            ),
                            child: const Text('Cancel'),
                          ),
                        if (reservation.status == 'not_confirmed')
                          ElevatedButton(
                            onPressed: () {
                              // This would navigate to a confirmation page in a real app.
                              Get.snackbar('Confirming...', 'Redirecting to confirmation page...', backgroundColor: Colors.blueGrey, colorText: Colors.white);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Confirm'),
                          ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// A new widget to display the full reservation details
class ReservationDetailsView extends StatelessWidget {
  const ReservationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ReservationsController controller = Get.find<ReservationsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Obx(() {
        final reservation = controller.selectedReservation.value;
        if (reservation == null) {
          return const Center(child: Text('No reservation details found.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reservation #${reservation.id}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey[300]),
                      _buildDetailRow('Status', GetStringUtils(reservation.status.replaceAll('_', ' ')).capitalizeFirst!),
                      _buildDetailRow('Type', GetStringUtils(reservation.type).capitalizeFirst!),
                      _buildDetailRow('Date', reservation.revsDate),
                      _buildDetailRow('Time', reservation.revsTime),
                      _buildDetailRow('Duration', reservation.revsDuration),
                      _buildDetailRow('Guests', reservation.guestsCount.toString()),
                      _buildDetailRow('Tables', reservation.tablesCount.toString()),
                      _buildDetailRow('Deposit Value', '\$${reservation.depositValue?.toStringAsFixed(2) ?? 'N/A'}'),
                      _buildDetailRow('Deposit Status', GetStringUtils(reservation.depositStatus??'N/A').capitalizeFirst ?? 'N/A'),
                      _buildDetailRow('Note', reservation.note ?? 'No note'),
                      _buildDetailRow('Created At', reservation.createdAt ?? 'N/A'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cancellation & Modification Policy',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow('Cancellation Allowed', reservation.acceptedCancellability == true ? 'Yes' : 'No'),
                      if (reservation.acceptedCancellability == true)
                        _buildDetailRow('Cancellation Inability Hours', reservation.cancellationInabilityHours?.toString() ?? 'N/A'),
                      _buildDetailRow('Modification Allowed', reservation.acceptedModifiability == true ? 'Yes' : 'No'),
                      if (reservation.acceptedModifiability == true)
                        _buildDetailRow('Modification Inability Hours', reservation.modificationInabilityHours?.toString() ?? 'N/A'),
                      _buildDetailRow('Auto No-Show Minutes', reservation.autoNoShowMinutes?.toString() ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Reservations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: ReservationsView(),
    );
  }
}

// A simple extension to capitalize the first letter of a string.
extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}