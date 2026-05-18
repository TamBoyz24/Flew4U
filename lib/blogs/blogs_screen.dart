import 'package:flutter/material.dart';

class BlogDetailScreen extends StatelessWidget {
  const BlogDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HEADER IMAGE
            Stack(
              children: [
                Image.asset(
                  "assets/images/anhdaidien.png",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 40,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            /// CONTENT
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// LIKE + SHARE
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, color: Colors.green),
                      const SizedBox(width: 5),
                      const Text("Like 46"),
                      const Spacer(),
                      Icon(Icons.facebook, color: Colors.grey[600]),
                      const SizedBox(width: 10),
                      Icon(Icons.share, color: Colors.grey[600]),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// TITLE
                  const Text(
                    "Title here: Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  /// AUTHOR
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/anhdaidien.png"),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Chin-Sun"),
                          Text("Mar 8, 2020",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// PARAGRAPH
                  textBlock(),
                  const SizedBox(height: 10),
                  textBlock(),

                  const SizedBox(height: 20),

                  /// VIDEO PREVIEW
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/anhdaidien.png",
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white70,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.play_arrow,
                              size: 40, color: Colors.green),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// HEADER GREEN
                  const Text(
                    "Header here: Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  textBlock(),

                  const SizedBox(height: 10),

                  /// 2 IMAGES
                  Row(
                    children: [
                      Expanded(child: imageBox()),
                      const SizedBox(width: 10),
                      Expanded(child: imageBox()),
                    ],
                  ),

                  const SizedBox(height: 10),

                  textBlock(),

                  const SizedBox(height: 10),

                  const Text(
                    "It was popularised in the 1960s with the release of Letraset sheets (Link)",
                    style: TextStyle(color: Colors.blue),
                  ),

                  const SizedBox(height: 20),

                  imageBox(height: 200),

                  const SizedBox(height: 15),

                  /// TAGS
                  Wrap(
                    spacing: 8,
                    children: [
                      tag("#Vietnam Local Guide"),
                      tag("#Hoi An"),
                      tag("#Da Nang Local Tour"),
                      tag("#Vietnam"),
                      tag("#Guide"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// LIKE AGAIN
                  Row(
                    children: [
                      const Icon(Icons.favorite_border,
                          color: Colors.green),
                      const SizedBox(width: 5),
                      const Text("Like 46"),
                      const Spacer(),
                      Icon(Icons.facebook, color: Colors.grey[600]),
                      const SizedBox(width: 10),
                      Icon(Icons.share, color: Colors.grey[600]),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// COMMENTS
                  const Text("Comments (1)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  commentItem(),

                  const SizedBox(height: 10),

                  /// ADD COMMENT
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Add Your Comment",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// RELATED POSTS
                  const Text("Related Posts",
                      style:
                          TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  relatedItem("New Destination in Danang City"),
                  relatedItem("\$1 Flight Ticket"),
                  relatedItem("Visit Korea in this Tet Holiday"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TEXT BLOCK
  Widget textBlock() {
    return const Text(
      "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
      style: TextStyle(color: Colors.black87),
    );
  }

  /// IMAGE BOX
  Widget imageBox({double height = 120}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        "assets/images/anhdaidien.png",
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  /// TAG
  Widget tag(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey[200],
    );
  }

  /// COMMENT
  Widget commentItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        CircleAvatar(child: Text("CH")),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Chin-Hwa Lee",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Mar 10, 2020",
                  style: TextStyle(color: Colors.grey)),
              SizedBox(height: 5),
              Text(
                  "The passage is the 1960s with the release of Letraset sheets containing Lorem Ipsum passages..."),
            ],
          ),
        )
      ],
    );
  }

  /// RELATED ITEM
  Widget relatedItem(String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/cau_rong.jpg",
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(title),
          )
        ],
      ),
    );
  }
}