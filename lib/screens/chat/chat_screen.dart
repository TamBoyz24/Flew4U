import 'package:flutter/material.dart';
import 'chat_box_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView(
  padding: const EdgeInsets.all(12),
  children: [
    chatItem(
      context,
      "Tuan Tran",
      "Hey! Are you coming?",
      true,
      "assets/images/tuantran.png",
    ),

    chatItem(
      context,
      "Emmy",
      "Trip is confirmed!",
      false,
      "assets/images/Emmy.png",
    ),

    chatItem(
      context,
      "Khai Ho",
      "See you tomorrow",
      true,
      "assets/images/KhaiHo.png",
    ),
  ],
),
    );
  }

  Widget chatItem(BuildContext context, String name, String message, bool online, String avatar) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatBoxScreen(
              userName: name,
              avatar: avatar,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(avatar),
                ),
                if (online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(message, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Text("2m", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
