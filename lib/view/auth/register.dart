import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/confirm_email/otp_confirm.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/button_login.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/textform_login.dart';
import '../../controller/auth/register_controller.dart';
import '../../core/functions/validation.dart';
import '../../services/auth/register/register_serv.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class VerifycodeForRegister extends StatelessWidget {
  final String email;

  const VerifycodeForRegister({Key? key, required this.email}) : super(key: key);

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
            'Email Verification',
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
            "The code is valid for 20 minutes and is used once. ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54,fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
          ),
          const Text(
            "Please check your email.We've sent a code to ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, fontFamily: 'Georgia'),
          ),
          Text(
            email,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Georgia', color: Colors.orange.shade900),
          ),
         // const SizedBox(height: 5),

          const SizedBox(height: 20),
          Flexible(
            child: Otp_confirm(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}


class Register extends StatelessWidget {
  Register({super.key});
  // This is the controller instance for the Register page.
  RegisterControllerImp controller1 = Get.put(RegisterControllerImp());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.18,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black54,
                    width: 4,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Lottie.asset('assets/lotti/Animation - 1751034189516 (1).json', fit: BoxFit.fitHeight),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        'Create New Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              // Key Change: This property is changed from `AutovalidateMode.disabled`
              // to `AutovalidateMode.onUserInteraction`. This ensures that
              // validation errors appear as soon as the user interacts with a text field,
              // which provides immediate feedback.

              key: controller1.formstate,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Textformlogin(
                      text: 'First Name',
                      iconData: Icons.person,
                      mycontoller: controller1.first_name,
                      isNumber: false,
                      validator: (val) {
                        return validInput(val!, 3, 20, "username");
                      },
                    ),
                    const SizedBox(height: 40),
                    Textformlogin(
                      text: 'Last Name',
                      iconData: Icons.person,
                      mycontoller: controller1.last_name,
                      isNumber: false,
                      validator: (val) {
                        return validInput(val!, 3, 20, "username");
                      },
                    ),
                    const SizedBox(height: 40),
                    Textformlogin(
                      text: 'Phone Number',
                      iconData: Icons.phone_android_outlined,
                      mycontoller: controller1.mobile,
                      isNumber: true,
                      validator: (val) {
                        return validInput(val!, 7, 11, "phone");
                      },
                    ),
                    const SizedBox(height: 40),
                    Textformlogin(
                      validator: (val) {
                        return validInput(val!, 5, 100, "email");
                      },
                      isNumber: false,
                      mycontoller: controller1.email,
                      text: "Email",
                      iconData: Icons.email,
                    ),
                    const SizedBox(height: 40),
                    GetBuilder<RegisterControllerImp>(
                      // Key Change: The variable name `cont` has been changed to `controller`
                      // to match the standard GetX builder pattern and avoid a potential
                      // runtime error. All uses of `cont` have been updated.
                        builder: (controller) => Textformlogin(
                          text: 'Password',
                          iconData: controller.isshowpassword ? Icons.visibility_off : Icons.visibility,
                          mycontoller: controller.password,
                          isNumber: false,
                          validator: (val) {
                            return validInput(val!, 8, 30, "password");
                          },
                          obscureText: controller.isshowpassword,
                          onTapIcon: () {
                            controller.showPassword();
                          },
                        )),
                    const SizedBox(height: 40),
                    GetBuilder<RegisterControllerImp>(
                      // Key Change: The variable name `cont` has been changed to `controller`.
                      builder: (controller) => Textformlogin(
                        text: 'Confirm Password',
                        iconData: controller.isshowpassword1 ? Icons.visibility_off : Icons.visibility,
                        mycontoller: controller.password_confirmation,
                        isNumber: false,
                        validator: (val) {
                          return validInput(val!, 8, 30, "password");
                        },
                        obscureText: controller.isshowpassword1,
                        onTapIcon: () {
                          controller.showPassword1();
                        },
                      ),),
                    const SizedBox(height: 20),
                    Buttonlogin(
                        text: "Let's go",
                        color: const Color(0xFFFFFEE58), // Changed to const
                        onPressed: () async{

                          if (controller1.formstate.currentState!.validate()) {
                            bool success =  await RegisterServ.register(
                              controller1.first_name.text,
                              controller1.last_name.text,
                              controller1.mobile.text,
                              controller1.email.text,
                              controller1.password.text,
                              controller1.password_confirmation.text,
                            );
                            // Get.back();

                            if (success) {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    content: VerifycodeForRegister(email: controller1.email.text),
                                  );
                                },
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to send verification code. Please try again.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange.shade100,
                                colorText: Colors.black,
                              );
                            }
                          } else {
                            Get.snackbar(
                              'Validation Error',
                              'Please fill in all fields correctly.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.black,
                            );
                          }}),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
