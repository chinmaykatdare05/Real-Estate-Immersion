import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter03/buyer/explore.dart';
import 'package:flutter03/buyer/camera.dart';
import 'package:flutter03/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BuyerBottomNavigation(),
    );
  }
}

// This widget represents the bottom navigation bar for the buyer's app, allowing navigation between different pages.
// It contains three tabs: Explore, Camera, and Profile. The selected tab is highlighted, and the corresponding page is displayed.
// The state of the selected tab is managed using a StatefulWidget.
class BuyerBottomNavigation extends StatefulWidget {
  const BuyerBottomNavigation({super.key});

  @override
  State<BuyerBottomNavigation> createState() => _BuyerBottomNavigationState();
}

class _BuyerBottomNavigationState extends State<BuyerBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ExplorePage(),
    const Camera(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.magnifyingGlass),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.airbnb),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
