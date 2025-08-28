import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:flutter_application_restaurant/core/static/global_service.dart';
import 'package:flutter_application_restaurant/navigation_bar.dart';
import 'package:flutter_application_restaurant/navigation_bar.dart';
import 'package:flutter_application_restaurant/view/reservation/reservations_list_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../controller/reservations/reservations_list_controller.dart';
import '../../main.dart';

class ReservationConfirmationScreen extends StatefulWidget {
 final String selectedDate;
 final int guestsCount;
 final String revsDuration;
 final String selectedSlot;
 final String type;
 final String explanatoryNotes;
 final int confirmationTime;
 final int depositValue;
 final int tablesCount;
 final double cancellationInabilityHours;
 final double modificationInabilityHours;
 final int revsId;

 const ReservationConfirmationScreen({
 required this.guestsCount,
 required this.revsDuration,
 required this.selectedSlot,
 required this.type,
 required this.explanatoryNotes,
 required this.confirmationTime,
 required this.depositValue,
 required this.tablesCount,
 required this.cancellationInabilityHours,
 required this.modificationInabilityHours,
 required this.revsId, required this.selectedDate,

});
 @override

 _ReservationConfirmationScreenState createState() => _ReservationConfirmationScreenState();

}

class _ReservationConfirmationScreenState
   extends State<ReservationConfirmationScreen> {
   final TextEditingController _notesController = TextEditingController();
   bool _isAgreed = false;
   int _remainingTime = 0;
   late Timer _timer;
   GlobalServ myServices = Get.put(GlobalServ());
  final String link=Linkapi.backUrl;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.confirmationTime * 60; 
    _startTimer();
   // _showInitialSnackBar();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        _showSnackBar(context, 'Confirmation period has expired. Reservation has been cancelled.');
        Get.back();
      }
    });
  }

  // void _showInitialSnackBar() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _showSnackBar(context, 'The reservation has been provisionally confirmed. Please confirm within ${widget.confirmationTime} minutes');
  //   });
  // }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, ),
        backgroundColor: Colors.red[500],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveNotes() async {
    final String apiUrl =
        '${Linkapi.saveNotes}/${widget.revsId}';
    final String userNotes = _notesController.text.trim();
    final Map<String, dynamic> body =
        userNotes.isNotEmpty ? {'user_notes': userNotes} : {};

    if (kDebugMode) {
      print('Sending POST to: $apiUrl'); 
      print('Body: ${jsonEncode(body.isNotEmpty ? body : null)}'); 
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body.isNotEmpty ? body : null),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}'); 
        print('Response body: ${response.body}');
        print('r is $token');
        print('url is $apiUrl');
      }

      if (response.statusCode == 200) {
      //  _showSnackBar(context, 'تم حفظ الملاحظات بنجاح');
      print(' نجااااااح:   ${response.body}');
        _notesController.clear();
      } else {
        _showSnackBar(context, ' Alert : ${response.body}');
        print(' فششششششل:   ${response.body}');
      }
    } catch (e) {
      _showSnackBar(context, ' Alert : $e');
      print(' فششششششل:   $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _notesController.dispose();
    super.dispose();
  }

  

  Widget _buildBookingSummaryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem(
          icon: Icons.location_on,
          label: '${widget.type}',
          value: ' ',
        ),
        _buildSummaryItem(
          icon: Icons.access_time,
          label: '${widget.selectedSlot}',
          value: ' ',
        ),
        _buildSummaryItem(
          icon: Icons.calendar_today,
          label: '${widget.selectedDate}',
          value: ' ',
        ),
        _buildSummaryItem(
          icon: Icons.table_restaurant,
          label: '${widget.tablesCount} table ',
          value: ' ',
        ),
        _buildSummaryItem(
          icon: Icons.person,
          label: '${widget.guestsCount} guests ',
          value: ' ',
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepOrange),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Georgia'),
        ),
      ],
    );
  }

  Widget _buildRemainingTimeCard() {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: const BorderSide(color: Colors.black54, width: 2),),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           const Icon(Icons.hourglass_bottom, color: Colors.deepOrange),
            const Text(
              'Confirmation time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepOrange, width: 1.5),
              ),
              child: Text(
                '${_remainingTime ~/ 60}m ${_remainingTime % 60}s',
                style: const TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


Widget _buildReservationDetailsCard() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
             onTap: () {
               Navigator.of(context).pop();
             },  
            child:const Icon(Icons.mode_edit_outline_outlined,color: Colors.deepOrange),),
            const Text(
              ' Modification time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Georgia'
              ),
            ),
            InkWell(
                onTap: () {
                  Get.back();
           // Navigator.of(context).pop();
          },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepOrange, width: 1.5),
                ),
                child: Text(
                  '${widget.modificationInabilityHours} hours',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia'
                  ),
                ),
              ),
            ),
          ],
        ),
       const SizedBox(height: 15,),
       const Divider(height: 1,),
       const SizedBox(height: 15,),
        _buildDetailItem(
          icon: Icons.attach_money_rounded,
          label: 'Deposit value',
          value: '${widget.depositValue} EGP ',
          
        ),
       const SizedBox(height: 15,),
       const Divider(height: 1,),
      const  SizedBox(height: 15,),
        _buildDetailItem(
          icon: Icons.cancel_presentation_rounded,
          label: 'Cancellation time',
          value: '${widget.cancellationInabilityHours.toInt()} hours',
        ),
      ],
    ),
  );
}


