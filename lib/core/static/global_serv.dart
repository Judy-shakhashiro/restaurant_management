import 'package:flutter_application_restaurant/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalServ {

  Future<void> saveToken(String token) async {
    SharedPreferences? sharedPreferences= await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', token);
  }
   Future<String?> getToken() async {
     SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
     token=sharedPreferences.getString('token')!;
    return sharedPreferences.getString('token');
  }
   Future<bool> removeToken() async {
     SharedPreferences? sharedPreferences= await SharedPreferences.getInstance();
    return await sharedPreferences.remove('token');
  }
  //  Future<void> saveTheme(bool isDarkMode) async {
  //   await sharedPreferences?.setBool('isDarkMode', isDarkMode);
  // }

  // bool getSavedTheme() {
  //   return sharedPreferences?.getBool('isDarkMode') ?? false;
  // }
}
