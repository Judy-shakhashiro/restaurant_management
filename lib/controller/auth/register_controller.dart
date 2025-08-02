
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class Register_Controller extends GetxController {
  
  
}
class RegisterControllerImp extends Register_Controller{
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController mobile;
  late TextEditingController password;
  late TextEditingController first_name;
  late TextEditingController last_name;
  late TextEditingController password_confirmation;
  late TextEditingController email;


 bool isshowpassword1 = true;
 bool isshowpassword = true;

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
    mobile= TextEditingController();
    password = TextEditingController();
    first_name= TextEditingController();
    last_name= TextEditingController();
    password_confirmation = TextEditingController();
    email  = TextEditingController() ;
    super.onInit();
  }

    @override
  void dispose() {
    mobile.dispose();
    password.dispose();
    first_name.dispose();
    password_confirmation.dispose();
    email.dispose();
    last_name.dispose();
    super.dispose();
  }
}