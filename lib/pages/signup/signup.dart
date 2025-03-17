import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter03/services/auth_service.dart';

// Icons (same as in your first code)
const userIcon =
    '''<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M14.8331 14.6608C14.6271 14.9179 14.3055 15.0713 13.9729 15.0713H2.02715C1.69446 15.0713 1.37287 14.9179 1.16692 14.6608C0.972859 14.4191 0.906322 14.1271 0.978404 13.8382C1.77605 10.6749 4.66327 8.46512 8.0004 8.46512C11.3367 8.46512 14.2239 10.6749 15.0216 13.8382C15.0937 14.1271 15.0271 14.4191 14.8331 14.6608ZM4.62208 4.23295C4.62208 2.41197 6.13737 0.929467 8.0004 0.929467C9.86263 0.929467 11.3779 2.41197 11.3779 4.23295C11.3779 6.0547 9.86263 7.53565 8.0004 7.53565C6.13737 7.53565 4.62208 6.0547 4.62208 4.23295ZM15.9444 13.6159C15.2283 10.7748 13.0231 8.61461 10.2571 7.84315C11.4983 7.09803 12.3284 5.75882 12.3284 4.23295C12.3284 1.89921 10.387 0 8.0004 0C5.613 0 3.67155 1.89921 3.67155 4.23295C3.67155 5.75882 4.50168 7.09803 5.7429 7.84315C2.97688 8.61461 0.771665 10.7748 0.0556038 13.6159C-0.0861827 14.179 0.0460985 14.7692 0.419179 15.2332C0.808894 15.7212 1.39584 16 2.02715 16H13.9729C14.6042 16 15.1911 15.7212 15.5808 15.2332C15.9539 14.7692 16.0862 14.179 15.9444 13.6159Z" fill="#626262"/>
</svg>
''';

const phoneIcon =
    '''<svg width="11" height="18" viewBox="0 0 11 18" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M6.33333 15.0893C6.33333 15.5588 5.96 15.9384 5.5 15.9384C5.04 15.9384 4.66667 15.5588 4.66667 15.0893C4.66667 14.6197 5.04 14.2402 5.5 14.2402C5.96 14.2402 6.33333 14.6197 6.33333 15.0893ZM6.83333 2.63135C6.83333 2.91325 6.61 3.14081 6.33333 3.14081H4.66667C4.39 3.14081 4.16667 2.91325 4.16667 2.63135C4.16667 2.34945 4.39 2.12274 4.66667 2.12274H6.33333C6.61 2.12274 6.83333 2.34945 6.83333 2.63135ZM10 15.7923C10 16.4479 9.47667 16.9819 8.83333 16.9819H2.16667C1.52333 16.9819 1 16.4479 1 15.7923V2.2068C1 1.55215 1.52333 1.01807 2.16667 1.01807H8.83333C9.47667 1.01807 10 1.55215 10 2.2068V15.7923ZM8.83333 0H2.16667C0.971667 0 0 0.990047 0 2.2068V15.7923C0 17.01 0.971667 18 2.16667 18H8.83333C10.0283 18 11 17.01 11 15.7923V2.2068C11 0.990047 10.0283 0 8.83333 0Z" fill="#626262"/>
</svg>
''';

/// A consistent OutlineInputBorder for all form fields
const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class SignupPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final AuthService _authService = AuthService();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar with white background, "Sign up" in gray
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Sign up",
          style: TextStyle(color: Color.fromARGB(255, 251, 81, 81)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF757575)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Big "Complete Profile" title
                const Text(
                  "Complete Profile",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                const Text(
                  "Complete your details or continue \nwith social media",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF757575)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                // The form
                Form(
                  child: Column(
                    children: [
                      // Name Field
                      TextFormField(
                        controller: nameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                        ],
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          labelText: "Name",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          suffix: SvgPicture.string(userIcon),
                          border: authOutlineInputBorder,
                          enabledBorder: authOutlineInputBorder,
                          focusedBorder: authOutlineInputBorder.copyWith(
                            borderSide: const BorderSide(color: Color(0xFFFF7643)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                        ],
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          labelText: "Email Address",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          // You can add an SVG icon for email if you like:
                          // suffix: SvgPicture.string(emailIcon),
                          border: authOutlineInputBorder,
                          enabledBorder: authOutlineInputBorder,
                          focusedBorder: authOutlineInputBorder.copyWith(
                            borderSide: const BorderSide(color: Color(0xFFFF7643)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password Field
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          labelText: "Password",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          border: authOutlineInputBorder,
                          enabledBorder: authOutlineInputBorder,
                          focusedBorder: authOutlineInputBorder.copyWith(
                            borderSide: const BorderSide(color: Color(0xFFFF7643)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Phone Number Field
                      TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter your phone number",
                          labelText: "Phone Number",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          suffix: SvgPicture.string(phoneIcon),
                          border: authOutlineInputBorder,
                          enabledBorder: authOutlineInputBorder,
                          focusedBorder: authOutlineInputBorder.copyWith(
                            borderSide: const BorderSide(color: Color(0xFFFF7643)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Spacing before button
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                // "Continue" Button
                ElevatedButton(
                  onPressed: () {
                    _authService.signup(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      phoneNumber: phoneNumberController.text.trim(),
                      context: context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 255, 67, 67),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                  child: const Text("Continue"),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.10),

                // Terms and Conditions Text
                const Text(
                  "By continuing your confirm that you agree \nwith our Term and Condition",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
