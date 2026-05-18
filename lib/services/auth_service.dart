import 'package:flutter/foundation.dart';

class AuthService {
  static Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    await Future.delayed(Duration(seconds: 2));
    debugPrint("Register: $name - $email");
  }

  static Future<void> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    debugPrint("Login: $email");
  }

  static Future<void> forgotPassword(String email) async {
    await Future.delayed(Duration(seconds: 2));
    debugPrint("Reset password: $email");
  }
}
