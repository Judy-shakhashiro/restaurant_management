import 'package:flutter/material.dart';


Widget cardAccount(double marginLeft,double margintop,double marginbottom,String text,Icon icon,double dis_text_skip){
  return  Container(
    margin: EdgeInsets.only(left: marginLeft,top: margintop,bottom: marginbottom),
    child: Row(

      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300
          ),
          child: icon,),
        SizedBox(width: 20,),
        Text(text),
        SizedBox(width: dis_text_skip,),

      //  Image.asset("assets/images/Skip.png",width: 30,height: 30,)
      ],
    ),
  );
}

Widget title_card(String title){
  return   Container(
    margin: EdgeInsets.only(top: 16, left: 17, bottom: 10),
    child: Text(
      title,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600),
    ),
  );

}