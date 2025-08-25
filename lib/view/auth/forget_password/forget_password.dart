import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/forget_password/otp_verify.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/button_login.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/textform_login.dart';
import 'package:flutter_application_restaurant/view/profile/button.dart';
import '../../../controller/auth/login_controller.dart';
import '../../../core/functions/validation.dart';
import '../../../services/auth/login/forget_password/forget_serv.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerifycodeContent extends StatelessWidget {
  final String email;

  const VerifycodeContent({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.grey[700]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // const SizedBox(height: 10),
          const Text(
            'Get Your Code',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Divider(
              thickness: 2,
              color: Colors.orange.shade900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please enter the digit code that \n send to',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, fontFamily: 'Georgia'),
          ),
          Text(
            email,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Georgia', color: Colors.orange.shade900),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: Otp_verify(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
class Forgetpassword extends StatelessWidget {
  const Forgetpassword({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    LoginControllerImp controller3 = Get.put(LoginControllerImp());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Forget Password',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange.shade500,
      ),
      body: Form( 
        key: controller3.formstate_forget, 
        child: ListView(
          children: [
            SizedBox(height: size.height * 0.04),
            Lottie.asset('assets/lotti/forgetpass.json',
                fit: BoxFit.fitHeight, height: size.height * 0.3, width: size.width),
            const SizedBox(height: 30),
            const Text(
              'Mail Adress Here',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Georgia'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Divider(
                thickness: 2,
                color: Colors.orange.shade900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter the email address associated \n with your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Georgia'),
            ),
            const SizedBox(height: 50),
            Textformlogin(
              text: 'Email',
              iconData: Icons.email_outlined,
              mycontoller: controller3.email,
              isNumber: false,
              validator: (val) {
                return validInput(val!, 5, 100, "email");
              },
            ),
            const SizedBox(height: 70),
           Center(
             child: ElevatedButton.icon(
              onPressed: () async {
                  if (controller3.formstate_forget.currentState!.validate()) {
                    bool success = await ForgetServ.forget(controller3.email.text);
                    if (success) {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero, 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), 
                            ),
                            content: VerifycodeContent(email: controller3.email.text),
                          );
                        },
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Failed to send verification code. Please try again.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red[500],
                      );
                    }
                  } else {
                    Get.back();
                    Get.snackbar(
                      'Validation Error',
                      'Please fill in all fields correctly.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange,
                      colorText: Colors.black,
                    );
                  }
                },
             // icon: const Icon(Icons.shopping_cart, color: Colors.black),
              label: const Text(
                'Send Otp',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
                       ),
           ),
          ],
        ),
      ),
    );
  }
}