import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  String name = "";
  String email = "[EMAIL_ADDRESS]";

  /// AVATAR
  String avatar = "";

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  void loadUserInfo() async {

    final prefs =
        await SharedPreferences.getInstance();

    setState(() {

      name =
          prefs.getString('name') ??
              "User";

      email =
          prefs.getString('email') ??
              "No Email";

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
        radius: 35,

        backgroundImage:
            NetworkImage(
          "https://i.pravatar.cc/150?img=5",
        ),
      );
    }

    /// WEB
    if (kIsWeb) {

      return CircleAvatar(
        radius: 35,

        backgroundImage:
            NetworkImage(avatar),
      );
    }

    /// MOBILE
    return CircleAvatar(
      radius: 35,

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

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Stack(
              clipBehavior: Clip.none,

              children: [

                Container(
                  height: 250,
                  width: double.infinity,

                  decoration:
                      const BoxDecoration(
                    image:
                        DecorationImage(
                      image: NetworkImage(
                        "https://picsum.photos/600/300?nature",
                      ),

                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,

                  child: Container(
                    height: 100,

                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin: Alignment
                            .bottomCenter,

                        end: Alignment
                            .topCenter,

                        colors: [
                          Colors.black
                              .withValues(
                            alpha: 0.6,
                          ),

                          Colors
                              .transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,

                  child: Row(
                    children: [

                      Container(
                        padding:
                            const EdgeInsets
                                .all(2),

                        decoration:
                            const BoxDecoration(
                          color:
                              Colors.white,

                          shape:
                              BoxShape.circle,
                        ),

                        child:
                            avatarWidget(),
                      ),

                      const SizedBox(
                          width: 15),

                      Column(
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
                              fontSize: 20,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 4),

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
                      )
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// MY PHOTOS
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  const Text(
                    "My Photos",

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),

                    onPressed: () =>
                        Navigator.pushNamed(
                      context,
                      '/photos',
                    ),
                  )
                ],
              ),
            ),

            photoGrid(),

            const SizedBox(height: 20),

            /// MY JOURNEYS
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  const Text(
                    "My Journeys",

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),

                    onPressed: () =>
                        Navigator.pushNamed(
                      context,
                      '/journeys',
                    ),
                  )
                ],
              ),
            ),

            journeyList(),

            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(
          context,
          '/settings',
        ).then((_) {
          loadUserInfo();
        }),

        backgroundColor:
            Colors.teal,

        child: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget photoGrid() {

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,

        physics:
            const NeverScrollableScrollPhysics(),

        itemCount: 6,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),

        itemBuilder: (_, i) {

          return ClipRRect(
            borderRadius:
                BorderRadius.circular(8),

            child: Image.network(
              "https://picsum.photos/200?random=$i",
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget journeyList() {

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: Column(
        children:
            List.generate(2, (i) {

          return Container(
            margin:
                const EdgeInsets.only(
              bottom: 20,
            ),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                      15),

              boxShadow: [
                BoxShadow(
                  color:
                      Colors.grey.withValues(
                    alpha: 0.1,
                  ),

                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),

            child: Column(
              children: [

                SizedBox(
                  height: 180,

                  child: Row(
                    children: [

                      Expanded(
                        flex: 2,

                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.only(
                            topLeft:
                                Radius.circular(
                                    15),
                          ),

                          child: Image.network(
                            "https://picsum.photos/400?random=${i * 3}",

                            fit: BoxFit.cover,
                            height:
                                double.infinity,
                          ),
                        ),
                      ),

                      const SizedBox(width: 2),

                      Expanded(
                        flex: 1,

                        child: Column(
                          children: [

                            Expanded(
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.only(
                                  topRight:
                                      Radius.circular(
                                          15),
                                ),

                                child:
                                    Image.network(
                                  "https://picsum.photos/200?random=${i * 3 + 1}",

                                  fit:
                                      BoxFit.cover,
                                  width:
                                      double.infinity,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 2),

                            Expanded(
                              child:
                                  Image.network(
                                "https://picsum.photos/200?random=${i * 3 + 2}",

                                fit:
                                    BoxFit.cover,
                                width:
                                    double.infinity,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.all(
                          15),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              i == 0
                                  ? "A memory in Danang"
                                  : "Sapa in spring",

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(
                                height: 6),

                            Row(
                              children: [

                                const Icon(
                                  Icons.location_on,
                                  color:
                                      Colors.teal,
                                  size: 12,
                                ),

                                const SizedBox(
                                    width: 4),

                                Text(
                                  i == 0
                                      ? "Danang, Vietnam"
                                      : "Sapa, Vietnam",

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.teal,
                                    fontSize:
                                        11,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: 6),

                            Text(
                              i == 0
                                  ? "Jan 20, 2020"
                                  : "Jan 23, 2020",

                              style:
                                  const TextStyle(
                                color:
                                    Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,

                        children: [

                          const Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                          ),

                          const SizedBox(
                              height: 15),

                          Row(
                            children: [

                              const Icon(
                                Icons.favorite_border,
                                color:
                                    Colors.teal,
                                size: 14,
                              ),

                              const SizedBox(
                                  width: 4),

                              Text(
                                "294 Likes",

                                style: TextStyle(
                                  color: Colors
                                      .teal
                                      .shade300,

                                  fontSize: 11,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}