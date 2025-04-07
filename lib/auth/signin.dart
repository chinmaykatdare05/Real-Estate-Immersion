// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter03/auth/signup.dart';
import 'package:flutter03/auth/forgot_password.dart';
import 'package:flutter03/auth_service.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign In",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9@._-]')),
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Enter your Email",
                            labelText: "Email Address",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(color: Color(0xFF757575)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder,
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
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Enter your Password",
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(color: Color(0xFF757575)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder,
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

                        // Gradient Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text.trim();
                                final password =
                                    _passwordController.text.trim();

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
                                        "SignIn failed. Please try again.",
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 216, 16, 83),
                                    ),
                                  );
                                }
                              }
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 248, 6, 6),
                                    Color.fromARGB(255, 240, 102, 102)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Center(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
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
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                          ),
                        ),
                        const SizedBox(height: 16.0),
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
                                        builder: (context) => SignUp(),
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
