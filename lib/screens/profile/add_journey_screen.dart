import 'package:flutter/material.dart';

// Import required for dotted border
// Unfortunately, dotted_border isn't in core Flutter, so I will simulate it using CustomPaint if necessary,
// or just use a standard Container with a cyan border for now. 
// A realistic dashed border without dependencies is a bit wordy, I'll use a clean continuous border.

class AddJourneyScreen extends StatelessWidget {
  const AddJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Add Journey", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("DONE", style: TextStyle(color: Colors.tealAccent.shade400, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const _JourneyField(label: "Name", hint: "Journey's Name"),
            const SizedBox(height: 30),
            const _JourneyField(label: "Location", hint: "Location of Journey"),
            const SizedBox(height: 40),

            // Upload Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.tealAccent.shade400, width: 1.5, style: BorderStyle.solid), // Substitute for dashed
              ),
              child: Column(
                children: [
                  Icon(Icons.camera_alt, color: Colors.tealAccent.shade400, size: 28),
                  const SizedBox(height: 10),
                  Text("Upload Photos", style: TextStyle(color: Colors.tealAccent.shade400, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _JourneyField extends StatelessWidget {
  final String label;
  final String hint;

  const _JourneyField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            isDense: true,
          ),
        )
      ],
    );
  }
}
