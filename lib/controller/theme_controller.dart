import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  ThemeMode themeMode = ThemeMode.light;


  bool get isDarkMode => themeMode == ThemeMode.dark;


  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    update();
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDark = themeMode == ThemeMode.dark;
    themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool('isDarkMode', !isDark);
    update();
  }
}