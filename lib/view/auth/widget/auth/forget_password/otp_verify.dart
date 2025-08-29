import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/services/auth/login/forget_password/verify_serv.dart';
import '../../../../../controller/auth/login_controller.dart';
import '../../../forget_password/reset_password.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
class Otp_verify extends StatelessWidget {
  
   Otp_verify({super.key});
 // LoginControllerImp controller2 = Get.put(LoginControllerImp());
  @override
  Widget build(BuildContext context) {
    return  OtpTextField(
      fieldHeight: 35,
      fieldWidth: 35,
      borderRadius: BorderRadius.circular(10),
      numberOfFields: 6,
      focusedBorderColor: Colors.orange.shade900, 
      textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), 
          //set to true to show as box or false to show as dash
      showFieldAsBox: true, 
          //runs when a code is typed in
      onCodeChanged: (String code) {
              //handle validation or checks here           
          },
      onSubmit: (String verificationCode)async{
          bool success = await VerifyServ.verify('controller2.email.text',verificationCode);
          if (success) {
            print('kkkkkkkkkkkkkobject');
              Get.to(Resetpassword());
            } 
          //  Get.to(Resetpassword());
          },
          
          
          //runs when every textfield is filled
        // end onSubmit
    );
  }
}



