import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTripScreen extends StatefulWidget {
  const EditTripScreen({super.key});

  @override
  State<EditTripScreen> createState() =>
      _EditTripScreenState();
}

class _EditTripScreenState
    extends State<EditTripScreen> {

  late Map trip;

  final cityCtrl =
      TextEditingController();

  final dateCtrl =
      TextEditingController();

  final feeCtrl =
      TextEditingController();

  final descCtrl =
      TextEditingController();

  int travelers = 1;

  String status = "Current";

  XFile? selectedImage;

  final ImagePicker picker =
      ImagePicker();

  List<String> languages = [
    "English",
    "Vietnamese",
    "Korean",
  ];

  List<String> selectedLanguages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    trip =
        ModalRoute.of(context)!
            .settings
            .arguments as Map;

    cityCtrl.text =
        trip["city"] ?? "";

    dateCtrl.text =
        trip["date"] ?? "";

    feeCtrl.text =
        trip["fee"] ?? "";

    descCtrl.text =
        trip["description"] ?? "";

    travelers =
        trip["travelers"] ?? 1;

    status =
        trip["status"] ?? "Current";

    selectedLanguages =
        List<String>.from(
      trip["languages"] ?? [],
    );
  }

  /// PICK IMAGE
  Future<void> pickImage() async {

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      setState(() {
        selectedImage = image;
      });
    }
  }

  /// SAVE
  Future<void> saveEdit() async {

    final prefs =
        await SharedPreferences.getInstance();

    List trips = jsonDecode(
      prefs.getString('trips') ?? "[]",
    );

    int index = trips.indexWhere(
      (e) =>
          e["city"] == trip["city"] &&
          e["date"] == trip["date"],
    );

    if (index != -1) {

      String imagePath =
          trip["image"] ?? "";

      if (selectedImage != null) {
        imagePath =
            selectedImage!.path;
      }

      trips[index] = {

        ...trips[index],

        "city":
            cityCtrl.text,

        "date":
            dateCtrl.text,

        "fee":
            feeCtrl.text,

        "description":
            descCtrl.text,

        "travelers":
            travelers,

        "status":
            status,

        "languages":
            selectedLanguages,

        "image":
            imagePath,
      };
    }

    await prefs.setString(
      'trips',
      jsonEncode(trips),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Trip Updated",
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  /// DELETE
  Future<void> deleteTrip() async {

    final prefs =
        await SharedPreferences.getInstance();

    List trips = jsonDecode(
      prefs.getString('trips') ?? "[]",
    );

    trips.removeWhere(
      (e) =>
          e["city"] == trip["city"] &&
          e["date"] == trip["date"],
    );

    await prefs.setString(
      'trips',
      jsonEncode(trips),
    );

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  /// IMAGE
  Widget imageWidget() {

    /// NEW IMAGE
    if (selectedImage != null) {

      if (kIsWeb) {

        return Image.asset(
          selectedImage!.path,
          fit: BoxFit.cover,
        );
      }

      return Image.file(
        File(selectedImage!.path),
        fit: BoxFit.cover,
      );
    }

    /// OLD IMAGE
    if (trip["image"] != null &&
        trip["image"] != "") {

      String path =
          trip["image"];

      if (kIsWeb) {

        return Image.asset(
          path,
          fit: BoxFit.cover,
        );
      }

      return Image.file(
        File(path),
        fit: BoxFit.cover,
      );
    }

    return const Center(
      child: Icon(
        Icons.image,
        size: 50,
      ),
    );
  }

  Widget inputField({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          title,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          maxLines: maxLines,

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                      12),
            ),
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title:
            const Text("Edit Trip"),

        backgroundColor:
            Colors.teal,

        foregroundColor:
            Colors.white,

        actions: [

          IconButton(
            onPressed: deleteTrip,

            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// IMAGE
            GestureDetector(
              onTap: pickImage,

              child: Container(
                height: 220,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),

                clipBehavior:
                    Clip.antiAlias,

                child: imageWidget(),
              ),
            ),

            const SizedBox(height: 20),

            /// CITY
            inputField(
              title: "City",
              controller: cityCtrl,
            ),

            /// DATE
            inputField(
              title: "Date",
              controller: dateCtrl,
            ),

            /// FEE
            inputField(
              title: "Fee",
              controller: feeCtrl,
            ),

            /// DESCRIPTION
            inputField(
              title: "Description",
              controller: descCtrl,
              maxLines: 4,
            ),

            /// TRAVELERS
            const Text(
              "Travelers",

              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                IconButton(
                  onPressed: () {

                    if (travelers > 1) {

                      setState(() {
                        travelers--;
                      });
                    }
                  },

                  icon:
                      const Icon(Icons.remove),
                ),

                Text(
                  "$travelers",

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: () {

                    setState(() {
                      travelers++;
                    });
                  },

                  icon:
                      const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// STATUS
            const Text(
              "Trip Status",

              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: status,

              items: [
                "Current",
                "Completed",
                "Cancelled",
              ]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),

              onChanged: (value) {

                setState(() {
                  status = value!;
                });
              },

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LANGUAGE
            const Text(
              "Languages",

              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,

              children: languages.map((lang) {

                return FilterChip(

                  label: Text(lang),

                  selected:
                      selectedLanguages
                          .contains(lang),

                  onSelected: (value) {

                    setState(() {

                      if (value) {

                        selectedLanguages
                            .add(lang);
                      } else {

                        selectedLanguages
                            .remove(lang);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: saveEdit,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.teal,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            15),
                  ),
                ),

                child: const Text(
                  "SAVE CHANGES",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
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