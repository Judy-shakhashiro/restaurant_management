import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';



class LoginControllerImp extends GetxController {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
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
