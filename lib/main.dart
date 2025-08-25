import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/auth/active_login.dart';
import 'package:flutter_application_restaurant/view/auth/widget/slider/slider.dart';
import 'package:flutter_application_restaurant/view/homepage_screen.dart';
import 'package:flutter_application_restaurant/view/profile/profile.dart';
import 'package:flutter_application_restaurant/view/profile/profile_page.dart';
import 'package:flutter_application_restaurant/view/reservation/reservations_list_page.dart';
import 'package:flutter_application_restaurant/view/favorite_page.dart';
import 'package:get/get.dart';
import 'core/static/global_service.dart';
import 'navigation_bar.dart';

var service;
bool? hasToken;
late String token;
Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  service = Get.put(GlobalServ());
  await service.saveToken('1|XQMHzl1XMGZVdSFO8ZEQHsWlel0UtImetHpej73a779204dd');
  if( await service.getToken()!=null) {
    hasToken=true;
    print('token is${await service.getToken()}');
  }
  else {
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
       //   ReservationsListView()
      // Homepage()
        hasToken==true? const MyHomePage():SliderBeg()
    );
  }
}