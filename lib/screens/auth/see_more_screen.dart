import 'package:flutter/material.dart';
import 'package:flew4u/screens/detail/article_detail_screen.dart';
import 'package:flew4u/screens/detail/guide_detail_screen.dart';
import 'package:flew4u/screens/auth/search_screen.dart';
import '../../services/api_service.dart';

class SeeMoreScreen extends StatefulWidget {
  const SeeMoreScreen({super.key});

  @override
  State<SeeMoreScreen> createState() => _SeeMoreScreenState();
}

class _SeeMoreScreenState extends State<SeeMoreScreen> {
  final Set<String> _wishlisted = {};
  final Map<String, String> _wishlistIds = {};
  bool _loading = true;
  String _type = 'tours';

  // ============ PIXEL PERFECT MOCK DATA ============
  final List<Map<String, String>> _tours = [
    {
      "title": "Da Nang - Ba Na - Hoi An",
      "price": "400.00",
      "image": "assets/images/danangbanahoian.jpg",
      "date": "Jan 30, 2020",
      "duration": "3 days",
      "likes": "1247"
    },
    {
      "title": "Melbourne - Sydney",
      "price": "600.00",
      "image": "assets/images/thailandtour.png", // Stand-in for Sydney/Melbourne
      "date": "Jan 30, 2020",
      "duration": "3 days",
      "likes": "1247"
    },
    {
      "title": "Hanoi - Ha Long Bay",
      "price": "300.00",
      "image": "assets/images/HaLongBay.jpg",
      "date": "Jan 30, 2020",
      "duration": "3 days",
      "likes": "1247"
    },
    {
      "title": "Da Nang - Ba Na - Hoi An",
      "price": "400.00",
      "image": "assets/images/DanaBanaHoiAN.jpg",
      "date": "Jan 30, 2020",
      "duration": "3 days",
      "likes": "1247"
    },
    {
      "title": "Melbourne - Sydney",
      "price": "600.00",
      "image": "assets/images/thailandtour.png",
      "date": "Jan 30, 2020",
      "duration": "3 days",
      "likes": "1247"
    },
  ];

  final List<Map<String, String>> _guides = [
    {
      "name": "Tuan Tran",
      "location": "Danang, Vietnam",
      "image": "assets/images/tuantran.png",
      "reviews": "127",
      "price": "10.0"
    },
    {
      "name": "Emmy",
      "location": "Hanoi, Vietnam",
      "image": "assets/images/Emmy.png",
      "reviews": "99",
      "price": "12.0"
    },
    {
      "name": "Linh Hana",
      "location": "Danang, Vietnam",
      "image": "assets/images/LinhHana.png",
      "reviews": "127",
      "price": "11.0"
    },
    {
      "name": "Khai Ho",
      "location": "Ho Chi Minh, Vietnam",
      "image": "assets/images/khaiho.png",
      "reviews": "127",
      "price": "9.0"
    },
    {
      "name": "Tuan Tran",
      "location": "Danang, Vietnam",
      "image": "assets/images/tuantran.png",
      "reviews": "127",
      "price": "10.0"
    },
    {
      "name": "Emmy",
      "location": "Hanoi, Vietnam",
      "image": "assets/images/Emmy.png",
      "reviews": "99",
      "price": "12.0"
    },
    {
      "name": "Linh Hana",
      "location": "Danang, Vietnam",
      "image": "assets/images/LinhHana.png",
      "reviews": "127",
      "price": "11.0"
    },
    {
      "name": "Khai Ho",
      "location": "Ho Chi Minh, Vietnam",
      "image": "assets/images/khaiho.png",
      "reviews": "127",
      "price": "9.0"
    },
  ];

  final List<Map<String, String>> _news = [
    {
      "title": "New Destination in Da Nang",
      "image": "assets/images/new datination in DanangCity.jpg",
      "date": "May 18, 2026",
      "summary": "Explore the newly opened sky walk and premium entertainment hubs in the heart of Da Nang City."
    },
    {
      "title": "Visit Korea in this Tet Holiday",
      "image": "assets/images/VisitKorea.png",
      "date": "May 15, 2026",
      "summary": "Complete travel guide for Vietnamese tourists planning to experience Korean snow and cuisine."
    },
    {
      "title": "1\$ Flight Ticket Extravaganza",
      "image": "assets/images/1ticket.png",
      "date": "May 10, 2026",
      "summary": "Top airline brands launch super-saver tickets for upcoming summer flights."
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('type')) {
      _type = args['type'];
    }
    _loadWishlists();
  }

