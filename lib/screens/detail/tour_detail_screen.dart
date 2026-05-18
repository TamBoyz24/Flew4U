import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ======================================
/// API SERVICE
/// ======================================
class ApiService {
  static const String baseUrl =
      "http://127.0.0.1:3000";

  /// BOOK TOUR
  static Future bookTour({
    required String customerName,
    required String phone,
    required String email,
    required String travelers,
    required String paymentMethod,
    required String tourTitle,
    required String totalPrice,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/bookings"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "customerName": customerName,
        "phone": phone,
        "email": email,
        "travelers": travelers,
        "paymentMethod": paymentMethod,
        "tourTitle": tourTitle,
        "totalPrice": totalPrice,
        "bookingDate": DateTime.now().toString(),
        "status": "Pending",
      }),
    );

    print(response.body);

    if (response.statusCode != 201) {
      throw Exception("Booking Failed");
    }
  }
}

/// ======================================
/// TOUR DETAIL SCREEN
/// ======================================
class TourDetailScreen extends StatelessWidget {
  final String title;

  const TourDetailScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Stack(
        children: [

          /// IMAGE
          Image.network(
            "https://picsum.photos/600/400",
            width: double.infinity,
            height: 350,
            fit: BoxFit.cover,
          ),

          /// DARK OVERLAY
          Container(
            height: 350,
            color: Colors.black.withOpacity(0.2),
          ),

          /// BACK
          Positioned(
            top: 45,
            left: 15,
            child: CircleAvatar(
              backgroundColor:
                  Colors.black.withOpacity(0.4),

              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),

                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          /// FAVORITE
          Positioned(
            top: 45,
            right: 15,
            child: CircleAvatar(
              backgroundColor:
                  Colors.black.withOpacity(0.4),

              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          ),

          /// CONTENT
          Positioned.fill(
            top: 300,

            child: Container(
              padding: const EdgeInsets.all(22),

              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(35),
                ),
              ),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// TITLE
                    Text(
                      title,

                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// LOCATION + RATING
                    Row(
                      children: [

                        const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 18,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          "Da Nang, Vietnam",

                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 18,
                        ),

                        const SizedBox(width: 3),

                        const Text(
                          "4.9",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// SUMMARY
                    const Text(
                      "Summary",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Experience the best of Da Nang and Hoi An with beautiful beaches, delicious food, luxury hotels and exciting activities.",

                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// TOUR INFO
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        infoCard(
                          Icons.schedule,
                          "Duration",
                          "3 Days",
                        ),

                        infoCard(
                          Icons.people,
                          "Group",
                          "10 People",
                        ),

                        infoCard(
                          Icons.language,
                          "Guide",
                          "English",
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// PRICE BOX
                    Container(
                      padding:
                          const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.green
                            .withOpacity(0.08),

                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: Row(
                        children: [

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                "Total Price",

                                style: TextStyle(
                                  color:
                                      Colors.grey[600],
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                "\$400.00",

                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.green,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          ElevatedButton(
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  Colors.green,

                              foregroundColor:
                                  Colors.white,

                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(15),
                              ),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      BookingScreen(
                                    title: title,
                                  ),
                                ),
                              );
                            },

                            child: const Text(
                              "BOOK NOW",
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.grey[100],

        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: Colors.green,
          ),

          const SizedBox(height: 8),

          Text(
            title,

            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// ======================================
/// BOOKING SCREEN
/// ======================================
class BookingScreen extends StatefulWidget {
  final String title;

  const BookingScreen({
    super.key,
    required this.title,
  });

  @override
  State<BookingScreen> createState() =>
      _BookingScreenState();
}

class _BookingScreenState
    extends State<BookingScreen> {

  final nameCtrl =
      TextEditingController();

  final phoneCtrl =
      TextEditingController();

  final emailCtrl =
      TextEditingController();

  final travelersCtrl =
      TextEditingController(text: "1");

  String payment = "Credit Card";

  bool loading = false;

  Future<void> handleBooking() async {

    if (nameCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Please fill all fields"),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await ApiService.bookTour(
        customerName: nameCtrl.text,
        phone: phoneCtrl.text,
        email: emailCtrl.text,
        travelers: travelersCtrl.text,
        paymentMethod: payment,
        tourTitle: widget.title,
        totalPrice: "400",
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const BookingSuccessScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text("Booking Failed"),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  InputDecoration inputStyle(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Tour"),

        backgroundColor: Colors.green,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: nameCtrl,
              decoration:
                  inputStyle("Full Name"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneCtrl,
              decoration:
                  inputStyle("Phone Number"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailCtrl,
              decoration:
                  inputStyle("Email"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: travelersCtrl,

              keyboardType:
                  TextInputType.number,

              decoration:
                  inputStyle("Travelers"),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),

                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Payment Method",

                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  RadioListTile(
                    value: "Credit Card",

                    groupValue: payment,

                    activeColor: Colors.green,

                    title:
                        const Text("Credit Card"),

                    onChanged: (value) {
                      setState(() {
                        payment = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    value: "Momo",

                    groupValue: payment,

                    activeColor: Colors.green,

                    title: const Text("Momo"),

                    onChanged: (value) {
                      setState(() {
                        payment = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    value: "Cash",

                    groupValue: payment,

                    activeColor: Colors.green,

                    title: const Text("Cash"),

                    onChanged: (value) {
                      setState(() {
                        payment = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,

                  foregroundColor:
                      Colors.white,
                ),

                onPressed:
                    loading ? null : handleBooking,

                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "CONFIRM BOOKING",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ======================================
/// SUCCESS SCREEN
/// ======================================
class BookingSuccessScreen
    extends StatelessWidget {

  const BookingSuccessScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 120,
              ),

              const SizedBox(height: 25),

              const Text(
                "Booking Successful!",

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Your tour has been booked successfully.",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green,

                    foregroundColor:
                        Colors.white,

                    padding:
                        const EdgeInsets.all(16),
                  ),

                  onPressed: () {

                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },

                  child: const Text(
                    "BACK TO HOME",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}