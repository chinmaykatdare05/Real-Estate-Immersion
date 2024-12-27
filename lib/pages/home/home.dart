import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'explore.dart';
import 'camera.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Tracks which tab is selected

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    ExplorePage(), // The Explore page
    const CameraPage(), // The Camera page
    const ProfileScreen(), // The Profile page
  ];

  // Function to handle tapping on the navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Manages the screen based on the selected index
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: <Widget>[
          Icon(
            Icons.explore,
            size: 30,
            color: _selectedIndex == 0 ? Colors.white : Colors.white,
          ),
          Icon(
            Icons.photo_camera,
            size: 30,
            color: _selectedIndex == 1 ? Colors.white : Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: _selectedIndex == 2 ? Colors.white : Colors.white,
          ),
        ],
        color: const Color.fromARGB(255, 1, 24, 76),
        buttonBackgroundColor: const Color.fromARGB(255, 234, 185, 5),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
      ),
    );
  }
}
