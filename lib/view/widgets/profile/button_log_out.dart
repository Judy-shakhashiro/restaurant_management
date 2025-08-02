import 'package:flutter/material.dart';

Widget botton_log_out( void Function()? onPressed){
  return Container(
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey)),
    child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Log Out",
              style: TextStyle(color: Colors.red),
            )
          ],
        )),
  );
}