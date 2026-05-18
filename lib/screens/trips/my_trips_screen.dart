import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../detail/trip_detail_screen.dart';
import 'create_trip_screen.dart';
import '../../services/api_service.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final tabTitles = [
    "Current Trips",
    "Next Trips",
    "Past Trips",
    "Wish List",
  ];

  final tabValues = [
    "Current",
    "Next",
    "Past",
    "Wishlist",
  ];

  List trips = [];

  /// USER
  String avatar = "";
  String userName = "";

  XFile? selectedImage;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    loadTrips();
    loadUser();
  }

  /// LOAD USER
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      avatar = prefs.getString("avatar") ?? "";

      userName = prefs.getString("name") ?? "Traveler";
    });
  }

  /// PICK AVATAR
  Future<void> pickAvatar() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      String imagePath = "";

      /// WEB
      if (kIsWeb) {
        final bytes = await image.readAsBytes();

        imagePath =
            "data:image/png;base64,${base64Encode(bytes)}";
      } else {
        final dir =
            await getApplicationDocumentsDirectory();

        final newPath =
            "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png";

        final newImage =
            await File(image.path).copy(newPath);

        imagePath = newImage.path;
      }

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        "avatar",
        imagePath,
      );

      setState(() {
        selectedImage = image;
        avatar = imagePath;
      });
    }
  }

  /// LOAD TRIPS
  Future<void> loadTrips() async {
    try {
      final data = await ApiService.getTrips();

      setState(() {
        trips = List.from(data);
      });
    } catch (e) {
      debugPrint("Error loading trips: $e");

      setState(() {
        trips = [];
      });
    }
  }

  /// DELETE TRIP
  Future<void> deleteTrip(Map trip) async {
    if (trip["id"] != null) {
      await ApiService.deleteTripById(
        trip["id"].toString(),
      );
    }

    await loadTrips();
  }

  /// BUILD IMAGE
  Widget buildImage(String? image) {
    Widget fallback() {
      return Image.asset(
        "assets/images/cau_rong.jpg",
        fit: BoxFit.cover,
      );
    }

    if (image == null || image.isEmpty) {
      return fallback();
    }

    /// BASE64 IMAGE (WEB)
    if (image.startsWith("data:image")) {
      try {
        final base64Str =
            image.split(",").last;

        return Image.memory(
          base64Decode(base64Str),
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) =>
                  fallback(),
        );
      } catch (e) {
        return fallback();
      }
    }

    /// NETWORK IMAGE
    if (image.startsWith("http")) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) =>
                fallback(),
      );
    }

    /// ASSET IMAGE
    if (image.startsWith("assets/")) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
      );
    }

    /// FILE IMAGE (MOBILE)
    if (!kIsWeb) {
      try {
        if (File(image).existsSync()) {
          return Image.file(
            File(image),
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) =>
                    fallback(),
          );
        }
      } catch (e) {
        return fallback();
      }
    }

    return fallback();
  }

  /// AVATAR
  Widget avatarWidget() {
    if (avatar.isNotEmpty) {
      /// WEB
      if (kIsWeb &&
          avatar.startsWith("data:image")) {
        try {
          final bytes = base64Decode(
            avatar.split(",").last,
          );

          return CircleAvatar(
            radius: 22,
            backgroundImage:
                MemoryImage(bytes),
          );
        } catch (e) {
          return const CircleAvatar(
            radius: 22,
            child: Icon(Icons.person),
          );
        }
      }

      /// MOBILE
      if (!kIsWeb) {
        try {
          if (File(avatar).existsSync()) {
            return CircleAvatar(
              radius: 22,
              backgroundImage:
                  FileImage(
                File(avatar),
              ),
            );
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }

    return const CircleAvatar(
      radius: 22,
      backgroundColor: Colors.teal,
      child: Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabValues.length,
      child: Scaffold(
        backgroundColor: Colors.grey[100],

        /// BODY
        body: Column(
          children: [
            /// HEADER
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "assets/images/cau_rong.jpg",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(
                      begin: Alignment
                          .bottomCenter,
                      end:
                          Alignment.topCenter,
                      colors: [
                        Colors.teal
                            .withOpacity(
                                0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      const Text(
                        "My Trips",
                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize: 28,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      GestureDetector(
                        onTap: pickAvatar,
                        child:
                            avatarWidget(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// TAB BAR
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(
                top: 15,
                bottom: 10,
              ),
              child: TabBar(
                isScrollable: true,
                tabAlignment:
                    TabAlignment.start,
                indicator:
                    BoxDecoration(
                  color: Colors.teal,
                  borderRadius:
                      BorderRadius
                          .circular(20),
                ),
                labelColor:
                    Colors.white,
                unselectedLabelColor:
                    Colors.grey.shade500,
                indicatorSize:
                    TabBarIndicatorSize
                        .label,
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 10,
                ),
                tabs:
                    tabTitles.map((e) {
                  return Tab(
                    child: Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        e,
                        style:
                            const TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            /// LIST
            Expanded(
              child: TabBarView(
                children:
                    tabValues.map(
                  (tabStatus) {
                    final list = trips
                        .where(
                          (e) =>
                              e["status"] ==
                              tabStatus,
                        )
                        .toList();

                    if (list.isEmpty) {
                      return const Center(
                        child: Text(
                          "No trips to display.",
                          style: TextStyle(
                            color:
                                Colors
                                    .grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding:
                          const EdgeInsets
                              .only(
                        top: 10,
                        bottom: 80,
                      ),
                      itemCount:
                          list.length,
                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        final trip =
                            list[index];

                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        TripDetailScreen(
                                  trip:
                                      trip,
                                  onDelete:
                                      () =>
                                          deleteTrip(
                                              trip),
                                ),
                              ),
                            );

                            loadTrips();
                          },
                          child: tripCard(
                            trip,
                            tabStatus,
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),

        /// ADD BUTTON
        floatingActionButton:
            FloatingActionButton(
          backgroundColor:
              Colors.teal,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        const CreateTripScreen(),
              ),
            );

            /// RELOAD
            await loadTrips();
          },
        ),
      ),
    );
  }

  /// CARD
  Widget tripCard(
    Map trip,
    String tabName,
  ) {
    if (tabName == "Wishlist") {
      return _buildWishlistCard(trip);
    }

    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildCardImageHeader(
            trip,
            tabName,
          ),

          _buildCardInfoDetailed(
            trip,
            tabName,
          ),
        ],
      ),
    );
  }

  /// IMAGE HEADER
  Widget _buildCardImageHeader(
    Map trip,
    String tabName,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          child: SizedBox(
            height: 160,
            width: double.infinity,
            child: buildImage(
              trip["image"],
            ),
          ),
        ),

        Positioned(
          bottom: 12,
          left: 12,
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 14,
              ),

              const SizedBox(width: 4),

              Text(
                trip["city"] ??
                    "Unknown",
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: -20,
          right: 16,
          child: avatarWidget(),
        ),
      ],
    );
  }

  /// INFO
  Widget _buildCardInfoDetailed(
    Map trip,
    String tabName,
  ) {
    return Padding(
      padding:
          const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            trip["city"] != null
                ? "${trip["city"]} Trip"
                : "Trip",
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          infoRow(
            Icons.calendar_today,
            trip["date"] ?? "",
          ),

          const SizedBox(height: 8),

          infoRow(
            Icons.access_time,
            "${trip["from"] ?? ""} - ${trip["to"] ?? ""}",
          ),

          const SizedBox(height: 8),

          infoRow(
            Icons.person_outline,
            trip["userName"] ??
                userName,
          ),

          const SizedBox(height: 16),

          if (tabName == "Current")
            buttonRow(["Detail"]),

          if (tabName == "Next")
            buttonRow([
              "Detail",
              "Chat",
              "Pay"
            ]),
        ],
      ),
    );
  }

  /// INFO ROW
  Widget infoRow(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey,
        ),

        const SizedBox(width: 6),

        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// BUTTON ROW
  Widget buttonRow(
      List<String> buttons) {
    return Row(
      children:
          buttons.map((title) {
        return Expanded(
          child: Container(
            margin:
                const EdgeInsets.only(
              right: 8,
            ),
            child: OutlinedButton(
              style:
                  OutlinedButton
                      .styleFrom(
                side: BorderSide(
                  color:
                      Colors.teal
                          .shade300,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(20),
                ),
              ),
              onPressed: () {},
              child: Text(
                title,
                style: TextStyle(
                  color:
                      Colors.teal
                          .shade300,
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// WISHLIST
  Widget _buildWishlistCard(
      Map trip) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: buildImage(
              trip["image"],
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(
                    16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      trip["city"] ??
                          "Trip",
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(
                        height: 8),

                    infoRow(
                      Icons
                          .calendar_today,
                      trip["date"] ?? "",
                    ),
                  ],
                ),

                const Icon(
                  Icons.favorite,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}