Widget _buildDetailItem({required String label, required String value,required IconData icon}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Icon(icon,size: 25,color: Colors.deepOrange),
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
          fontFamily: 'Georgia'
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.deepOrange,
          fontWeight: FontWeight.bold,
          fontFamily: 'Georgia'

        ),
      ),
    ],
  );
}


Widget _buildPoliciesSection() {
    return Card(
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: const BorderSide(color: Colors.black54, width: 2),),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Explanatory Notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Georgia',
                color: Colors.deepOrange
              ),
            ),
          const  SizedBox(height: 15,),
       const Divider(height: 1,color: Colors.deepOrange),
      const  SizedBox(height: 15,),
            Text(
              widget.explanatoryNotes,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontFamily: 'Georgia',
                 fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialRequestSection() {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: const BorderSide(color: Colors.black12, width: 2),),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _notesController,
              textAlign: TextAlign.center,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Adding your comment here (optional) .',
                hintStyle:const TextStyle(color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptanceSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
         'I have read and agree to all Conditions.',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            decoration: TextDecoration.underline,
            fontFamily: 'Georgia'
          ),
        ),
        Checkbox(
          value: _isAgreed,
          onChanged: (value) {
            setState(() {
              _isAgreed = value!;
            });
          },
          activeColor: Colors.deepOrange,
        ),
      ],
    );
  }

  Widget _buildBookingButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isAgreed
            ? () async {
                await _saveNotes();
                controller.fetchReservations();
                Get.close(1);
                Get.off(ReservationsListView());
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          minimumSize: const Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Text(
          'Book',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }


  final ReservationsController controller = Get.find<ReservationsController>() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
  title:const Text(
    'Details',
    style: TextStyle(
      color: Colors.white, 
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
  ),
),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
           const SizedBox(height: 30,),
            _buildBookingSummaryRow(),
            //Divider(height: 1,color: Colors.deepOrange),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildRemainingTimeCard(),
                  
                  const SizedBox(height: 16),
                  _buildReservationDetailsCard(),
                  const SizedBox(height: 16),
                  _buildPoliciesSection(),
                  const SizedBox(height: 16),
                 const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_forward,color: Colors.black,),
                      Text(' Your notes :',textAlign: TextAlign.left,style: TextStyle(fontSize: 20),),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSpecialRequestSection(),
                  const SizedBox(height: 16),
                  _buildAcceptanceSection(),
                ],
              ),
            ),
            _buildBookingButton(),
          ],
        ),
      ),
    );
  }
}