import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gridview/homescreen.dart';

class BottomNavigat extends StatefulWidget {
  const BottomNavigat({super.key});

  @override
  State<BottomNavigat> createState() => _BottomNavigatState();
}

class _BottomNavigatState extends State<BottomNavigat> {
  int _selectedIndex = 0;
  // ignore: unused_field
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: const Color.fromARGB(248, 188, 187, 187),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.white30,
              color: Colors.white,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  iconColor: Colors.grey,
                  iconSize: 30,
                  iconActiveColor: Colors.black,
                ),
                GButton(
                  icon: Icons.message_outlined,
                  iconColor: Colors.grey,
                  iconSize: 30,
                  iconActiveColor: Colors.black,
                ),
                GButton(
                  icon: Icons.search,
                  iconSize: 30,
                  iconColor: Colors.grey,
                  iconActiveColor: Colors.black,
                ),
                GButton(
                  icon: Icons.notification_important,
                  iconColor: Colors.grey,
                  iconSize: 30,
                  iconActiveColor: Colors.black,
                ),
                GButton(
                  icon: Icons.person,
                  iconSize: 30,
                  iconColor: Colors.grey,
                  iconActiveColor: Colors.black,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
