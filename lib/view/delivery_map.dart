// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// class DeliveryMap extends StatefulWidget {
//   const DeliveryMap({super.key});
//
//   @override
//   State<DeliveryMap> createState() => _DeState();
// }
//
// class _DeState extends State<DeliveryMap> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 25.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//             Container(
//               margin:EdgeInsets.all(10),
//               padding: EdgeInsets.all(10),
//
//             child: Icon(Icons.delivery_dining,color: Colors.orange,size:50,),
//             decoration:BoxDecoration(
//               color: Colors.yellow,
//                 borderRadius: BorderRadius.circular(50)),
//           ),
//             Container(
//               margin:EdgeInsets.all(10),
//               padding: EdgeInsets.all(10),
//               child: Icon(Icons.takeout_dining_outlined,color: Colors.orange,size: 50,),
//               decoration:BoxDecoration(
//                   color: Colors.yellow,
//                   borderRadius: BorderRadius.circular(50)),
//             ),
//             Container(
//               margin:EdgeInsets.all(10),
//               padding: EdgeInsets.all(10),
//
//               child: Icon(Icons.restaurant,color: Colors.orange,size:50,),
//               decoration:BoxDecoration(
//                   color: Colors.yellow,
//                   borderRadius: BorderRadius.circular(50)),
//             ),],),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//
//               decoration: InputDecoration(
//                 hintText: 'Search Location...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide(color: Colors.grey)
//                 ),
//                 focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange),
//                     borderRadius: BorderRadius.circular(30)),
//                 // show the error
//               ),
//           ),
//         ),
//         Expanded(child: FlutterMap(children: [],))
//       ],),
//     );
//   }
// }
