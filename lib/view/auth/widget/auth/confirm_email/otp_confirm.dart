import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/home_screen.dart';
import 'package:flutter_application_restaurant/services/auth/register/confirm_email_serv.dart';
import '../../../../../controller/auth/register_controller.dart';
import '../../../forget_password/forget_password.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
class Otp_confirm extends StatelessWidget {
  
   Otp_confirm({super.key});
  RegisterControllerImp controller2 = Get.put(RegisterControllerImp());
  @override
  Widget build(BuildContext context) {
    return  OtpTextField(
      fieldHeight: 35,
      fieldWidth: 35,
      borderRadius: BorderRadius.circular(10),
      numberOfFields: 6,
      enabledBorderColor:Colors.orange.shade900,
      focusedBorderColor: Colors.orange.shade900, 
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          //set to true to show as box or false to show as dash
      showFieldAsBox: true, 
          //runs when a code is typed in
      onCodeChanged: (String code) {
              //handle validation or checks here           
          },
      onSubmit: (String verificationCode)async{
          
          bool success = await ConfirmEmailServ.confirm(controller2.email.text,verificationCode);
            if (success) {
              print('kkkkkkkkkkkkkobject');
             Get.off(MyHomePage());
            } 
  }
           // Get.to(Resetpassword());
          
          
          
          //runs when every textfield is filled
        // end onSubmit
    );
  }
}



