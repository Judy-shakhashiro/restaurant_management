import 'package:flutter/material.dart';

class Staticbidyregister extends StatelessWidget {
  const Staticbidyregister({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
                child: Center(
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),),
        decoration: BoxDecoration(
          color: Color(0xFFFFFEE58),// اللون الأصفر
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(70),
            bottomRight: Radius.circular(70),
          ),
        ),
        padding: EdgeInsets.only(top:60, bottom: 20),);
  }
}