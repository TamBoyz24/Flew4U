/// ============================
/// SIGN IN SCREEN
/// ============================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() =>
      _SignInScreenState();
}

class _SignInScreenState
    extends State<SignInScreen> {

  final emailCtrl =
      TextEditingController();

  final passCtrl =
      TextEditingController();

  /// LOGIN
  void login() async {

    if (emailCtrl.text.isEmpty ||
        passCtrl.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Please fill all fields"),
        ),
      );

      return;
    }

    try {

      /// API LOGIN
      final data = await ApiService.login(
  email: emailCtrl.text,
  password: passCtrl.text,
);

      print(data);

      /// SAVE LOCAL
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'email',
        emailCtrl.text,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/main',
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text("Wrong account"),
        ),
      );
    }
  }

  InputDecoration inputStyle(String label) {

    return InputDecoration(

      labelText: label,

      border: const UnderlineInputBorder(),

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
            ),

            Padding(
              padding:
                  const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Sign In",

                    style: TextStyle(
                      fontSize: 34,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Welcome back",

                    style: TextStyle(
                      color:
                          Color(0xFF00C2A8),
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// EMAIL
                  TextField(
                    controller: emailCtrl,

                    decoration:
                        inputStyle("Email"),
                  ),

                  const SizedBox(height: 20),

                  /// PASSWORD
                  TextField(
                    controller: passCtrl,

                    obscureText: true,

                    decoration:
                        inputStyle("Password"),
                  ),

                  const SizedBox(height: 10),

                  /// FORGOT PASSWORD
                  GestureDetector(

                    onTap: () {

                      Navigator.pushNamed(
                        context,
                        '/forgotpassword',
                      );
                    },

                    child: const Text(
                      "Forgot Password",

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(

                      onPressed: login,

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                                0xFF00C2A8),
                      ),

                      child: const Text(
                        "LOGIN",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// GO SIGN UP
                  Center(
                    child: GestureDetector(

                      onTap: () {

                        Navigator.pushNamed(
                          context,
                          '/signup',
                        );
                      },

                      child: const Text.rich(
                        TextSpan(
                          text:
                              "Don't have an account? ",

                          style: TextStyle(
                            color: Colors.grey,
                          ),

                          children: [

                            TextSpan(
                              text: "Sign Up",

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