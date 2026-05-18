import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  String name = "Traveler";
  String email = "";

  /// ADD AVATAR
  String avatar = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {

    final prefs =
        await SharedPreferences.getInstance();

    setState(() {

      name =
          prefs.getString("name") ??
              "Traveler";

      email =
          prefs.getString("email") ??
              "";

      /// LOAD AVATAR
      avatar =
          prefs.getString("avatar") ??
              "";
    });
  }

  /// AVATAR WIDGET
  Widget avatarWidget() {

    /// DEFAULT
    if (avatar.isEmpty) {

      return const CircleAvatar(
        radius: 25,
        backgroundImage:
            NetworkImage(
          "https://i.pravatar.cc/150?img=5",
        ),
      );
    }

    /// WEB
    if (kIsWeb) {

      return CircleAvatar(
        radius: 25,
        backgroundImage:
            NetworkImage(avatar),
      );
    }

    /// MOBILE
    return CircleAvatar(
      radius: 25,
      backgroundImage:
          FileImage(
        File(avatar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),

          onPressed: () =>
              Navigator.pop(context),
        ),

        title: const Text(
          "Settings",

          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color:
                    Colors.tealAccent.shade400,

                borderRadius:
                    BorderRadius.circular(
                        15),
              ),

              child: Row(
                children: [

                  /// AVATAR
                  avatarWidget(),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(
                          name,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        Text(
                          email,

                          style:
                              const TextStyle(
                            color:
                                Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  OutlinedButton(
                    style:
                        OutlinedButton
                            .styleFrom(
                      side:
                          const BorderSide(
                        color: Colors.white,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    5),
                      ),
                    ),

                    onPressed: () {

                      Navigator.pushNamed(
                        context,
                        '/edit',
                      ).then((_) {
                        loadUser();
                      });
                    },

                    child: const Text(
                      "EDIT PROFILE",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            _buildSwitchItem(
              Icons.notifications_none,
              "Notifications",
              true,
            ),

            _buildNavItem(
              context,
              Icons.language,
              "Languages",
              null,
            ),

            _buildNavItem(
              context,
              Icons.credit_card,
              "Payment",
              null,
            ),

            _buildNavItem(
              context,
              Icons.privacy_tip_outlined,
              "Privacy & Policies",
              null,
            ),

            _buildNavItem(
              context,
              Icons.feedback_outlined,
              "Feedback",
              null,
            ),

            _buildNavItem(
              context,
              Icons.insert_page_break_outlined,
              "Usage",
              null,
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () {

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                  '/signin',
                  (route) => false,
                );
              },

              child: const Padding(
                padding:
                    EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),

                child: Row(
                  children: [

                    SizedBox(width: 32),

                    Text(
                      "Sign out",

                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    String? route,
  ) {

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),

      leading: Icon(
        icon,
        color: Colors.grey,
        size: 22,
      ),

      title: Text(
        title,

        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),

      onTap: () {

        if (route != null) {

          Navigator.pushNamed(
            context,
            route,
          );
        }
      },
    );
  }

  Widget _buildSwitchItem(
    IconData icon,
    String title,
    bool initialValue,
  ) {

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),

      leading: Icon(
        icon,
        color: Colors.grey,
        size: 22,
      ),

      title: Text(
        title,

        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),

      trailing: Switch(
        value: initialValue,
        onChanged: (val) {},

        activeColor:
            Colors.tealAccent.shade400,
      ),
    );
  }
}