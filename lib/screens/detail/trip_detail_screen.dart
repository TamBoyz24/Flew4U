import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../auth/payment_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final Map trip;
  final VoidCallback onDelete;

  const TripDetailScreen({
    super.key,
    required this.trip,
    required this.onDelete,
  });

  /// ================= IMAGE =================
  Widget buildImage(String? image) {
    if (image == null || image.isEmpty) {
      return Image.asset(
        "assets/images/cau_rong.jpg",
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    /// WEB BASE64
    if (kIsWeb &&
        image.startsWith("data:image")) {
      try {
        final bytes = base64Decode(
          image.split(",").last,
        );

        return Image.memory(
          bytes,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Image.asset(
              "assets/images/cau_rong.jpg",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          },
        );
      } catch (e) {
        return Image.asset(
          "assets/images/cau_rong.jpg",
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    }

    /// NETWORK
    if (image.startsWith("http")) {
      return Image.network(
        image,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Image.asset(
            "assets/images/cau_rong.jpg",
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    }

    /// ASSET
    if (image.startsWith("assets/")) {
      return Image.asset(
        image,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    /// MOBILE FILE
    if (!kIsWeb) {
      try {
        if (File(image).existsSync()) {
          return Image.file(
            File(image),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Image.asset(
                "assets/images/cau_rong.jpg",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          );
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return Image.asset(
      "assets/images/cau_rong.jpg",
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  /// ================= AVATAR =================
  Widget avatarWidget() {
    final String avatar =
        trip["avatar"] ?? "";

    if (avatar.isNotEmpty) {
      /// WEB
      if (kIsWeb &&
          avatar.startsWith(
              "data:image")) {
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
          if (File(avatar)
              .existsSync()) {
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
      backgroundColor:
          Colors.teal,
      child: Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isNext =
        trip["status"] == "Next" ||
            trip["status"] ==
                "Wishlist";

    return Scaffold(
      backgroundColor: Colors.white,

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
              Navigator.pop(context),
        ),

        title: const Text(
          "Trip Detail",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                      15),
            ),

            onSelected: (value) {
              if (value == 'edit') {
                Navigator.pushNamed(
                  context,
                  '/tripEdit',
                  arguments: trip,
                );
              } else if (value ==
                  'delete') {
                showDelete(context);
              }
            },

            itemBuilder:
                (BuildContext context) =>
                    <PopupMenuEntry<
                        String>>[
              PopupMenuItem<String>(
                value: 'edit',

                child: Row(
                  children: const [
                    Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 18,
                    ),

                    SizedBox(width: 8),

                    Text(
                        'Edit This Trip'),
                  ],
                ),
              ),

              PopupMenuItem<String>(
                value: 'delete',

                child: Row(
                  children: const [
                    Icon(
                      Icons
                          .delete_outline,
                      color: Colors.grey,
                      size: 18,
                    ),

                    SizedBox(width: 8),

                    Text(
                        'Delete This Trip'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 16.0,
              ),

              child: Stack(
                clipBehavior: Clip.none,

                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius
                            .circular(
                                15),

                    child: buildImage(
                      trip["image"],
                    ),
                  ),

                  Positioned(
                    bottom: 16,
                    left: 16,

                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color:
                              Colors.white,
                          size: 16,
                        ),

                        const SizedBox(
                            width: 4),

                        Text(
                          trip["city"] ??
                              "Unknown",

                          style:
                              const TextStyle(
                            color: Colors
                                .white,
                            fontSize: 13,
                            fontWeight:
                                FontWeight
                                    .normal,
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
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 16.0,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  _buildRowInfo(
                    "Date",
                    trip["date"] ?? "",
                  ),

                  const SizedBox(
                      height: 15),

                  _buildRowInfo(
                    "Time",
                    "${trip["from"] ?? ""} - ${trip["to"] ?? ""}",
                  ),

                  const SizedBox(
                      height: 15),

                  _buildRowGuide(
                    "Guide",
                    trip["userName"] ??
                        "Traveler",
                  ),

                  const SizedBox(
                      height: 15),

                  _buildRowInfo(
                    "Number of Travelers",
                    "${trip["travelers"] ?? 1}",
                  ),

                  const SizedBox(
                      height: 20),

                  const Text(
                    "Attractions",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 10,

                    children: (trip[
                                    "attractions"]
                                as List? ??
                            [])
                        .map<Widget>((e) {
                      return Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration:
                            BoxDecoration(
                          border: Border.all(
                            color: Colors
                                .cyan
                                .shade300,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      20),
                        ),

                        child: Row(
                          mainAxisSize:
                              MainAxisSize
                                  .min,

                          children: [
                            const Icon(
                              Icons
                                  .location_on,
                              color:
                                  Colors
                                      .teal,
                              size: 12,
                            ),

                            const SizedBox(
                                width: 4),

                            Text(
                              e.toString(),

                              style:
                                  const TextStyle(
                                color: Colors
                                    .teal,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(
                      height: 25),

                  const Divider(),

                  const SizedBox(
                      height: 15),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [
                      const Text(
                        "Fee",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      Text(
                        "\$${trip["fee"] ?? "0.00"}",

                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              Colors.teal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 30),

                  if (isNext)
                    _buildOffersList(
                        context),

                  if (!isNext)
                    SizedBox(
                      width:
                          double.infinity,

                      child:
                          OutlinedButton.icon(
                        style:
                            OutlinedButton
                                .styleFrom(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 14,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        10),
                          ),
                        ),

                        onPressed: () {
                          Navigator.pop(
                              context);
                        },

                        icon: const Icon(
                          Icons.check,
                          color:
                              Colors.black,
                          size: 20,
                        ),

                        label: const Text(
                          "Mark Finished",

                          style:
                              TextStyle(
                            color: Colors
                                .black,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(
                      height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInfo(
    String key,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

      children: [
        Text(
          key,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),

        Text(
          value,

          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildRowGuide(
    String key,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

      children: [
        Text(
          key,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),

        Text(
          value,

          style: const TextStyle(
            fontSize: 13,
            fontWeight:
                FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildOffersList(
      BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const Text(
          "Offers",

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 15),

        _buildOfferItem(
          context,
          "Khai Ho",
          123,
          "Lorem ipsum is simply dummy text of the printing and typesetting industry.",
          10,
          true,
        ),
      ],
    );
  }

  Widget _buildOfferItem(
    BuildContext context,
    String name,
    int reviews,
    String desc,
    int price,
    bool isChosen,
  ) {
    return Container();
  }

  void showDelete(
      BuildContext context) {
    showDialog(
      context: context,

      builder: (context) =>
          AlertDialog(
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
                  15),
        ),

        title: const Center(
          child: Text(
            "Delete This Trip",

            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        content: const Text(
          "Are you sure you want to delete this trip?",
          textAlign: TextAlign.center,
        ),

        actionsAlignment:
            MainAxisAlignment
                .spaceEvenly,

        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
                    context),

            child: Text(
              "Cancel",

              style: TextStyle(
                color: Colors
                    .tealAccent
                    .shade400,
                fontWeight:
                    FontWeight
                        .bold,
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              onDelete();

              Navigator.pop(
                  context);

              Navigator.pop(
                context,
                true,
              );
            },

            child: Text(
              "Delete",

              style: TextStyle(
                color: Colors
                    .tealAccent
                    .shade400,
                fontWeight:
                    FontWeight
                        .bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}