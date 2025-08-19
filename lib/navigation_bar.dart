import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/homepage_screen.dart';
import 'package:flutter_application_restaurant/view/widgets/home/nav.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Widget> _pages =ListPages.pages;

  void _onItemTapped(int index) {
    Get.to(_pages[index]);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Homepage(), // Display the selected page
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        //=> _onItemTapped(2), // Action for the center FAB
        shape: const CircleBorder(), // Makes the FAB circular
        backgroundColor:Colors.white, // Customize FAB color
        foregroundColor: Colors.deepOrange, // Customize FAB icon color
        child: const Icon(Icons.percent), // Center icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Position the FAB
      bottomNavigationBar: BottomAppBar(
        notchMargin: 15,
        elevation: 5,
        height: 95,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.grey.shade600,
        color: Colors.white,
        shape: const CircularNotchedRectangle(), // Creates the notch for the FAB
        // Space between FAB and AppBar

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute items evenly
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.list_alt_rounded, color: Colors.black),
                  onPressed: () => _onItemTapped(0),
                ),
                Text('menu',style: TextStyle(color: Colors.black),)

              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
                  onPressed: () => _onItemTapped(1),
                ),
                const Text('orders',style: TextStyle(color: Colors.black),)

              ],
            ),
            const SizedBox(width: 48), // Placeholder for the FAB
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color:  Colors.black),
                  onPressed: () => _onItemTapped(3),
                ),
                const Text('fav',style: TextStyle(color: Colors.black),)

              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () => _onItemTapped(4),
                ),
                const Text('search',style: TextStyle(color: Colors.black),)

              ],
            ),
          ],
        ),
      ),
    );
  }
}
