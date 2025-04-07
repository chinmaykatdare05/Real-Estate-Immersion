// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'buyer/bottom_navigation.dart';
import 'seller/bottom_navigation.dart';
import 'auth/signin.dart';

enum UserType { buyer, seller }

// This class handles user authentication and session management using Firebase Auth and Firestore.
// It provides methods for signing up, signing in, signing out, and resetting passwords.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserType _userType = UserType.buyer;

  UserType get userType => _userType;

  void setUserType(UserType type) {
    _userType = type;
  }

  void checkUserSession(BuildContext context) {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      } else {
        _firestore.collection('Users').doc(user.uid).get().then((doc) {
          if (doc.exists) {
            bool isBuyer = doc['Buyer'] as bool;
            if (isBuyer) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const BuyerBottomNavigation()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SellerBottomNavigation()),
              );
            }
          } else {
            _showSnackBar(context, "User data not found.");
          }
        }).catchError((error) {
          _showSnackBar(context, "An error occurred: ${error.toString()}");
        });
      }
    });
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'Name': name,
        'Email': email,
        'Phone': phoneNumber,
        'Buyer': _userType == UserType.buyer ? true : false,
        'Password': password,
      });

      checkUserSession(context);
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);
      _showSnackBar(context, message);
    } catch (e) {
      _showSnackBar(context, "An error occurred: ${e.toString()}");
    }
  }

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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      checkUserSession(context);
    } on FirebaseAuthException catch (e) {
      String message = _getErrorMessage(e.code);

      _showToast(message);
    } catch (e) {
      _showToast("An error occurred: ${e.toString()}");
    }
  }

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

  Future<void> signout({
    required BuildContext context,
  }) async {
    await _auth.signOut();
    await Future.delayed(const Duration(seconds: 1));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => SignIn()),
    );
  }

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
