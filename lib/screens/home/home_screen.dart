import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔥 HEADER
              Stack(
                children: [
                  Image.network(
                    "https://picsum.photos/600/250",
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  const Positioned(
                    top: 20,
                    left: 16,
                    child: Text(
                      "Explore",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Hi, where do you want to explore?",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// 🔥 SECTION
              sectionTitle("Top Journeys"),

              horizontalTours(),

              sectionTitle("Best Guides"),

              guidesGrid(),

              sectionTitle("Top Experiences"),

              horizontalExperiences(),

              sectionTitle("Featured Tours"),

              verticalTours(),

              sectionTitle("Travel News"),

              newsList(),
            ],
          ),
        ),
      ),
    );
  }

  /// TITLE
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text("SEE MORE", style: TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  /// HORIZONTAL TOUR
  Widget horizontalTours() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        children: List.generate(3, (i) => tourCard()),
      ),
    );
  }

  Widget tourCard() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              "https://picsum.photos/300",
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Da Nang - Hoi An",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text("\$400.00", style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// GUIDES
  Widget guidesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, i) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Image.network("https://picsum.photos/200", height: 100),
              const SizedBox(height: 5),
              const Text("Guide Name"),
            ],
          ),
        ),
      ),
    );
  }

  /// EXPERIENCES
  Widget horizontalExperiences() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        children: List.generate(
          3,
          (i) => Container(
            width: 200,
            margin: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://picsum.photos/300",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// VERTICAL TOUR
  Widget verticalTours() {
    return Column(children: List.generate(3, (i) => bigTourCard()));
  }

  Widget bigTourCard() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Image.assets("https://picsum.photos/400", height: 150),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ha Long Bay"),
                Text("\$300", style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// NEWS
  Widget newsList() {
    return Column(
      children: List.generate(
        3,
        (i) => ListTile(
          leading: Image.network("https://picsum.photos/100"),
          title: const Text("Travel News Title"),
          subtitle: const Text("Feb 5, 2020"),
        ),
      ),
    );
  }
}
