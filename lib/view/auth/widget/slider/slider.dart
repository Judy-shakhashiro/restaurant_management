import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/auth/active_login.dart';
import '../../register.dart';
import 'package:get/get.dart';
class SliderBeg extends StatefulWidget {
   SliderBeg({super.key});

  @override
  State<SliderBeg> createState() => _SliderBegState();
}
class _SliderBegState extends State<SliderBeg> {
  late List<Widget> myimages;

final imagePaths = [
  'assets/slider/p1.jpg',
  'assets/slider/p2.jpg',
  'assets/slider/p3.jpg',
  'assets/slider/p4.jpg',
  'assets/slider/p5.jpg',
  'assets/slider/p6.jpg',
  'assets/slider/p7.jpg',
];

final imageTexts = [
  'Hi sir',
  'Welcome to our restaurant',
  'Stay with me i will tell you some of our services',
  'You can book a table inside the restaurant or enjoy it on the terrace',
  'You can order food while setting in the restaurant',
  'Finally you can benefit from ordering food delivery',
  'Enjoy your time!',
];

@override
void initState() {
  super.initState();

  myimages = List.generate(imagePaths.length, (index) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePaths[index],
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Text(
              imageTexts[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Georgia",
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}


  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
  height: MediaQuery.of(context).size.height,
  viewportFraction: 1.0,         
  enlargeCenterPage: false,      
  autoPlay: true,
  autoPlayInterval: const Duration(seconds: 3),
  autoPlayAnimationDuration: const Duration(milliseconds: 600),
  autoPlayCurve: Curves.easeInOut,
  scrollPhysics: const ClampingScrollPhysics(), 
  enableInfiniteScroll: true,
  onPageChanged: (index, reason) {
    setState(() {
      currentindex = index;
    });
  },
),

            items: myimages,
          ),
          Positioned(
  bottom: 120, 
  left: 0,
  right: 0,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Get.to(ActiveLogin());
          },
          child: const Text(
            'Log In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Get.to(Register());
              
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ),
    ],
  ),
),

        ],
      ),
    );
  }
}