import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String avatarPath = "";

  final ImagePicker picker = ImagePicker();

  /// LOAD USER
  Future<void> loadData() async {

    final prefs =
        await SharedPreferences.getInstance();

    nameController.text =
        prefs.getString("name") ?? "";

    emailController.text =
        prefs.getString("email") ?? "";

    avatarPath =
        prefs.getString("avatar") ?? "";

    setState(() {});
  }

  /// PICK IMAGE
  Future<void> pickAvatar() async {

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        "avatar",
        image.path,
      );

      avatarPath = image.path;

      setState(() {});
    }
  }

  /// SAVE
  Future<void> save() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "name",
      nameController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text("Profile updated"),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget avatarWidget() {

    if (avatarPath.isNotEmpty) {

      if (kIsWeb) {

        return CircleAvatar(
          radius: 55,
          backgroundImage:
              NetworkImage(avatarPath),
        );
      }

      return CircleAvatar(
        radius: 55,
        backgroundImage:
            FileImage(File(avatarPath)),
      );
    }

    return const CircleAvatar(
      radius: 55,
      backgroundColor: Colors.teal,
      child: Icon(
        Icons.person,
        size: 55,
        color: Colors.white,
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
        title: const Text("Edit Profile"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// AVATAR
            Stack(
              children: [

                avatarWidget(),

                Positioned(
                  bottom: 0,
                  right: 0,

                  child: GestureDetector(
                    onTap: pickAvatar,

                    child: Container(
                      padding:
                          const EdgeInsets.all(8),

                      decoration:
                          const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// NAME
            TextField(
              controller: nameController,

              decoration: InputDecoration(
                labelText: "Name",

                prefixIcon:
                    const Icon(Icons.person),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// EMAIL
            TextField(
              controller: emailController,
              readOnly: true,

              decoration: InputDecoration(
                labelText: "Email",

                prefixIcon:
                    const Icon(Icons.email),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: save,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.teal,
                ),

                child: const Text(
                  "SAVE",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}