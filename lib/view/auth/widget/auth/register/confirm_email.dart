// import 'package:flutter/material.dart';
// import 'package:flutter_application_restaurant/controller/auth/register_controller.dart';
// import 'package:flutter_application_restaurant/core/functions/validation.dart';
// import 'package:flutter_application_restaurant/view/widget/auth/confirm_email/otp_confirm.dart';
// import 'package:flutter_application_restaurant/view/widget/auth/login/textform_login.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// class Confirm_email extends StatelessWidget {
//    Confirm_email({super.key});
// RegisterControllerImp contr= Get.put(RegisterControllerImp());

//   @override
//   Widget build(BuildContext context) {
//      final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFFFF),
//     body: ListView(
//       children: [
//         Image.asset('assets/accept_register/otp.jpg',
//         //  height: size.height*0.22,
//         //         width: size.width*0.22,       
//         ),
//           SizedBox(height: 20,),
//         Textformlogin(text: 'Email',iconData: Icons.email_outlined,mycontoller: contr.email,isNumber: false,
//             validator:  (val) {
//               return validInput(val!, 5, 100, "email");
//                     },
//           ),
//           SizedBox(height: 50,),
//          Otp_confirm(),
//          SizedBox(height: 50,),
//         //  Buttonlogin(
//         //   text: 'Done ',
//         //   color:  Color(0xFFF3D63A),
//         //   onPressed: (){
//         //     Get.to(SplashScreen2());
//         //   },
//         //  )
//       ],
//     ),
        
//     );
//   }
// }