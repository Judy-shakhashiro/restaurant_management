import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/widgets/home/nav.dart';
import 'package:get/get.dart';

import 'globals.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex =2; // Tracks the selected tab index

  // List of your five pages
  final List<Widget> _pages =ListPages.pages;

  void _onItemTapped(int index) {

      setState(() {
        _selectedIndex = index;
      });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2), // Action for the center FAB
        shape: const CircleBorder(), // Makes the FAB circular
        backgroundColor: _selectedIndex==2?lightOrange:Colors.white, // Customize FAB color
        foregroundColor: Colors.orange, // Customize FAB icon color
        child: const Icon(Icons.home), // Center icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Position the FAB
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        notchMargin: 10,
        height:95,
        shape: const CircularNotchedRectangle(), // Creates the notch for the FAB
        // Space between FAB and AppBar

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute items evenly
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color:_selectedIndex==0? lightOrange:Colors.transparent),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.list_alt_rounded, color: _selectedIndex == 0 ? Colors.orange : Colors.black54),
                    onPressed: () => _onItemTapped(0),
                  ),
                  Text('menu',style: TextStyle(color: _selectedIndex == 0 ? Colors.orange : Colors.black54),)

                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: _selectedIndex==1? lightOrange:Colors.transparent),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, color: _selectedIndex == 1 ? Colors.orange : Colors.black54),
                    onPressed: () => _onItemTapped(1),
                  ),
                  Text('orders',style: TextStyle(color: _selectedIndex == 1 ? Colors.orange : Colors.black54),)

                ],
              ),
            ),
            const SizedBox(width: 48), // Placeholder for the FAB
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: _selectedIndex==3? lightOrange:Colors.transparent),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: _selectedIndex == 3 ? Colors.orange : Colors.black54),
                    onPressed: () => _onItemTapped(3),
                  ),
                  Text('fav',style: TextStyle(color: _selectedIndex == 3 ? Colors.orange : Colors.black54),)

                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  color: _selectedIndex==4? lightOrange:Colors.transparent),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.search, color: _selectedIndex == 4 ? Colors.orange : Colors.black54),
                    onPressed: () => _onItemTapped(4),
                  ),
                  Text('search',style: TextStyle(color: _selectedIndex == 4 ? Colors.orange : Colors.black54),)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
