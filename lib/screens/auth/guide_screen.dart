import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Guide")),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, i) => guideCard(),
      ),
    );
  }

  Widget guideCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Image.network("https://picsum.photos/200", height: 120),
          const SizedBox(height: 5),
          const Text("Guide Name"),
          const Text("\$10/hr", style: TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
