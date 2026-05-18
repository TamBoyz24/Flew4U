import 'package:flutter/material.dart';
import 'package:flew4u/screens/detail/article_detail_screen.dart';
import 'package:flew4u/screens/detail/guide_detail_screen.dart';
import 'package:flew4u/screens/auth/search_screen.dart';
import '../../services/api_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Set of wishlisted tour keys (title)
  final Set<String> _wishlisted = {};
  // Map of title -> wishlist id (for toggle/remove)
  final Map<String, String> _wishlistIds = {};

  @override
  void initState() {
    super.initState();
    _loadWishlists();
  }

  Future<void> _loadWishlists() async {
    try {
      final data = await ApiService.getWishlists();
      setState(() {
        for (final item in data) {
          final title = item["title"] as String? ?? "";
          final id = item["id"] as String? ?? "";
          if (title.isNotEmpty && id.isNotEmpty) {
            _wishlisted.add(title);
            _wishlistIds[title] = id;
          }
        }
      });
    } catch (e) {
      debugPrint("Load wishlists error: $e");
    }
  }

  Future<void> _toggleWishlist(String title, String image, String price) async {
    if (_wishlisted.contains(title)) {
      // Remove from wishlist
      final id = _wishlistIds[title];
      if (id != null) {
        try {
          await ApiService.removeWishlist(id);
          setState(() {
            _wishlisted.remove(title);
            _wishlistIds.remove(title);
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Removed \"$title\" from Wishlist"),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ));
          }
        } catch (e) {
          debugPrint("Remove wishlist error: $e");
        }
      }
    } else {
      // Add to wishlist
      try {
        final result = await ApiService.addWishlist({
          "title": title,
          "image": image,
          "price": price,
          "date": DateTime.now().toIso8601String(),
          // Also save as trip with status Wishlist
          "city": title,
          "fee": price,
          "status": "Wishlist",
          "travelers": 1,
          "languages": ["English"],
          "attractions": [],
          "from": "",
          "to": "",
          "userName": "Traveler",
          "avatar": ""
        });
        final newId = result["id"]?.toString() ?? "";
        setState(() {
          _wishlisted.add(title);
          _wishlistIds[title] = newId;
        });

        // Also save to trips collection with status "Wishlist"
        await ApiService.addTrip({
          "city": title,
          "image": image,
          "fee": price,
          "status": "Wishlist",
          "date": DateTime.now().toIso8601String(),
          "travelers": 1,
          "languages": ["English"],
          "attractions": [],
          "from": "",
          "to": "",
          "userName": "Traveler",
          "avatar": ""
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text("\"$title\" saved to Wishlist!")),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ));
        }
      } catch (e) {
        debugPrint("Add wishlist error: $e");
      }
    }
  }

  Widget appImage(String path, {double? height}) {
    return Image.asset(
      path,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height ?? 120,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Stack(
              clipBehavior: Clip.none,
              children: [
                appImage("assets/images/cau_rong.jpg", height: 230),

                const Positioned(
                  left: 16,
                  top: 70,
                  child: Text(
                    "Explore",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Positioned(
                  right: 16,
                  top: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Da Nang", style: TextStyle(color: Colors.white)),
                      Text(
                        "26°C",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: -25,
                  left: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(30),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Hi, where do you want to explore?",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("Top Journeys"),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        journeyCard(
                          context,
                          "Da Nang - Ba Na - Hoi An",
                          "400",
                          "assets/images/danangbanahoian.jpg",
                        ),
                        journeyCard(
                          context,
                          "Thailand",
                          "600",
                          "assets/images/thailandtour.png",
                        ),
                        journeyCard(
                          context,
                          "Gia Lai - Binh Dinh",
                          "500",
                          "assets/images/GiaLai.jpg",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  sectionHeader(context, "Best Guides", "guides"),
                  const SizedBox(height: 10),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.75,
                    children: [
                      guideCard(context, "Tuan Tran", "assets/images/tuantran.png"),
                      guideCard(context, "Emmy", "assets/images/Emmy.png"),
                      guideCard(context, "Linh Hana", "assets/images/LinhHana.png"),
                      guideCard(context, "Khai Ho", "assets/images/khaiho.png"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  sectionTitle("Top Experiences"),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(child: experienceCard("Hoi An", "assets/images/2Hourebycle.jpg")),
                      const SizedBox(width: 10),
                      Expanded(child: experienceCard("Ba Na", "assets/images/1dayatbanahill.png")),
                    ],
                  ),

                  const SizedBox(height: 20),

                  sectionHeader(context, "Featured Tours", "tours"),
                  const SizedBox(height: 10),

                  tourCard(context, "Da Nang - Hoi An", "400", "assets/images/DanaBanaHoiAN.jpg"),
                  tourCard(context, "Thailand", "600", "assets/images/thailandtour.png"),
                  tourCard(context, "Ha Long Bay", "300", "assets/images/HaLongBay.jpg"),

                  const SizedBox(height: 20),

                  sectionHeader(context, "Travel News", "news"),
                  const SizedBox(height: 10),

                  newsCard(context, "New Destination in Da Nang", "assets/images/new datination in DanangCity.jpg"),
                  newsCard(context, "Visit Korea in this Tet Holiday", "assets/images/VisitKorea.png"),
                  newsCard(context, "1\$ Flight Ticket", "assets/images/1ticket.png"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget sectionHeader(BuildContext context, String title, String type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/see-more', arguments: {'type': type}),
          child: const Text("SEE MORE", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget journeyCard(BuildContext context, String title, String price, String image) {
    final isLiked = _wishlisted.contains(title);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              title: title,
              image: image,
              description: "Explore $title with amazing experiences, local guides, delicious food and wonderful places.",
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(height: 120, color: Colors.grey[200]),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("1247 likes", style: TextStyle(fontSize: 10)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "\$$price",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // Heart button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _toggleWishlist(title, image, price),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                  ),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget guideCard(BuildContext context, String name, String image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GuideDetailScreen(name: name, image: image),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(image, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 5),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text("Da Nang, Vietnam", style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget experienceCard(String title, String imagePath) {
    return Container(
      height: 230,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(imagePath, height: 130, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              title == "Hoi An" ? "2 Hour Bicycle Tour exploring Hoi An" : "1 day at Bana Hill",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget tourCard(BuildContext context, String title, String price, String image) {
    final isLiked = _wishlisted.contains(title);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              title: title,
              image: image,
              description: "Explore $title with amazing experiences and beautiful places.",
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(height: 150, color: Colors.grey[200]),
                  ),
                ),
                ListTile(
                  title: Text(title),
                  trailing: Text(
                    "\$$price",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // Heart button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _toggleWishlist(title, image, price),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                  ),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newsCard(BuildContext context, String title, String image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              title: title,
              image: image,
              description: "Latest travel news about $title.",
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(image, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}