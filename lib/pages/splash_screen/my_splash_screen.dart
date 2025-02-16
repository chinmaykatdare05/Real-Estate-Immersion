import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter03/pages/login/login.dart'; // Import login page

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to Login page after 3 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/airbnb.png",
                height: 200), // Adjust image path
            const SizedBox(height: 20),
            const Text(
              "Welcome to Flutter App",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
