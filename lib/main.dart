import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/model/cart_model.dart';
import 'package:flutter_application_restaurant/view/auth/active_login.dart';
import 'package:flutter_application_restaurant/view/auth/forget_password/forget_password.dart';
import 'package:flutter_application_restaurant/view/auth/register.dart';
import 'package:flutter_application_restaurant/view/auth/widget/slider/slider.dart';
import 'package:flutter_application_restaurant/view/cart.dart';
import 'package:flutter_application_restaurant/view/profile/profile.dart';
import 'package:flutter_application_restaurant/view/profile/profile_page.dart';
import 'package:flutter_application_restaurant/view/reservation/reservations_list_page.dart';
import 'package:flutter_application_restaurant/view/favorite_page.dart';
import 'package:get/get.dart';
import 'package:shimmer/main.dart';
import 'core/static/global_service.dart';
import 'navigation_bar.dart';

var service;
bool? hasToken;
String? token; 

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  service = Get.put(GlobalServ());
  if (await service.getToken() != null) {
    hasToken = true;
    print('token is ${await service.getToken()}');
  } else {
    hasToken = false;
  }
  

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
          ),
          ),
          appBarTheme: AppBarTheme( backgroundColor:Colors.grey.shade100 ,
            shadowColor: Colors.grey.shade300,
            surfaceTintColor: Colors.grey.shade300,),
            fontFamily: 'Georgia',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white, dialogTheme: const DialogThemeData(backgroundColor: Colors.white,)),
        home:
        // FavoritesPage()
        Register()
       
    //  hasToken==true? const MyHomePageScreen():SliderBeg()

      
     
    );
  }
}