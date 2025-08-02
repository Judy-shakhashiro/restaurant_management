import 'package:flutter/material.dart';

Widget cardFavourite(double marginTop,double marginBottom,String image, String title, String subTitle){
  return   Container(
    margin: EdgeInsets.only(right: 15,left: 15,top: marginTop, bottom: marginBottom),

    height: 215,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset:
          Offset(0, 4),
          blurRadius: 6,
        ),
      ],
    ),
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: 330,
                  height: 160,
                ),
              ),
              Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                  ))
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 4),
            child: Text(
              title,
              style:
              TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              subTitle,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    ),

  );

}
