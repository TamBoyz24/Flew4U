import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final bool seen;

  const SplashScreen({super.key, required this.seen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (widget.seen) {
        Navigator.pushReplacementNamed(context, '/signin');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 🔥 ẢNH NỀN TỪ ASSETS
          Image.asset(
            "assets/images/Splash.png",
            fit: BoxFit.cover,
          ),

          /// 🔥 LỚP MỜ TỐI
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          /// 🔥 LOGO / TEXT
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flight_takeoff,
                  color: Colors.white,
                  size: 80,
                ),

                SizedBox(height: 20),

                Text(
                  "Flew4U",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Explore Your Journey",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}