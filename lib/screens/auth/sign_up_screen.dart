/// ============================
/// SIGN UP SCREEN
/// ============================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState
    extends State<SignUpScreen> {

  String role = "traveler";

  final firstNameCtrl =
      TextEditingController();

  final lastNameCtrl =
      TextEditingController();

  final countryCtrl =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passController =
      TextEditingController();

  final confirmPassController =
      TextEditingController();

  /// SIGN UP
  void handleSignUp() async {

    if (firstNameCtrl.text.isEmpty ||
        lastNameCtrl.text.isEmpty ||
        countryCtrl.text.isEmpty ||
        emailController.text.isEmpty ||
        passController.text.isEmpty ||
        confirmPassController.text.isEmpty) {

      showMsg("Please fill all fields");
      return;
    }

    if (passController.text !=
        confirmPassController.text) {

      showMsg("Password does not match");
      return;
    }

    try {

      /// API REGISTER
      await ApiService.register(
        name:
            "${firstNameCtrl.text} ${lastNameCtrl.text}",

        email: emailController.text,

        password: passController.text,
      );

      /// LOCAL SAVE
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'email',
        emailController.text,
      );

      await prefs.setString(
        'password',
        passController.text,
      );

      await prefs.setString(
        'name',
        "${firstNameCtrl.text} ${lastNameCtrl.text}",
      );

      await prefs.setString(
        'country',
        countryCtrl.text,
      );

      await prefs.setString(
        'role',
        role,
      );

      if (!mounted) return;

      showMsg("Register Success");

      Navigator.pushReplacementNamed(
        context,
        '/main',
      );

    } catch (e) {

      showMsg("Register Failed");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,

      hintStyle:
          const TextStyle(color: Colors.grey),

      border: const UnderlineInputBorder(),

      enabledBorder:
          const UnderlineInputBorder(
        borderSide:
            BorderSide(color: Colors.grey),
      ),

      focusedBorder:
          const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF00C2A8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
              height: 220,
              width: double.infinity,

              decoration:
                  const BoxDecoration(
                color: Color(0xFF00C2A8),

                borderRadius:
                    BorderRadius.only(
                  bottomLeft:
                      Radius.circular(100),

                  bottomRight:
                      Radius.circular(100),
                ),
              ),

              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),

                  child: Align(
                    alignment:
                        Alignment.topLeft,

                    child: Container(
                      width: 50,
                      height: 50,

                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(15),
                      ),

                      child: const Icon(
                        Icons.flutter_dash,
                        color:
                            Color(0xFF00C2A8),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(22),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Sign Up",

                    style: TextStyle(
                      fontSize: 34,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// ROLE
                  Row(
                    children: [

                      Row(
                        children: [

                          Radio(
                            value: "traveler",

                            groupValue: role,

                            activeColor:
                                const Color(
                                    0xFF00C2A8),

                            onChanged: (value) {

                              setState(() {
                                role = value!;
                              });
                            },
                          ),

                          const Text("Traveler"),
                        ],
                      ),

                      const SizedBox(width: 20),

                      Row(
                        children: [

                          Radio(
                            value: "guide",

                            groupValue: role,

                            activeColor:
                                const Color(
                                    0xFF00C2A8),

                            onChanged: (value) {

                              setState(() {
                                role = value!;
                              });
                            },
                          ),

                          const Text("Guide"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// FIRST + LAST
                  Row(
                    children: [

                      Expanded(
                        child: TextField(
                          controller:
                              firstNameCtrl,

                          decoration:
                              inputStyle(
                            "First Name",
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: TextField(
                          controller:
                              lastNameCtrl,

                          decoration:
                              inputStyle(
                            "Last Name",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: countryCtrl,
                    decoration:
                        inputStyle("Country"),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller:
                        emailController,

                    decoration:
                        inputStyle("Email"),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passController,

                    obscureText: true,

                    decoration:
                        inputStyle("Password"),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Password has more than 6 letters",

                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller:
                        confirmPassController,

                    obscureText: true,

                    decoration: inputStyle(
                      "Confirm Password",
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text.rich(
                      TextSpan(
                        text:
                            "By Signing Up, you agree to our ",

                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),

                        children: [

                          TextSpan(
                            text:
                                "Terms & Conditions",

                            style: TextStyle(
                              color: Color(
                                  0xFF00C2A8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(

                      onPressed: handleSignUp,

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                                0xFF00C2A8),
                      ),

                      child: const Text(
                        "REGISTER",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: GestureDetector(

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/signin',
                        );
                      },

                      child: const Text.rich(
                        TextSpan(
                          text:
                              "Already have an account? ",

                          style: TextStyle(
                              color: Colors.grey),

                          children: [

                            TextSpan(
                              text: "Sign In",

                              style: TextStyle(
                                color: Color(
                                    0xFF00C2A8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}