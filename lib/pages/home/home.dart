import 'package:flutter/material.dart';
import 'explore.dart';
import 'camera.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Tracks which tab is selected

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    ExplorePage(), // The Explore page
    CameraPage(), // The Camera page (you'll need to define this in camera.dart)
    ProfileScreen(), // The Profile page
  ];

  // Function to handle tapping on the BottomNavigationBar
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.red[800], // Color for selected tab
        unselectedItemColor: Colors.grey[800], // Color for unselected tabs
        type: BottomNavigationBarType.fixed, // Prevent shifting behavior
      ),
    );
  }
}
