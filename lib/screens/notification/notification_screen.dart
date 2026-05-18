import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../chat/chat_screen.dart';
import '../trips/my_trips_screen.dart';
import '../detail/trip_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final data = await ApiService.getNotifications();
      setState(() {
        _notifications = data.reversed.toList(); // newest first
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _handleTap(Map<String, dynamic> notif) async {
    if (notif["read"] != true) {
      notif["read"] = true;
      await ApiService.markNotificationAsRead(notif["id"], notif);
      setState(() {});
    }

    if (!mounted) return;
    
    if (notif["type"] == "message") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
    } else {
      if (notif["tripData"] != null) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(
          trip: notif["tripData"],
          onDelete: () {}, // stub for now
        )));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MyTripsScreen()));
      }
    }
  }

  void _toggleReadStatus(Map<String, dynamic> notif) async {
    bool newStatus = !(notif["read"] == true);
    notif["read"] = newStatus;
    await ApiService.markNotificationAsRead(notif["id"], notif);
    setState(() {});
  }

  void _deleteNotification(Map<String, dynamic> notif) async {
    await ApiService.deleteNotification(notif["id"]);
    setState(() {
      _notifications.removeWhere((n) => n["id"] == notif["id"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _notifications.isEmpty
          ? const Center(child: Text("No notifications yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index] as Map<String, dynamic>;
                return notificationItem(notif);
              },
            ),
    );
  }

  Widget notificationItem(Map<String, dynamic> notif) {
    bool isRead = notif["read"] == true;
    return GestureDetector(
      onTap: () => _handleTap(notif),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isRead ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isRead ? null : Border.all(color: Colors.teal.shade200),
        ),
        child: Row(
          children: [
            Icon(
              notif["type"] == "message" ? Icons.message : Icons.notifications,
              color: isRead ? Colors.grey : const Color.fromARGB(255, 218, 29, 29),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif["title"] ?? "",
                    style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(notif["subtitle"] ?? "", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            if (!isRead)
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                if (value == 'toggle') {
                  _toggleReadStatus(notif);
                } else if (value == 'delete') {
                  _deleteNotification(notif);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'toggle',
                  child: Text(isRead ? 'Đánh dấu chưa đọc' : 'Đánh dấu đã đọc'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Ẩn / Xóa thông báo này'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
