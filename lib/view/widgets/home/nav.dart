import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../controller/nav_bar_controller.dart';
import '../../../globals.dart';
import '../../cart.dart';
import '../../homepage_screen.dart';
import '../../menu_page.dart';
import '../../orders/my_orders.dart';
import '../../search_page.dart';
import '../../show_favorite_page.dart';
class ListPages {
  static final List<Widget> pages = [
     MenuPage(),
    OrdersPage(),
     Homepage(),
    CartScreen(),
     SearchPage()
  ];

}



Widget buildIcon(IconData icon, int index, String label) {
  return GetBuilder<NavController>(builder: (controller) {
    final selected = controller.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: Container(

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
            color: selected? lightOrange:Colors.transparent,),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: selected ? 29 : 22, color: selected ? Colors.orange : Colors.grey),
              Text(label,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 8,  color: selected ? Colors.orange:Colors.grey ),

              )

            ],
          )
      ),
    );
  });
}

Widget bottomAppBar(){
  return

    Container(

      child: BottomAppBar(

        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.white,
        child: Container(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [buildIcon(Icons.list_alt_outlined, 0,"Menu"), buildIcon(Icons.favorite_outline, 1,"Favorites")]),
              Row(children: [buildIcon(Icons.receipt_long, 3,"Orders"), buildIcon(Icons.search, 4,"Search")]),
            ],
          ),
        ),
      ),
    );
}











