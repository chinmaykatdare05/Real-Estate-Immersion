import 'package:flutter/material.dart';
import 'package:flutter03/profile.dart';
import 'package:flutter03/seller/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SellerBottomNavigation(),
    );
  }
}

class SellerBottomNavigation extends StatefulWidget {
  const SellerBottomNavigation({super.key});

  @override
  State<SellerBottomNavigation> createState() => _SellerBottomNavigationState();
}

class _SellerBottomNavigationState extends State<SellerBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SellerDashboard(
      sellerId: '',
      sellerName: '{Seller Name}',
    ),
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
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
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
