import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';

Widget appBar() {
  return GetBuilder<ThemeController>(
    builder: (controller) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 30,
              width: 35,
              margin: EdgeInsets.only(left: 20),
              child: Image.asset(
                controller.isDarkMode
                    ? "assets/images/Drawer_Dark1.png"
                    : "assets/images/Group 1.png",
                fit: BoxFit.cover,
              ),
            ),
            InkWell(
              onTap: () {
                controller.toggleTheme();
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(
                  controller.isDarkMode
                      ? CupertinoIcons.sun_max_fill
                      : CupertinoIcons.moon_stars,
                  color: controller.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}