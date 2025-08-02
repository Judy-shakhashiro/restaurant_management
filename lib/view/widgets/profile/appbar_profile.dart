import 'package:flutter/material.dart';

Widget appbar_profile(){
  return   Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Container(
            child: Image.asset("assets/images/Arrow_Back.png")),
        Container(
            margin: EdgeInsets.only(right: 7),
            child: Center(child: Text("Profile",style: TextStyle(fontSize: 17,fontWeight: FontWeight.normal,color: Colors.grey.shade700),),)),
        Container(
            width: 33,
            height: 33,
            margin: EdgeInsets.only(right: 0),
            child: Image.asset("assets/images/linear.png",))




      ],
    ),

  );
}