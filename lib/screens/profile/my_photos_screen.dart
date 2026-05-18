import 'package:flutter/material.dart';

class MyPhotosScreen extends StatelessWidget {
  const MyPhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Photos", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: 15,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (_, i) {
          if (i == 0) {
            return InkWell(
              onTap: () => Navigator.pushNamed(context, '/add-photos'),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.tealAccent.shade400, width: 1.5),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.tealAccent.shade400, size: 28),
                    const SizedBox(height: 5),
                    Text("Add Photos", style: TextStyle(color: Colors.tealAccent.shade400, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }
          return Image.network(
            "https://picsum.photos/200?random=$i",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
