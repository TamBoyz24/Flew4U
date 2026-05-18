import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../../services/api_service.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() =>
      _CreateTripScreenState();
}

class _CreateTripScreenState
    extends State<CreateTripScreen> {

  final cityCtrl =
      TextEditingController(
    text: "Danang, Vietnam",
  );

  final dateCtrl =
      TextEditingController();

  final feeCtrl =
      TextEditingController();

  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  int travelers = 1;

  XFile? selectedImage;

  Uint8List? webImageBytes;

  final ImagePicker picker =
      ImagePicker();

  bool isLoading = false;

  List<String> selectedLanguages = [
    "Korean",
    "English"
  ];

  List<Map<String, dynamic>>
      attractions = [
    {
      "name": "Dragon Bridge",
      "image":
          "assets/images/cau_rong.jpg",
      "selected": true,
    },
    {
      "name": "Cham Museum",
      "image":
          "assets/images/danangbanahoian.jpg",
      "selected": false,
    },
    {
      "name": "My Khe Beach",
      "image":
          "assets/images/HaLongBay.jpg",
      "selected": true,
    },
  ];

  /// IMAGE
  Future<void> pickImage() async {

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,

      /// GIẢM DUNG LƯỢNG ẢNH
      imageQuality: 40,
      maxWidth: 800,
    );

    if (image != null) {

      if (kIsWeb) {

        final bytes =
            await image.readAsBytes();

        setState(() {

          selectedImage = image;
          webImageBytes = bytes;
        });

      } else {

        setState(() {
          selectedImage = image;
        });
      }
    }
  }

  /// DATE
  void pickDate() async {

    DateTime? picked =
        await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {

      dateCtrl.text =
          "${picked.month}/${picked.day}/${picked.year}";
    }
  }

  /// TIME
  Future<void> pickTime(
      bool isFrom) async {

    TimeOfDay? picked =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {

      setState(() {

        if (isFrom) {
          fromTime = picked;
        } else {
          toTime = picked;
        }
      });
    }
  }

  /// SAVE TRIP
  Future<void> saveTrip() async {

    if (cityCtrl.text.trim().isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Please enter city"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final prefs =
          await SharedPreferences
              .getInstance();

      String imagePath = "";

      /// SAVE IMAGE
      if (selectedImage != null) {

        /// WEB
        if (kIsWeb) {

          if (webImageBytes != null) {

            imagePath =
                "data:image/png;base64,"
                "${base64Encode(webImageBytes!)}";
          }

        } else {

          final dir =
              await getApplicationDocumentsDirectory();

          final newPath =
              "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png";

          final newImage =
              await File(
            selectedImage!.path,
          ).copy(newPath);

          imagePath =
              newImage.path;
        }
      }

      /// TRIP DATA
      final tripData = {
        "city":
            cityCtrl.text.trim(),

        "date":
            dateCtrl.text.trim(),

        "from":
            fromTime
                    ?.format(context) ??
                "",

        "to":
            toTime
                    ?.format(context) ??
                "",

        "travelers":
            travelers,

        "fee":
            feeCtrl.text.trim(),

        "languages":
            selectedLanguages,

        "attractions":
            attractions
                .where(
                  (e) =>
                      e["selected"] ==
                      true,
                )
                .map(
                  (e) =>
                      e["name"],
                )
                .toList(),

        /// IMPORTANT
        "image": imagePath,

        "status": "Current",

        "userName":
            prefs.getString("name") ??
                "Traveler",

        "avatar":
            prefs.getString(
                  "avatar",
                ) ??
                "",
      };

      /// CREATE TRIP
      await ApiService.addTrip(
        tripData,
      );

      /// NOTIFICATION
      try {

        await ApiService
            .addNotification({
          "title":
              "New Trip Created",

          "subtitle":
              "You have planned a new trip to ${cityCtrl.text.trim()}",

          "type": "trip",

          "read": false,

          "date": DateTime.now()
              .toIso8601String()
        });

      } catch (e) {

        debugPrint(
          "Failed notification: $e",
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Trip created successfully"),
        ),
      );

      Navigator.pop(context, true);

    } catch (e) {

      debugPrint(
        "SAVE TRIP ERROR: $e",
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text("Error: $e"),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          Colors.grey[100],

      appBar: AppBar(
        title:
            const Text(
          "Create New Trip",
        ),

        centerTitle: true,

        backgroundColor:
            Colors.white,

        foregroundColor:
            Colors.black,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            /// CITY
            inputTile(
              "Where you want to explore",

              TextField(
                controller: cityCtrl,

                decoration:
                    const InputDecoration(
                  border:
                      InputBorder.none,

                  prefixIcon: Icon(
                    Icons.location_on,
                  ),
                ),
              ),
            ),

            /// DATE
            inputTile(
              "Date",

              TextField(
                controller: dateCtrl,

                readOnly: true,

                onTap: pickDate,

                decoration:
                    const InputDecoration(
                  border:
                      InputBorder.none,

                  prefixIcon: Icon(
                    Icons.calendar_today,
                  ),

                  hintText: "mm/dd/yy",
                ),
              ),
            ),

            /// TIME
            inputTile(
              "Time",

              Row(
                children: [

                  Expanded(
                    child: timeBox(
                      fromTime?.format(
                              context) ??
                          "From",

                      () =>
                          pickTime(
                              true),
                    ),
                  ),

                  const SizedBox(
                      width: 10),

                  Expanded(
                    child: timeBox(
                      toTime?.format(
                              context) ??
                          "To",

                      () =>
                          pickTime(
                              false),
                    ),
                  ),
                ],
              ),
            ),

            /// TRAVELERS
            inputTile(
              "Number of travelers",

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [

                  IconButton(
                    onPressed: () {

                      if (travelers > 1) {

                        setState(() {
                          travelers--;
                        });
                      }
                    },

                    icon: const Icon(
                      Icons.remove,
                    ),
                  ),

                  Text("$travelers"),

                  IconButton(
                    onPressed: () {

                      setState(() {
                        travelers++;
                      });
                    },

                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
            ),

            /// FEE
            inputTile(
              "Fee",

              TextField(
                controller: feeCtrl,

                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                  border:
                      InputBorder.none,

                  prefixText: "\$ ",

                  hintText:
                      "(/hour)",
                ),
              ),
            ),

            const SizedBox(
                height: 15),

            /// IMAGE PICKER
            GestureDetector(
              onTap: pickImage,

              child: Container(
                height: 180,
                width: double.infinity,

                decoration:
                    BoxDecoration(
                  borderRadius:
                      BorderRadius
                          .circular(
                              15),

                  color:
                      Colors.white,
                ),

                child:
                    selectedImage ==
                            null

                        ? const Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              Icon(
                                Icons
                                    .add_a_photo,
                                size: 50,
                              ),

                              SizedBox(
                                  height:
                                      10),

                              Text(
                                "Choose trip image",
                              ),
                            ],
                          )

                        : ClipRRect(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        15),

                            child: kIsWeb

                                ? Image.memory(
                                    webImageBytes!,
                                    fit: BoxFit.cover,
                                    width:
                                        double.infinity,
                                  )

                                : Image.file(
                                    File(
                                      selectedImage!
                                          .path,
                                    ),

                                    fit: BoxFit.cover,

                                    width:
                                        double.infinity,
                                  ),
                          ),
              ),
            ),

            const SizedBox(
                height: 30),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,

              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : saveTrip,

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.green,
                ),

                child:
                    isLoading

                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )

                        : const Text(
                            "DONE",
                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputTile(
    String title,
    Widget child,
  ) {

    return Container(
      margin:
          const EdgeInsets.only(
              bottom: 15),

      padding:
          const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
                12),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(
              height: 5),

          child,
        ],
      ),
    );
  }

  Widget timeBox(
    String text,
    VoidCallback onTap,
  ) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding:
            const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.grey[200],

          borderRadius:
              BorderRadius.circular(
                  10),
        ),

        child: Text(text),
      ),
    );
  }
}