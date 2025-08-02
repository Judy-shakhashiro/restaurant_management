import 'package:flutter/material.dart';

AppBar search_favourute(){
  return AppBar(
    title:
    Container(
      margin: EdgeInsets.only(right: 20, left: 10, top: 0),
      padding: EdgeInsets.all(10),
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey)),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
            color: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Serach your favourite food..",

            style: TextStyle(color: Colors.grey,fontSize: 15),
          )
        ],
      ),
    ),
  );

}