import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/navigation_bar.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/button_login.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/textform_login.dart';
import '../../../controller/auth/reset_controller.dart';
import '../../../core/functions/validation.dart';
import '../../../services/auth/login/forget_password/reset_serv.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key});

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
    bool isChecked = false;
    ResetControllerImp cont =Get.put(ResetControllerImp());
   
  @override
  Widget build(BuildContext context) {
     final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:const Text('Creat New Password',
        style:  TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
             fontFamily: 'Georgia'
        ),),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
      ),
        body: ListView(
          children: [
            // SizedBox(height: size.height * 0.02),
            Lottie.asset('assets/lotti/reserpass.json',
                fit: BoxFit.fitHeight, height: size.height * 0.3, width: size.width),
            // Image.asset('assets/new-password/reset.jpg',
            //   height: size.height*0.22,
            //   width: size.width*0.22,               
            //     ),
            const SizedBox(height: 10),
            const Text(
              'Enter New Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  fontFamily: 'Georgia'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Divider(
                thickness: 2,
                color: Colors.orange.shade900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your new password must be differnt \n from previously used password',
              textAlign: TextAlign.center,
              style: TextStyle(
              color:Colors.black54,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              fontSize: 15
             
              ),),
            const SizedBox(height: 40),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
           key: cont.formstate,
              child: Column(
                children: [
              
             GetBuilder<ResetControllerImp>(
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
                    GetBuilder<ResetControllerImp>(
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
                        const SizedBox(height: 25),
                        Padding(
                         padding: const EdgeInsets.only(right: 30),
                          child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             const  Text(
                               "Logout other devices   ",
                                style: TextStyle(
                                   fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'Georgia'),
                                          ),
                                         GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChecked = !isChecked; 
                                            cont.logout_oth_dev=true;
                                           // Get.to(Forgetpassword());
                                          });
                                        },
                                        child: Container(
                                          width: 20, 
                                          height: 20,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black, width: 2),
                                            borderRadius: BorderRadius.circular(2),
                                            color: isChecked ? Colors.orange.shade900 : Colors.white, 
                                          ),
                                          child: isChecked
                                            ?  Icon(Icons.check, color: Colors.white, size: 15)
                                            : null,
                                        ),)
                                                ],
                                              ),
                        ),
                         const SizedBox(height:30),
                        Center(
             child: ElevatedButton.icon(
              onPressed: () async{
                      if(cont.formstate.currentState!.validate()){
                    ResetServ resetFuncs = ResetServ();
                      bool success = await resetFuncs.reset(
                        cont.password.text,
                      cont.password_confirmation.text,
                      cont.logout_oth_dev,
                                    );
                      if (success) {
                        Get.to(MyHomePageScreen());
                      } 
                      }
                        },
             // icon: const Icon(Icons.shopping_cart, color: Colors.black),
              label: const Text(
                'Save',
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
                        
                        ]),
            )
          ]
        ) 
        );
  }
}