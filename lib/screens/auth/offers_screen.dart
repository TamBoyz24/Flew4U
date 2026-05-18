import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offers")),

      body: ListView(
        children: [
          offerCard("Khai Ho", "\$10/hour"),
          offerCard("Tran Thao", "\$12/hour"),
          offerCard("Henry", "\$9/hour"),
        ],
      ),
    );
  }

  Widget offerCard(String name, String price) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
        ),
        title: Text(name),
        subtitle: Text("Offer: $price"),
        trailing: ElevatedButton(onPressed: () {}, child: const Text("Choose")),
      ),
    );
  }
}
