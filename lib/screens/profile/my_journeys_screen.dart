import 'package:flutter/material.dart';

class MyJourneysScreen extends StatelessWidget {
  const MyJourneysScreen({super.key});

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
        title: const Text("My Journeys", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              /// Add Journey Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.tealAccent.shade400, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 0)
                ),
                onPressed: () => Navigator.pushNamed(context, '/add-journey'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.tealAccent.shade400, size: 18),
                    const SizedBox(width: 5),
                    Text("Add Journey", style: TextStyle(color: Colors.tealAccent.shade400, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// List of Journeys
              ...List.generate(5, (i) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2)
                    ]
                  ),
                  child: Column(
                    children: [
                      /// Mosaic Image Grid
                      SizedBox(
                        height: 180,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
                                child: Image.network("https://picsum.photos/400?random=${i*3}", fit: BoxFit.cover, height: double.infinity),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(15)),
                                      child: Image.network("https://picsum.photos/200?random=${i*3+1}", fit: BoxFit.cover, width: double.infinity),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Expanded(
                                    child: Image.network("https://picsum.photos/200?random=${i*3+2}", fit: BoxFit.cover, width: double.infinity),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      
                      /// Info Block
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(i == 0 ? "A memory in Danang" : "Sapa in spring", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.teal, size: 12),
                                      const SizedBox(width: 4),
                                      Text(i == 0 ? "Danang, Vietnam" : "Sapa, Vietnam", style: const TextStyle(color: Colors.teal, fontSize: 11)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(i == 0 ? "Jan 20, 2020" : "Jan 23, 2020", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(Icons.more_horiz, color: Colors.grey),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite_border, color: Colors.teal, size: 14),
                                    const SizedBox(width: 4),
                                    Text("294 Likes", style: TextStyle(color: Colors.teal.shade300, fontSize: 11)),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
