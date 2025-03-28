// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter03/auth/signup.dart';
import 'package:flutter03/auth/forgot_password.dart';
import 'package:flutter03/auth/auth_service.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Keep your controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Adjust this if you prefer a different fill color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea + LayoutBuilder for responsive spacing
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Top spacing
                  SizedBox(height: constraints.maxHeight * 0.1),
                  // Logo (optional)
                  Image.network(
                    "https://i.postimg.cc/d361wj1v/Screenshot-2025-03-18-014224.png",
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  // "Sign In" title
                  Text(
                    "Sign In",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  // The Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9@._-]')),
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Enter your Email",
                            labelText: "Email Address",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFF757575)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFF757575)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            } else if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Enter your Password",
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFF757575)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFF757575)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        // Sign In Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              try {
                                await AuthService().signin(
                                  email: email,
                                  password: password,
                                  context: context,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Login failed. Please try again.",
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 216, 16, 83),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 216, 16, 83),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Sign In"),
                        ),
                        const SizedBox(height: 30),
                        // Forgot Password Button
                        RichText(
                          text: TextSpan(
                            text: 'Forgot Password?',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 240, 61, 61)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                  ),
                                );
                              },
                          ),
                        ),
                        // Spacer for bottom
                        const SizedBox(height: 16.0),
                        // Sign Up Text
                        Text.rich(
                          TextSpan(
                            text: "Don’t have an account? ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color
                                      ?.withOpacity(0.64),
                                ),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 240, 61, 61)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32.0),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
