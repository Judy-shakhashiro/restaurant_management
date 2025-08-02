import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../cart.dart';
import '../dish_details.dart';
//بدي ياها
// class ProductCard extends StatefulWidget {
//   final ProductHome product;
//
//   const ProductCard({Key? key, required this.product}) : super(key: key);
//
//   @override
//   _ProductCardState createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   @override
  // Widget build(BuildContext context) {
  //   bool isExpanded = false;
  //   bool isFavorite = false;
  //   final WishlistController controller = Get.find();
  //   final m = widget.product;
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       width: 260,
  //       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [BoxShadow(color: Colors.deepOrangeAccent, blurRadius: 10)],
  //         color: Colors.white,
  //       ),
  //       child: InkWell(
  //         onTap: () {
  //           Get.to(CartScreen());
  //         },
  //         child: Card(
  //           elevation: 8,
  //           // margin: const EdgeInsets.all(12),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           clipBehavior: Clip.antiAlias,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Image.network(
  //                 '$backUrl/images/${m.image}',
  //                 height: 180,
  //                 width: double.infinity,
  //                 fit: BoxFit.cover,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       m.name,
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 20,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 10),
  //                    Obx(() {
  //                       bool isFav = controller.isFavorite(m.id);
  //                       return IconButton(
  //                         icon: Icon(
  //                           isFav ? Icons.favorite : Icons.favorite_border,
  //                           color: isFav ? Colors.red : Colors.grey,
  //                         ),
  //                         onPressed: () async {
  //                           await controller.toggleFavorite(m.id);
  //                         },
  //                       );
  //                     }),
  //
  //
  //                     ])
  //                     ),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10, right: 80),
  //                 child: Divider(thickness: 2,color: Colors.orange,),
  //               ),
  //
  //               // Padding(
  //               //   padding: const EdgeInsets.symmetric(horizontal: 10),
  //               //   child: AnimatedCrossFade(
  //               //     firstChild: Text(
  //               //       m.description.length > 30
  //               //           ? m.description.substring(0, 30) + '...'
  //               //           : m.description,
  //               //       style: const TextStyle(fontSize: 15, color: Colors.black87),
  //               //     ),
  //               //     secondChild: Text(
  //               //       m.description,
  //               //       style: const TextStyle(fontSize: 16, color: Colors.black87),
  //               //     ),
  //               //     crossFadeState: isExpanded
  //               //         ? CrossFadeState.showSecond
  //               //         : CrossFadeState.showFirst,
  //               //     duration: const Duration(milliseconds: 300),
  //               //   ),
  //               // ),
  //               // if (m.description.length > 30)
  //               //   Padding(
  //               //     padding: const EdgeInsets.only(left: 20, top: 5),
  //               //     child: TextButton(
  //               //       onPressed: () {
  //               //         setState(() {
  //               //           isExpanded = !isExpanded;
  //               //         });
  //               //       },
  //               //       child: Text(
  //               //         isExpanded ? "عرض أقل" : "عرض المزيد",
  //               //         style: const TextStyle(color: Colors.black),
  //               //       ),
  //               //     ),
  //               //   ),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 10),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "${m.price} \$",
  //                       style: const TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18,
  //                       ),
  //                     ),
  //                     InkWell(
  //                       onTap: () {
  //                         Get.to(DishDetailsPage(productId: m.id));
  //                       },
  //                       borderRadius: BorderRadius.circular(8),
  //                       splashColor: Colors.orange.withOpacity(0.3),
  //                       highlightColor: Colors.orange.withOpacity(0.1),
  //                       child: Container(
  //                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           border: Border.all(color: Colors.orange, width: 1.5),
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: const Row(
  //                           children: [
  //                             Text(
  //                               "View",
  //                               style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 16,
  //                               ),
  //                             ),
  //                             SizedBox(width: 4),
  //                             Icon(
  //                               Icons.arrow_forward_ios,
  //                               size: 16,
  //                               color: Colors.black,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //
  //
  //
  //   );
  //
  //
  //   }


//}