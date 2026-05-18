import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../explore/explore_screen.dart';
import '../trips/my_trips_screen.dart';
import '../notification/notification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  int unreadCount = 0;
  Timer? _timer;

  final screens = [
    const ExploreScreen(),
    const MyTripsScreen(),
    const ChatScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUnreadCount();
    // Poll for notifications every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchUnreadCount();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final notifs = await ApiService.getNotifications();
      int count = notifs.where((n) => n["read"] != true).length;
      if (count != unreadCount && mounted) {
        setState(() {
          unreadCount = count;
        });
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          if (index == 3) { // Notification tab
            _fetchUnreadCount(); // update immediately
          }
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          const BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Trips",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text(unreadCount.toString()),
              child: const Icon(Icons.notifications),
            ),
            label: "Alerts",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
