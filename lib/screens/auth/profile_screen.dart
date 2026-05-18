import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  String name = "";
  String email = "";
  String avatar = "";

  Future<void> loadUser() async {

    final prefs =
        await SharedPreferences.getInstance();

    name =
        prefs.getString("name") ?? "";

    email =
        prefs.getString("email") ?? "";

    avatar =
        prefs.getString("avatar") ?? "";

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Widget avatarWidget() {

    if (avatar.isNotEmpty) {

      if (kIsWeb) {

        return CircleAvatar(
          radius: 55,
          backgroundImage:
              AssetImage("assets/images/anhdaidien.png"),
        );
      }

      return CircleAvatar(
        radius: 55,
        backgroundImage:
            FileImage(File(avatar)),
      );
    }

    return const CircleAvatar(
      radius: 55,
      backgroundColor: Colors.teal,
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 55,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 20),

            avatarWidget(),

            const SizedBox(height: 20),

            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              email,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            ListTile(
              leading:
                  const Icon(Icons.edit),

              title:
                  const Text("Edit Profile"),

              trailing:
                  const Icon(Icons.arrow_forward_ios),

              onTap: () async {

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const EditProfileScreen(),
                  ),
                );

                loadUser();
              },
            ),
          ],
        ),
      ),
    );
  }
}