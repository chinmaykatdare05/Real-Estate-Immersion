// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter03/auth_service.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF757575)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign Up",
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
                          controller: nameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Enter your Name",
                            labelText: "Name",
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
                              return 'Name cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9@._-]')),
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Enter your email",
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
                          controller: passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Enter your password",
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
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9]*$')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            hintText: "Enter your phone number",
                            labelText: "Phone Number",
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
                              return 'Phone Number cannot be empty';
                            } else if (value.length != 10) {
                              return 'Phone Number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Type Toggle
                  StatefulBuilder(
                    builder: (context, setState) {
                      UserType selectedUserType = _authService.userType;
                      bool isBuyer = selectedUserType == UserType.buyer;
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ToggleButtons(
                            isSelected: [isBuyer, !isBuyer],
                            onPressed: (index) {
                              setState(() {
                                if (index == 0) {
                                  _authService.setUserType(UserType.buyer);
                                } else {
                                  _authService.setUserType(UserType.seller);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(100),
                            borderColor: Colors.transparent,
                            selectedBorderColor: Colors.transparent,
                            selectedColor: Colors.white,
                            fillColor: const Color.fromARGB(255, 252, 83, 89),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Text("Buyer"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Text("Seller"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24.0),

                  // Full-width Gradient Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _authService.signup(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            phoneNumber: phoneNumberController.text.trim(),
                            context: context,
                          );
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
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: constraints.maxHeight * 0.1),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
