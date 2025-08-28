import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/wallet/charge_wallet.dart';
import 'package:get/get.dart';
import 'dart:io';

class ChargeView extends StatelessWidget {
  const ChargeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChargeController controller = Get.put(ChargeController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Charge wallet ',
          style: TextStyle( fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade300,
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose the transfer method :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTransferMethodCard(
                    controller: controller,
                    method: 'bank',
                    label: 'Bank',
                    icon: Icons.account_balance,
                  ),
                  _buildTransferMethodCard(
                    controller: controller,
                    method: 'cash',
                    label: 'Cash',
                    icon: Icons.attach_money,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Amount :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) => controller.amount.value = value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter the amount ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Receipt image :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildImagePicker(controller),
              const SizedBox(height: 24),
              const Text(
                'Note :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) => controller.note.value = value,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: ' optional ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: controller.isLoading.value ? null : () => controller.submitChargeRequest(),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          ' Send ',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferMethodCard({
    required ChargeController controller,
    required String method,
    required String label,
    required IconData icon,
  }) {
    final isSelected = controller.transferMethod.value == method;
    return GestureDetector(
      onTap: () => controller.transferMethod.value = method,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.deepOrange : Colors.black54,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.deepOrange : Colors.black54,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.deepOrange : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(ChargeController controller) {
    return GestureDetector(
      onTap: () => controller.pickProofImage(),
      child: Obx(() {
        if (controller.proofImage.value != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(
              controller.proofImage.value!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey.shade300,
             //   style: BorderStyle.dashed,
                width: 2,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 50,
                  color: Colors.black45,
                ),
                SizedBox(height: 8),
                Text(
                  'Click to upload image ',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}