  Future<void> _loadWishlists() async {
    try {
      final data = await ApiService.getWishlists();
      if (mounted) {
        setState(() {
          _wishlisted.clear();
          _wishlistIds.clear();
          for (final item in data) {
            final title = item["title"] as String? ?? "";
            final id = item["id"] as String? ?? "";
            if (title.isNotEmpty && id.isNotEmpty) {
              _wishlisted.add(title);
              _wishlistIds[title] = id;
            }
          }
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _toggleWishlist(String title, String image, String price) async {
    if (_wishlisted.contains(title)) {
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
            ));
          }
        } catch (e) {
          debugPrint("Error removing wishlist: $e");
        }
      }
    } else {
      try {
        final result = await ApiService.addWishlist({
          "title": title,
          "image": image,
          "price": price,
          "date": DateTime.now().toIso8601String(),
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
          ));
        }
      } catch (e) {
        debugPrint("Error adding wishlist: $e");
      }
    }
  }

  String _getHeaderText() {
    switch (_type) {
      case 'guides':
        return 'Book your own private local\nGuide and explore the city';
      case 'news':
        return 'Get the latest updates and\ntravel stories around the world';
      case 'tours':
      default:
        return 'Plenty of amazing of tours are\nwaiting for you';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
    );
  }

  // ============ HEADER SECTION (WITH CURVED BG & SEARCH OVERLAY) ============
  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Header Image with curved bottom right
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/danangbanahoian.jpg"), // Clean background
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withValues(alpha: 0.45), // Translucent black overlay
            ),
          ),
        ),

        // Text & Content inside Header
        Positioned(
          left: 20,
          right: 20,
          bottom: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getHeaderText(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),

        // Floating Search Bar positioned perfectly
        Positioned(
          left: 16,
          right: 16,
          bottom: -22,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    "Hi, where do you want to explore?",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Elegant Floating Back Button
        Positioned(
          top: 40,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final double spacingTop = 38.0;
    if (_type == 'guides') {
      return Padding(
        padding: EdgeInsets.only(top: spacingTop),
        child: _buildGuidesGrid(),
      );
    } else if (_type == 'news') {
      return Padding(
        padding: EdgeInsets.only(top: spacingTop),
        child: _buildNewsList(),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: spacingTop),
        child: _buildToursList(),
      );
    }
  }

  // ============ 1. GUIDES GRID VIEW (2-COLUMNS MOCKUP PERFECT) ============
  Widget _buildGuidesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: _guides.length,
      itemBuilder: (context, index) {
        final g = _guides[index];
        final name = g["name"]!;
        final image = g["image"]!;
        final location = g["location"]!;
        final reviews = g["reviews"]!;
        final hourlyPrice = double.tryParse(g["price"]!) ?? 10.0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GuideDetailScreen(
                  name: name,
                  image: image,
                  location: location,
                  reviews: int.parse(reviews),
                  pricePerHour: hourlyPrice,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image with overlaid transparent reviews count
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => Container(
                            color: Colors.teal.shade50,
                            child: const Icon(Icons.person, size: 40, color: Colors.teal),
                          ),
                        ),
                      ),
                      // Translucent reviews card overlay on image bottom
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.star, color: Colors.amber, size: 10),
                                  Icon(Icons.star, color: Colors.amber, size: 10),
                                  Icon(Icons.star, color: Colors.amber, size: 10),
                                  Icon(Icons.star, color: Colors.amber, size: 10),
                                  Icon(Icons.star, color: Colors.amber, size: 10),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "$reviews Reviews",
                                style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Details below image
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.tealAccent),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============ 2. TOURS LIST VIEW (MOCKUP ACCURATE WITH HEART & ICONS) ============
  Widget _buildToursList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _tours.length,
      itemBuilder: (context, index) {
        final t = _tours[index];
        final title = t["title"]!;
        final image = t["image"]!;
        final price = t["price"]!;
        final date = t["date"]!;
        final duration = t["duration"]!;
        final likes = t["likes"]!;
        final isLiked = _wishlisted.contains(title);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleDetailScreen(
                  title: title,
                  image: image,
                  description: "Explore the beautiful destinations of $title with all-inclusive services, guides and travel packages.",
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rectangular image with bookmarks and likes overlay
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        image,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(
                          height: 160,
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    // Floating Bookmark Button top right
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bookmark_border, color: Colors.white, size: 16),
                      ),
                    ),
                    // Translucent Likes overlay on image bottom
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 9),
                            const Icon(Icons.star, color: Colors.amber, size: 9),
                            const Icon(Icons.star, color: Colors.amber, size: 9),
                            const Icon(Icons.star, color: Colors.amber, size: 9),
                            const Icon(Icons.star, color: Colors.amber, size: 9),
                            const SizedBox(width: 4),
                            Text(
                              "$likes Likes",
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & heart icon row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _toggleWishlist(title, image, price),
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.teal : Colors.teal.shade200,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Meta info row: Date & Duration
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                          Text(
                            "\$$price",
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============ 3. TRAVEL NEWS LIST VIEW ============
  Widget _buildNewsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _news.length,
      itemBuilder: (context, index) {
        final n = _news[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleDetailScreen(
                  title: n["title"]!,
                  image: n["image"]!,
                  description: n["summary"]!,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    n["image"]!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n["date"]!,
                          style: TextStyle(
                            color: Colors.teal.shade300,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n["title"]!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          n["summary"]!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}