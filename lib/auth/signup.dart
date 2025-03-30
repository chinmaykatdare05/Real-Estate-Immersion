import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter03/auth/auth_service.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

// This widget represents the Sign Up screen where users can create a new account.
// It includes a form with validation for name, email, password, and phone number inputs.
// The form is validated before submission, and the user is redirected to the home screen upon successful sign up.
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
                          decoration: InputDecoration(
                            hintText: "Enter your Name",
                            labelText: "Name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
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
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            labelText: "Email Address",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
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
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
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
                          decoration: InputDecoration(
                            hintText: "Enter your phone number",
                            labelText: "Phone Number",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Color(0xFFFF7643)),
                            ),
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
                  StatefulBuilder(
                    builder: (context, setState) {
                      UserType selectedUserType = _authService.userType;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text("Buyer"),
                            selected: selectedUserType == UserType.buyer,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selectedUserType = UserType.buyer;
                                  _authService.setUserType(UserType.buyer);
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 16),
                          ChoiceChip(
                            label: const Text("Seller"),
                            selected: selectedUserType == UserType.seller,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selectedUserType = UserType.seller;
                                  _authService.setUserType(UserType.seller);
                                });
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
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
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 216, 16, 83),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Sign Up"),
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
