import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


abstract class Login_Controller extends GetxController {
  
  
}
class LoginControllerImp extends Login_Controller {
  
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  //final GlobalKey<FormState> formstate_otp = GlobalKey<FormState>();
  final GlobalKey<FormState> formstate_forget = GlobalKey<FormState>();
  late TextEditingController password;
  late TextEditingController email;
  late TextEditingController OTP;


 bool isshowpassword = true;

  showPassword() {
    isshowpassword = !isshowpassword;
    update();
  }

   
  @override
  void onInit() {

    password = TextEditingController();
    email  = TextEditingController() ;
    OTP =TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    email.dispose();
    OTP.dispose();
    super.dispose();
  }
 
  


   }
