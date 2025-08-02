import 'package:flutter/material.dart';

Widget info_Card_Favourite(int levelPrice, String time, double evulation) {
  return Container(
    margin: EdgeInsets.only(left: 18, right: 18),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Row(
            children: [
              Icon(
                Icons.table_restaurant_rounded,
                size: 20,
                color: Colors.yellow,
              ),
              Text(
                " Tasteology",
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Icon(
                Icons.wallet,
                size: 20,
                color: Colors.yellow,
              ),
              buildEuroPriceLevel(levelPrice)
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Icon(
                Icons.access_time_filled_outlined,
                size: 20,
                color: Colors.yellow,
              ),
              Text(
                " ${time} min",
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Icon(
                Icons.star,
                size: 20,
                color: Colors.yellow,
              ),
              Text(
                "$evulation",
                style: TextStyle(fontSize: 11),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildEuroPriceLevel(int level) {

  return Text.rich(
    TextSpan(
      children: List.generate(4, (index) {
        return TextSpan(
          text: "€",
          style: TextStyle(
            fontSize: 14,
            color: index < level
                ? Colors.black
                : Colors.grey,
          ),
        );
      }),
    ),
  );
}