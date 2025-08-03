import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/controller/theme_controller.dart';
import 'package:flutter_application_restaurant/view/auth/widget/slider/slider.dart';
import 'package:flutter_application_restaurant/view/reservations_page.dart';
import 'package:flutter_application_restaurant/view/widgets/home/theme.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'core/static/global_serv.dart';
import 'home_screen.dart';

var service;
bool? hasToken;
Future <void> main() async {

  service = Get.put(GlobalServ());
  WidgetsFlutterBinding.ensureInitialized(); // لتشغيل async في main
  final themeController = Get.put(ThemeController());
  await themeController.loadTheme(); // تحميل الثيم المحفوظ
  if( await service.getToken()!=null) {
    hasToken=true;
    print('token is${await service.getToken()}');
  }
  else {
    hasToken = false;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller)  {
        return GetMaterialApp(
            title: 'GetX Theme App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(scaffoldBackgroundColor: Colors.white, dialogTheme: const DialogThemeData(backgroundColor: Colors.white)),
            darkTheme: darkTheme,
            themeMode: controller.themeMode, // استخدام الثيم الحالي
            home: ReservationsView()
            //hasToken==true? const MyHomePage():SliderBeg()
        );
      },
    );
  }
}

// void main() async{
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       home:DeliveryLocationPage(),
//     );
//   }
// }



