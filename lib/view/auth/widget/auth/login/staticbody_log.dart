// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class Staticbodylog extends StatelessWidget {
//   const Staticbodylog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           child:const Center(
//             child: Text(
//               "Log In",
//                style: TextStyle(
//                color: Colors.black,
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//                 ),
//               ),),
//             decoration: BoxDecoration(
//             color: Color(0xFFFFFEE58),// اللون الأصفر
//             borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(70),
//             bottomRight: Radius.circular(70),
//         ),
//       ),
//       padding: EdgeInsets.only(top:30, bottom: 20),),
//               Container(
//                 child:Lottie.asset(
//                   "assets/lotti/login.json",
//                   fit: BoxFit.cover,
//                   height: 200,
//                   width: 200
//                           ),),
//       const Text(
//         'Sign In with your Account ',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//         color:  Colors.black,
//         fontWeight: FontWeight.bold,
//         fontSize: 15),
//       ),
//       const Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 100),
//         child: Divider(thickness: 2,color: Color(0xFFFFEB3B),),
//       ),
//             ],
//           );
//   }
// }