// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home/bottom_navigation.dart';
import 'signin.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Checks if user is logged in and redirects accordingly
  void checkUserSession(BuildContext context) {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()), // Go to login page
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage()), // Go to home page
        );
      }
    });
  }

  // Get current user details
  User? get currentUser => _auth.currentUser;

  // Sign Up with Email & Password
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      // Create user using email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set user data in Firestore
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'Name': name,
        'Email': email,
        'Phone': phoneNumber,
        'Buyer': true,
        'Password':
            password, // You should ideally avoid storing plaintext passwords
      });

      // Redirect based on session immediately after signup
      checkUserSession(context);
    } on FirebaseAuthException catch (e) {
      // Display error messages based on FirebaseAuthException code
      String message = _getErrorMessage(e.code);
      _showSnackBar(context, message);
    } catch (e) {
      // Catch any other exceptions and display a generic error message
      _showSnackBar(context, "An error occurred: ${e.toString()}");
    }
  }

// Helper method to get error message based on FirebaseAuthException code
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'invalid-email':
        return 'No user found for that email.';
      case 'invalid-credential':
        return 'Wrong password provided for that user.';
      default:
        return 'An unexpected error occurred.';
    }
  }

// Helper method to show a Snackbar with a given message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Sign In with Email & Password
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Perform sign-in operation
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Redirect based on session immediately after sign-in
      checkUserSession(context);
    } on FirebaseAuthException catch (e) {
      // Custom message mapping for Firebase Auth exceptions
      String message = _getErrorMessage(e.code);

      _showToast(message);
    } catch (e) {
      // Catch any other exceptions and display a generic error message
      _showToast("An error occurred: ${e.toString()}");
    }
  }

// Helper method to show toast messages
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  // Sign Out
  Future<void> signout({
    required BuildContext context,
  }) async {
    await _auth.signOut();
    await Future.delayed(const Duration(seconds: 1));

    // Redirect to Login Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => Login()),
    );
  }

  // Reset Password
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "Password reset email sent!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}
