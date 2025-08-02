import 'package:flutter_application_restaurant/config.dart';

class Linkapi {

  //static const String url = "http://127.0.0.1:8000/api";
  //static const String image = "http://192.168.1.101:8000";
  
  ///////Login
  static const String LoginApi ='$backUrl/login';
  static const String ForgetPasswordApi='$backUrl/passwords/email';
  static const String verificationApi='$backUrl/passwords/verify';
  static const String ResetPasswordApi ='$backUrl/passwords/reset';

  /////Register
  static const String RegisterApi = "$backUrl/register";
  static const String ConfirmEamilApi ='$backUrl/confirmation/verify';


}




