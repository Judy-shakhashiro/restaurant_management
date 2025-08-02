import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';


abstract class Reset_controller extends GetxController {
  
}
class ResetControllerImp extends Reset_controller {
  
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController password;
  late TextEditingController password_confirmation;
 // late TextEditingController logout_oth_dev;


 bool isshowpassword = true;
 bool isshowpassword1 = true;
 bool logout_oth_dev=false;

  showPassword() {
    isshowpassword = !isshowpassword;
    update();
  }
  showPassword1() {
    isshowpassword1 = !isshowpassword1;
    update();
  }
   
  @override
  void onInit() {
    password = TextEditingController();
    password_confirmation  = TextEditingController() ;
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    password_confirmation.dispose();
    super.dispose();
  }
 
  


   }

