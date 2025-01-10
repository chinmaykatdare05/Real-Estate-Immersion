import 'package:flutter/material.dart';
import 'package:flutter03/pages/home/camera.dart';
import 'package:flutter03/pages/home/explore.dart';
import 'package:flutter03/pages/home/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Tracks which tab is selected

  final List<Widget> _pages = [
    ExplorePage(), // Explore page
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
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlight the selected item
        onTap: _onItemTapped, // Handle navigation
        type: BottomNavigationBarType.fixed, // Keeps all items visible
        selectedItemColor: Colors.red, // Active item color
        unselectedItemColor: Colors.black54, // Inactive item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
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
      ),
    );
  }
}
