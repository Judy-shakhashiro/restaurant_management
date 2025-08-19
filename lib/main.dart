import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/auth/widget/slider/slider.dart';
import 'package:get/get.dart';
import 'core/static/global_service.dart';
import 'navigation_bar.dart';

var service;
bool? hasToken;
late String token;
Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  service = Get.put(GlobalServ());
  await service.saveToken('1|a2MMtM5qrTSwUzkuR83qIRoAHeqK582oH1RvhPvKc974b515');
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
            fontFamily: 'Georgia',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white, dialogTheme: const DialogThemeData(backgroundColor: Colors.white,)),
        home:
        //  ReservationsListView()
        hasToken==true? const MyHomePage():SliderBeg()
    );
  }
}