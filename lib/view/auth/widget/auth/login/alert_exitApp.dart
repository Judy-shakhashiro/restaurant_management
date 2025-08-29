import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
Future<bool> alertExitApp() {
  Get.defaultDialog(
      title: "Alert",
      titleStyle:const TextStyle(color: Colors.deepOrange,  fontWeight: FontWeight.bold),
      middleText: "Do you want to exit the app ? ",
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepOrange)),
            onPressed: () {
              exit(0);
            },
            child:const Text("confirm",style: TextStyle(color:  Colors.white,fontSize: 18),)),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepOrange)),
            onPressed: () {
              Get.back();
            },
            child:const Text("cancle",style: TextStyle(color:  Colors.white,fontSize: 18),))
      ]);
  return Future.value(true);
}