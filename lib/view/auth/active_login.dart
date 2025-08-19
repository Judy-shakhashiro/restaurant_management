import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/button_login.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/textform_login.dart';
import '../../controller/auth/login_controller.dart';
import '../../core/functions/validation.dart';
import '../../core/static/global_service.dart';
import '../../services/auth/login/login_serv.dart';
import 'forget_password/forget_password.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ActiveLogin extends StatefulWidget {
   ActiveLogin({super.key});

  @override
  State<ActiveLogin> createState() => _ActiveLoginState();
}

class _ActiveLoginState extends State<ActiveLogin> {

  bool isChecked = false;
  LoginControllerImp controller1 = Get.put(LoginControllerImp()); 

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
           Container(
            decoration:const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0), 
                bottomRight: Radius.circular(30.0), 
              ),
              color: Colors.white, 
              border: Border(
                bottom: BorderSide(
                  color: Colors.black54, 
                  width: 2.5,
                ),
              ),
            ),
  child: ClipRRect(
              borderRadius:const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0), 
            ),
              child: Container(
                width: screenSize.width,
                height: screenSize.height*0.35,
                child: Image.asset('assets/photo_2025-06-26_18-38-04.jpg',
                fit: BoxFit.fitWidth,
                ),
              ),
            ),),
          const SizedBox(height: 27,),
          const Text(
        'Sign In with your Account ',
        textAlign: TextAlign.center,
        style: TextStyle(
        color:  Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
        fontSize: 17),
      ),
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Divider(thickness: 2,color: Colors.orange.shade900,),
      ),
      const SizedBox(height: 40),
            Form(

              key: controller1.formstate,
              child: Column(
                children: [
                  Textformlogin(
                    validator: (val) {
                      return validInput(val!, 5, 100, "email");
                    },
                    isNumber: false,
                    mycontoller: controller1.email,
                    text: "Email",
                    iconData: Icons.email,
                  ),
                  const SizedBox(height: 40,),
                  GetBuilder<LoginControllerImp>(
                    builder: (controller) => Textformlogin(
                      validator: (val) {
                        return validInput(val!, 8, 30, "password");
                      },
                      isNumber: false,
                      mycontoller: controller1.password,
                      text: "Password",
                      iconData: controller.isshowpassword ? Icons.visibility_off : Icons.visibility,
                      obscureText: controller.isshowpassword,
                      onTapIcon: () {
                        controller.showPassword();
                      },
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Forget Password ? ",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: 'Georgia',),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChecked = !isChecked;
                               Get.to(Forgetpassword());
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
                              ? const Icon(Icons.check, color: Colors.white, size: 15)
                              : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Buttonlogin(
                    text: 'Go ',
                    onPressed: () async {
                      if(controller1.formstate.currentState!.validate()){
                      bool Success= await LoginServ.login( controller1.email.text,cont. password.text);
                      if(Success){
                      Get.to(Forgetpassword());
                      }
                      }
                    },
                  //  color:  Colors.orange[600], 
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Creat new account ? ",
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,fontFamily: 'Georgia',),
                      ),
                      IconButton(
                        onPressed: () {
                       //    Get.to(Register());
                        },
                        icon: Icon(Icons.arrow_circle_right_outlined, size: 35,color: Colors.orange[900],),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}