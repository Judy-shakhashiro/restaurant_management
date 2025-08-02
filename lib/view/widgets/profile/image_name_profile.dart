import 'package:flutter/material.dart';

Widget image_profile(){


  return  Center(
    child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 9),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
        ),
        child: Stack(
          children: [
            ClipOval(
              // child: Image.asset(
              //   "assets/images/pexels-bertellifotografia-3792581.jpg",
              //   fit: BoxFit.cover,
              //   width: 100,
              //   height: 100,
              // ),
            ),
            Positioned(
                bottom: 3,
                right: 1,

                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(Icons.camera_alt_outlined,color: Colors.yellow,),) )
          ],
        )
    ),
  );
}

Widget name_email_profile(String name, String email){
  return Center(
    child: Column(children: [
      Text(
        name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Text(
        email,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    ],),
  );
}

