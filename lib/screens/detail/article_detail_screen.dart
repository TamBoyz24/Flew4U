import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/payment_screen.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String title;
  final String image;
  final String description;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  State<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState
    extends State<ArticleDetailScreen> {
  int selectedDay = 1;

  /// IMAGE
  Widget appImage(String path) {
    return Image.asset(
      path,
      width: double.infinity,
      height: 280,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          height: 280,
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
            ),
          ),
        );
      },
    );
  }

  /// SHARE POPUP
  void showSharePopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Share on",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [
                  shareButton(
                    Icons.facebook,
                    "Facebook",
                    Colors.blue,
                  ),

                  shareButton(
                    Icons.g_mobiledata,
                    "Google",
                    Colors.red,
                  ),

                  shareButton(
                    Icons.chat,
                    "Kakao",
                    Colors.orange,
                  ),

                  /// FIXED
                  shareButton(
                    Icons.message,
                    "Whatsapp",
                    Colors.green,
                  ),

                  shareButton(
                    Icons.telegram,
                    "Twitter",
                    Colors.lightBlue,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.grey.shade200,
                    elevation: 0,
                  ),
                  child: const Text(
                    "Cancel",
                    style:
                        TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// SHARE BUTTON
  Widget shareButton(
    IconData icon,
    String text,
    Color color,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          text,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  /// INFO ITEM
  Widget infoItem(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// SCHEDULE ITEM
  Widget scheduleItem(
    String time,
    String text,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              ),

              Expanded(
                child: Container(
                  width: 2,
                  color: Colors.teal.shade100,
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 25),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PRICE ROW
  Widget priceRow(
    String title,
    String price,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title)),

          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// IMAGE
              Stack(
                children: [
                  appImage(widget.image),

                  /// BACK
                  Positioned(
                    top: 15,
                    left: 15,
                    child: CircleAvatar(
                      backgroundColor:
                          Colors.black45,
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

                  /// SHARE
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Colors.black45,
                          child: IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed:
                                showSharePopup,
                          ),
                        ),

                        const SizedBox(width: 10),

                        const CircleAvatar(
                          backgroundColor:
                              Colors.black45,
                          child: Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// CONTENT
              Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    /// TITLE + PRICE
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style:
                                const TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .end,
                          children: [
                            const Text(
                              "\$400.00",
                              style: TextStyle(
                                color:
                                    Colors.teal,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            Text(
                              "\$460.00",
                              style: TextStyle(
                                decoration:
                                    TextDecoration
                                        .lineThrough,
                                color: Colors
                                    .grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// RATING
                    Row(
                      children: [
                        Row(
                          children:
                              List.generate(
                            5,
                            (_) => const Icon(
                              Icons.star,
                              color:
                                  Colors.orange,
                              size: 16,
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Text(
                          "145 Reviews",
                          style: TextStyle(
                            color:
                                Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// PROVIDER
                    Row(
                      children: [
                        Text(
                          "Provider",
                          style: TextStyle(
                            color:
                                Colors.grey[600],
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          "dulichviet",
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// SUMMARY
                    Container(
                      padding:
                          const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                        border: Border.all(
                          color: Colors
                              .grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            "Summary",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(
                              height: 15),

                          infoItem(
                            "Itinerary",
                            "Da Nang - Ba Na - Hoi An",
                          ),

                          infoItem(
                            "Duration",
                            "2 days, 2 nights",
                          ),

                          infoItem(
                            "Departure Date",
                            "Feb 12",
                          ),

                          infoItem(
                            "Departure Place",
                            "Ho Chi Minh",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// SCHEDULE
                    const Row(
                      children: [
                        Icon(Icons.menu_book),

                        SizedBox(width: 8),

                        Text(
                          "Schedule",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// DAYS
                    Row(
                      children: [
                        dayButton(1),

                        const SizedBox(width: 10),

                        dayButton(2),
                      ],
                    ),

                    const SizedBox(height: 25),

                    scheduleItem(
                      "6:00AM",
                      widget.description,
                    ),

                    scheduleItem(
                      "10:00AM",
                      widget.description,
                    ),

                    scheduleItem(
                      "1:00PM",
                      widget.description,
                    ),

                    scheduleItem(
                      "8:00PM",
                      widget.description,
                    ),

                    const SizedBox(height: 20),

                    /// PRICE
                    const Row(
                      children: [
                        Icon(Icons.attach_money),

                        SizedBox(width: 8),

                        Text(
                          "Price",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                        border: Border.all(
                          color: Colors
                              .grey.shade300,
                        ),
                      ),
                      child: Column(
                        children: [
                          priceRow(
                            "Adult (>10 years old)",
                            "\$400.00",
                          ),

                          priceRow(
                            "Child (5 - 10 years old)",
                            "\$320.00",
                          ),

                          priceRow(
                            "Child (<5 years old)",
                            "Free",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> tripToPay = {
                            "city": widget.title,
                            "image": widget.image,
                            "fee": 400,
                            "date": DateTime.now().toIso8601String().substring(0, 10),
                            "travelers": 1,
                            "from": "08:00 AM",
                            "to": "12:00 PM",
                            "attractions": [widget.title]
                          };
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(trip: tripToPay),
                            ),
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.teal,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 18,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(14),
                          ),
                        ),

                        child: const Text(
                          "BOOK THIS TOUR",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// DAY BUTTON
  Widget dayButton(int day) {
    bool active = selectedDay == day;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = day;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: active
              ? Colors.teal
              : Colors.grey[200],

          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Text(
          "Day $day",
          style: TextStyle(
            color: active
                ? Colors.white
                : Colors.black,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}