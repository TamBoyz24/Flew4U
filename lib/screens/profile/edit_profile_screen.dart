import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final firstCtrl =
      TextEditingController();

  final lastCtrl =
      TextEditingController();

  final passCtrl =
      TextEditingController();

  final bioCtrl =
      TextEditingController();

  String avatar = "";
  String email = "";
  String role = "Traveler";
  String bio = "";

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// LOAD USER DATA
  Future<void> loadData() async {

    final prefs =
        await SharedPreferences.getInstance();

    String fullName =
        prefs.getString("name") ??
            "Traveler";

    List<String> parts =
        fullName.split(" ");

    firstCtrl.text =
        parts.isNotEmpty
            ? parts.first
            : "";

    lastCtrl.text =
        parts.length > 1
            ? parts
                .sublist(1)
                .join(" ")
            : "";

    passCtrl.text =
        prefs.getString(
              "password",
            ) ??
            "";

    avatar =
        prefs.getString(
              "avatar",
            ) ??
            "";

    email =
        prefs.getString(
              "email",
            ) ??
            "example@gmail.com";

    role =
        prefs.getString(
              "role",
            ) ??
            "Traveler";

    bio =
        prefs.getString(
              "bio",
            ) ??
            "";

    bioCtrl.text = bio;

    if (!mounted) return;

    setState(() {});
  }

  /// PICK AVATAR
  Future<void> pickAvatar() async {

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "avatar",
      image.path,
    );

    if (!mounted) return;

    setState(() {
      avatar = image.path;
    });
  }

  /// SAVE PROFILE
  Future<void> saveProfile() async {

    final prefs =
        await SharedPreferences.getInstance();

    String fullName =
        "${firstCtrl.text.trim()} ${lastCtrl.text.trim()}";

    await prefs.setString(
      "name",
      fullName,
    );

    await prefs.setString(
      "password",
      passCtrl.text.trim(),
    );

    await prefs.setString(
      "bio",
      bioCtrl.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Profile Updated"),
      ),
    );

    Navigator.pop(context, true);
  }

  /// AVATAR
  Widget avatarWidget() {

    /// DEFAULT
    if (avatar.isEmpty) {

      return const CircleAvatar(
        radius: 45,

        backgroundImage:
            NetworkImage(
          "https://i.pravatar.cc/150?img=5",
        ),
      );
    }

    /// WEB
    if (kIsWeb) {

      return CircleAvatar(
        radius: 45,

        backgroundImage:
            NetworkImage(avatar),

        onBackgroundImageError:
            (_, __) {},
      );
    }

    /// MOBILE
    if (File(avatar).existsSync()) {

      return CircleAvatar(
        radius: 45,

        backgroundImage:
            FileImage(
          File(avatar),
        ),
      );
    }

    /// FALLBACK
    return const CircleAvatar(
      radius: 45,

      backgroundImage:
          NetworkImage(
        "https://i.pravatar.cc/150?img=5",
      ),
    );
  }

  /// CARD
  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                18),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),

            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                icon,
                color: Colors.teal,
              ),

              const SizedBox(
                  width: 10),

              Text(
                title,

                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(
              height: 15),

          child,
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      backgroundColor:
          Colors.grey[100],

      appBar: AppBar(
        backgroundColor:
            Colors.white,

        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),

          onPressed: () =>
              Navigator.pop(
                  context),
        ),

        title: const Text(
          "Edit Profile",

          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [

          TextButton(
            onPressed:
                saveProfile,

            child: const Text(
              "SAVE",

              style: TextStyle(
                color: Colors.teal,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                20),

        child: Column(
          children: [

            /// HEADER
            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets
                      .all(25),

              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Colors.teal,
                    Colors.tealAccent,
                  ],
                ),

                borderRadius:
                    BorderRadius
                        .circular(25),
              ),

              child: Column(
                children: [

                  /// AVATAR
                  Stack(
                    children: [

                      avatarWidget(),

                      Positioned(
                        bottom: 0,
                        right: -5,

                        child:
                            GestureDetector(
                          onTap:
                              pickAvatar,

                          child:
                              Container(
                            padding:
                                const EdgeInsets
                                    .all(6),

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.teal,

                              shape: BoxShape
                                  .circle,

                              border:
                                  Border.all(
                                color: Colors
                                    .white,

                                width: 2,
                              ),
                            ),

                            child:
                                const Icon(
                              Icons
                                  .camera_alt,

                              color: Colors
                                  .white,

                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 15),

                  Text(
                    "${firstCtrl.text} ${lastCtrl.text}",

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 5),

                  Text(
                    email,

                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),

                  const SizedBox(
                      height: 8),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors
                          .white
                          .withOpacity(
                              0.2),

                      borderRadius:
                          BorderRadius
                              .circular(
                                  20),
                    ),

                    child: Text(
                      role,

                      style:
                          const TextStyle(
                        color: Colors
                            .white,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
                height: 25),

            /// PERSONAL
            buildInfoCard(
              icon: Icons.person,
              title:
                  "Personal Information",

              child: Column(
                children: [

                  TextField(
                    controller:
                        firstCtrl,

                    decoration:
                        InputDecoration(
                      labelText:
                          "First Name",

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    15),
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 15),

                  TextField(
                    controller:
                        lastCtrl,

                    decoration:
                        InputDecoration(
                      labelText:
                          "Last Name",

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// EMAIL
            buildInfoCard(
              icon: Icons.email,
              title: "Email",

              child: TextField(
                readOnly: true,

                decoration:
                    InputDecoration(
                  hintText: email,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                15),
                  ),
                ),
              ),
            ),

            /// PASSWORD
            buildInfoCard(
              icon: Icons.lock,
              title: "Password",

              child: TextField(
                controller:
                    passCtrl,

                obscureText: true,

                decoration:
                    InputDecoration(
                  labelText:
                      "Password",

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                15),
                  ),
                ),
              ),
            ),

            /// BIO
            buildInfoCard(
              icon: Icons.info,
              title: "Bio",

              child: TextField(
                controller:
                    bioCtrl,

                maxLines: 4,

                decoration:
                    InputDecoration(
                  hintText:
                      "Tell everyone about yourself...",

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                15),
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 10),

            /// BUTTON
            SizedBox(
              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton(
                onPressed:
                    saveProfile,

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.teal,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                18),
                  ),
                ),

                child: const Text(
                  "SAVE PROFILE",

                  style: TextStyle(
                    color:
                        Colors.white,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 30),
          ],
        ),
      ),
    );
  }
}