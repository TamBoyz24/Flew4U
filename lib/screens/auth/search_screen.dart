import 'package:flutter/material.dart';
import '../detail/article_detail_screen.dart';
import '../detail/guide_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _ctrl = TextEditingController();
  late TabController _tabController;

  // ============ DATA ============
  final List<Map<String, String>> _allTours = [
    {"title": "Da Nang - Ba Na - Hoi An", "price": "400", "image": "assets/images/danangbanahoian.jpg", "type": "tour"},
    {"title": "Thailand", "price": "600", "image": "assets/images/thailandtour.png", "type": "tour"},
    {"title": "Gia Lai - Binh Dinh", "price": "500", "image": "assets/images/GiaLai.jpg", "type": "tour"},
    {"title": "Da Nang - Hoi An", "price": "400", "image": "assets/images/DanaBanaHoiAN.jpg", "type": "tour"},
    {"title": "Ha Long Bay", "price": "300", "image": "assets/images/HaLongBay.jpg", "type": "tour"},
  ];

  final List<Map<String, String>> _allGuides = [
    {"name": "Tuan Tran", "location": "Da Nang, Vietnam", "image": "assets/images/tuantran.png"},
    {"name": "Emmy", "location": "Da Nang, Vietnam", "image": "assets/images/Emmy.png"},
    {"name": "Linh Hana", "location": "Da Nang, Vietnam", "image": "assets/images/LinhHana.png"},
    {"name": "Khai Ho", "location": "Da Nang, Vietnam", "image": "assets/images/khaiho.png"},
  ];

  final List<Map<String, String>> _allExperiences = [
    {"title": "2 Hour Bicycle Tour - Hoi An", "image": "assets/images/2Hourebycle.jpg"},
    {"title": "1 Day at Ba Na Hill", "image": "assets/images/1dayatbanahill.png"},
  ];

  // ============ RECENT ============
  List<String> _recent = ["Da Nang", "Thailand", "Ha Long", "Emmy"];

  // ============ FILTERED ============
  List<Map<String, String>> _filteredTours = [];
  List<Map<String, String>> _filteredGuides = [];
  List<Map<String, String>> _filteredExperiences = [];
  String _query = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _search(String q) {
    setState(() {
      _query = q.trim();
      final lower = _query.toLowerCase();
      _filteredTours = _allTours
          .where((t) => t["title"]!.toLowerCase().contains(lower))
          .toList();
      _filteredGuides = _allGuides
          .where((g) =>
              g["name"]!.toLowerCase().contains(lower) ||
              g["location"]!.toLowerCase().contains(lower))
          .toList();
      _filteredExperiences = _allExperiences
          .where((e) => e["title"]!.toLowerCase().contains(lower))
          .toList();
    });
  }

  void _onRecentTap(String tag) {
    _ctrl.text = tag;
    _search(tag);
  }

  void _submitSearch(String q) {
    if (q.trim().isEmpty) return;
    setState(() {
      if (!_recent.contains(q.trim())) {
        _recent.insert(0, q.trim());
        if (_recent.length > 8) _recent.removeLast();
      }
    });
    _search(q);
  }

  @override
  Widget build(BuildContext context) {
    final bool showResults = _query.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: _search,
          onSubmitted: _submitSearch,
          decoration: InputDecoration(
            hintText: "Search tours, guides, places...",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            border: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      _ctrl.clear();
                      _search('');
                    },
                  )
                : null,
          ),
        ),
        bottom: showResults
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.teal,
                indicatorWeight: 2,
                tabs: [
                  Tab(text: "Tours (${_filteredTours.length})"),
                  Tab(text: "Guides (${_filteredGuides.length})"),
                  Tab(text: "Exp. (${_filteredExperiences.length})"),
                ],
              )
            : null,
      ),
      body: showResults ? _buildResults() : _buildHome(),
    );
  }

  // ============ HOME (no query) ============
  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent
          if (_recent.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Searches",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () => setState(() => _recent.clear()),
                  child: const Text("Clear", style: TextStyle(color: Colors.teal)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recent.map(
                    (tag) => GestureDetector(
                      onTap: () => _onRecentTap(tag),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history, size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 6),
                            Text(tag, style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 28),
          ],

          // Popular tags
          const Text("Popular",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              "Da Nang",
              "Hoi An",
              "Ba Na Hill",
              "Thailand",
              "Ha Long",
              "Emmy",
              "Khai Ho",
              "City Tour",
            ]
                .map(
                  (tag) => GestureDetector(
                    onTap: () => _onRecentTap(tag),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade400, Colors.teal.shade700],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "# $tag",
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 28),

          // Trending tours
          const Text("Trending Tours",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ..._allTours.take(3).map((tour) => _trendingTile(tour)).toList(),
        ],
      ),
    );
  }

  Widget _trendingTile(Map<String, String> tour) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(
            title: tour["title"]!,
            image: tour["image"]!,
            description: "Explore ${tour["title"]} with amazing experiences.",
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                tour["image"]!,
                width: 70,
                height: 60,
                fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(width: 70, height: 60, color: Colors.grey[200]),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text("\$${tour["price"]}",
                      style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ============ RESULTS ============
  Widget _buildResults() {
    final total =
        _filteredTours.length + _filteredGuides.length + _filteredExperiences.length;

    if (total == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text("No results for \"$_query\"",
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text("Try different keywords", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _tourResults(),
        _guideResults(),
        _expResults(),
      ],
    );
  }

  Widget _tourResults() {
    if (_filteredTours.isEmpty) {
      return _emptyTab("No tours found");
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredTours.length,
      itemBuilder: (_, i) => _trendingTile(_filteredTours[i]),
    );
  }

  Widget _guideResults() {
    if (_filteredGuides.isEmpty) return _emptyTab("No guides found");
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredGuides.length,
      itemBuilder: (_, i) {
        final g = _filteredGuides[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  GuideDetailScreen(name: g["name"]!, image: g["image"]!),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset(
                    g["image"]!,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.teal.shade100,
                      child: const Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g["name"]!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 13, color: Colors.teal),
                          const SizedBox(width: 3),
                          Text(g["location"]!,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const Text(" 4.9", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _expResults() {
    if (_filteredExperiences.isEmpty) return _emptyTab("No experiences found");
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredExperiences.length,
      itemBuilder: (_, i) {
        final e = _filteredExperiences[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleDetailScreen(
                title: e["title"]!,
                image: e["image"]!,
                description: "Experience: ${e["title"]}",
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(e["image"]!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(height: 140, color: Colors.grey[200])),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(e["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emptyTab(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(msg, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
