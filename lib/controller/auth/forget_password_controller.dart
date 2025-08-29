import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxService {
  
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;

  @override
  void onInit() {
    email  = TextEditingController() ;
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    super.onClose();
  }

   }
