import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
Future<bool> alertExitApp() {
  Get.defaultDialog(
      title: "تنبيه",
      titleStyle:const  TextStyle(color: Color(0xFFFDD835),  fontWeight: FontWeight.bold),
      middleText: "هل تريد الخروج من التطبيق",
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFFFFFEE58))),
            onPressed: () {
              exit(0);
            },
            child:const Text("تاكيد")),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFFFFFEE58))),
            onPressed: () {
              Get.back();
            },
            child:const Text("الغاء"))
      ]);
  return Future.value(true);
}