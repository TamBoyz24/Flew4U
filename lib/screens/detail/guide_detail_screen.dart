import 'package:flutter/material.dart';
import '../auth/payment_screen.dart';

class GuideDetailScreen extends StatelessWidget {
  final String name;
  final String image;
  final String location;
  final String bio;
  final int reviews;
  final double rating;
  final double pricePerHour;

  const GuideDetailScreen({
    super.key,
    required this.name,
    required this.image,
    this.location = "Da Nang, Vietnam",
    this.bio = "Experienced local guide with deep knowledge of historical sites, culture and cuisine. I love sharing the hidden gems of Vietnam with travelers from around the world.",
    this.reviews = 128,
    this.rating = 4.9,
    this.pricePerHour = 10.0,
  });

  void _showBookingSheet(BuildContext context) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    int selectedHours = 4;
    int travelers = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final double totalFee = selectedHours * pricePerHour;
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    "Book Guide: $name",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  
                  // Date selection
                  const Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.teal,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setSheetState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                          const Icon(Icons.calendar_today, color: Colors.teal, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Hours selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Duration (Hours)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                            onPressed: selectedHours > 1 ? () => setSheetState(() => selectedHours--) : null,
                          ),
                          Text("$selectedHours", style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                            onPressed: selectedHours < 12 ? () => setSheetState(() => selectedHours++) : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Travelers selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Travelers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                            onPressed: travelers > 1 ? () => setSheetState(() => travelers--) : null,
                          ),
                          Text("$travelers", style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                            onPressed: travelers < 10 ? () => setSheetState(() => travelers++) : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("\$${totalFee.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.teal)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close sheet
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(
                              trip: {
                                "city": "Guide Booking: $name",
                                "date": "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                "from": "08:00 AM",
                                "to": "${8 + selectedHours > 12 ? 8 + selectedHours - 12 : 8 + selectedHours}:00 ${8 + selectedHours >= 12 ? 'PM' : 'AM'}",
                                "travelers": travelers,
                                "fee": "$totalFee",
                                "languages": ["English", "Vietnamese"],
                                "attractions": ["Da Nang City Tour"],
                                "image": image,
                                "status": "Next",
                                "userName": "Traveler",
                                "avatar": ""
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Confirm & Proceed to Payment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Header Image
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, st) => Container(color: Colors.teal.shade200),
            ),
          ),

          // Gradient overlay
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // Name & location on image
          Positioned(
            top: 240,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.tealAccent, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.62,
            minChildSize: 0.62,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statItem(Icons.star, rating.toString(), "Rating"),
                          _statItem(Icons.rate_review_outlined, "$reviews", "Reviews"),
                          _statItem(Icons.explore_outlined, "50+", "Tours"),
                          _statItem(Icons.language, "3", "Languages"),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),

                      const Text(
                        "About",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bio,
                        style: const TextStyle(color: Colors.grey, height: 1.6, fontSize: 13),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "Specialties",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _tag("City Tours"),
                          _tag("Food & Culture"),
                          _tag("Photography"),
                          _tag("Historical Sites"),
                          _tag("Biking"),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.chat_bubble_outline, size: 16),
                              label: const Text("Chat"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.teal,
                                side: const BorderSide(color: Colors.teal),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showBookingSheet(context),
                              icon: const Icon(Icons.bookmark_add_outlined, size: 16, color: Colors.white),
                              label: const Text("Book Guide", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Text(label, style: TextStyle(color: Colors.teal.shade700, fontSize: 12)),
    );
  }
}
