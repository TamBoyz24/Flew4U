import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';

class PaymentScreen extends StatefulWidget {
  final Map trip;

  const PaymentScreen({super.key, required this.trip});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int step = 0; // 0 for Card Info, 1 for Preview Check Out
  
  Widget buildImage(String? image) {
    if (image == null || image.isEmpty) {
      return Image.asset("assets/images/anhdaidien.png", fit: BoxFit.cover);
    }
    if (kIsWeb || image.startsWith("http")) {
      return Image.asset("assets/images/anhdaidien.png", fit: BoxFit.cover, errorBuilder: (_, _, _) => Image.asset("assets/images/anhdaidien.png", fit: BoxFit.cover));
    }
    return Image.file(File(image), fit: BoxFit.cover);
  }

  void _finishCheckout() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('trips');
    if (data != null) {
      List trips = jsonDecode(data);
      for (int i = 0; i < trips.length; i++) {
        if (trips[i]["city"] == widget.trip["city"] && trips[i]["date"] == widget.trip["date"]) {
          trips[i]["status"] = "Current"; 
          break;
        }
      }
      await prefs.setString('trips', jsonEncode(trips));
    }

    try {
      await ApiService.addPayment({
        "tourTitle": widget.trip["city"],
        "fee": widget.trip["fee"],
        "date": DateTime.now().toIso8601String(),
        "status": "Paid"
      });
      await ApiService.addBooking({
        "tourTitle": widget.trip["city"],
        "tourImage": widget.trip["image"],
        "date": DateTime.now().toIso8601String(),
        "status": "Booked"
      });
      
      // Default info for the new trip if it's missing in widget.trip
      Map<String, dynamic> newTripData = {
        "city": widget.trip["city"] ?? widget.trip["tourTitle"],
        "date": DateTime.now().toIso8601String(),
        "from": widget.trip["from"] ?? "08:00 AM",
        "to": widget.trip["to"] ?? "10:00 PM",
        "travelers": widget.trip["travelers"] ?? 1,
        "fee": widget.trip["fee"]?.toString() ?? "0",
        "languages": widget.trip["languages"] ?? ["English"],
        "attractions": widget.trip["attractions"] ?? [],
        "image": widget.trip["image"] ?? widget.trip["tourImage"],
        "status": "Next", 
        "userName": "Traveler",
        "avatar": ""
      };
      
      await ApiService.addTrip(newTripData);

      await ApiService.addNotification({
        "title": "Booking Confirmed",
        "subtitle": "Your trip to ${widget.trip["city"]} is confirmed",
        "type": "booking",
        "read": false,
        "date": DateTime.now().toIso8601String(),
        "tripData": newTripData
      });
    } catch (e) {
      print("Error adding payment/booking/trip/notification: $e");
    }
    
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text("Thanks! Check out successfully.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 10),
              const Text("Enjoy your trip!", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back twice and pass true so My Trips can refresh
                    Navigator.pop(context); 
                    Navigator.pop(context, true); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Go to My Trips", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            if (step == 1) {
              setState(() => step = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text("Payment", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(radius: 5, backgroundColor: step >= 0 ? Colors.teal : Colors.grey.shade300),
                    const SizedBox(height: 5),
                    Text("Payment Method", style: TextStyle(fontSize: 10, color: step >= 0 ? Colors.teal : Colors.grey.shade500)),
                  ],
                ),
                Container(
                  width: 50,
                  height: 1,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                ),
                Column(
                  children: [
                    CircleAvatar(radius: 5, backgroundColor: step >= 1 ? Colors.teal : Colors.grey.shade300),
                    const SizedBox(height: 5),
                    Text("Preview & Check out", style: TextStyle(fontSize: 10, color: step >= 1 ? Colors.teal : Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: step == 0 ? _buildCardInfo() : _buildPreview(),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade400,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (step == 0) {
                setState(() => step = 1);
              } else {
                _finishCheckout();
              }
            },
            child: Text(
              step == 0 ? "NEXT" : "CHECK OUT",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.credit_card, color: Colors.black54),
            SizedBox(width: 10),
            Text("Card Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 30),
        
        Text("Card Holder's Name", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        const TextField(
          decoration: InputDecoration(
            hintText: "Card Holder's Name",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          ),
        ),
        const SizedBox(height: 25),
        
        Text("Card Number", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        const TextField(
          decoration: InputDecoration(
            hintText: "0000 0000 0000 0000",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 25),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Expiration Date", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "mm/yy",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CVV", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "000",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreview() {
    double totalFee = double.tryParse(widget.trip["fee"]?.toString() ?? "0") ?? 0.0;
    double halfFee = totalFee * 0.5;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: buildImage(widget.trip["image"]),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          widget.trip["city"] ?? "Unknown",
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    bottom: -15,
                    right: 15,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.cyan,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage("assets/images/girl.png"),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRowInfo("Date", widget.trip["date"] ?? ""),
                    const SizedBox(height: 8),
                    _buildRowInfo("Time", "${widget.trip["from"] ?? ""} - ${widget.trip["to"] ?? ""}"),
                    const SizedBox(height: 8),
                    _buildRowGuide("Guide", "Emmy"),
                    const SizedBox(height: 8),
                    _buildRowInfo("Number of Travelers", "${widget.trip["travelers"] ?? 1}"),
                    const SizedBox(height: 15),
                    
                    const Text("Attractions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: (widget.trip["attractions"] as List? ?? []).map<Widget>((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.cyan.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on, color: Colors.teal, size: 10),
                              const SizedBox(width: 4),
                              Text(e.toString(), style: const TextStyle(color: Colors.teal, fontSize: 9)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
        const Divider(),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("\$${totalFee.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("50% payment", style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text("\$${halfFee.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14, color: Colors.teal)),
          ],
        ),
        const SizedBox(height: 5),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("(You just need to pay upfront 50%)", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildRowInfo(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildRowGuide(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
      ],
    );
  }
}
