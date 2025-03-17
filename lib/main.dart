import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter03/firebase_options.dart';
import 'package:flutter03/pages/home/home.dart'; // Home Page Import
import 'package:flutter03/pages/login/login.dart';
import 'package:flutter03/pages/signup/signup.dart'; // Signup import
import 'package:flutter03/pages/forgot_password/forgot_password.dart'; // Forgot Password import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  // Initialize Firebase with your Firebase options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Add routing for easy navigation
      routes: {
        '/signup': (context) => SignupPage(), // Signup Page
        '/forgot_password': (context) => ForgotPasswordPage(), // Forgot Password Page
      },
      home: AuthWrapper(), // Handles session management
    );
  }
}

// AuthWrapper: Checks if user is logged in and redirects accordingly
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // If user is logged in, go to HomePage
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return Login(); // Otherwise, go to Login Page
          }
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()), // Show loading
        );
      },
    );
  }
}
