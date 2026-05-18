import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ChatBoxScreen extends StatefulWidget {
  final String userName;
  final String avatar;

  const ChatBoxScreen({super.key, required this.userName, required this.avatar});

  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    try {
      final data = await ApiService.getChats(widget.userName);
      setState(() {
        _messages = data.map((e) => e as Map<String, dynamic>).toList();
        if (_messages.isEmpty) {
          // default message
          _messages.add({
            "sender": "bot",
            "text": "Hello! How can I help you today?",
            "time": "Just now",
            "chatWith": widget.userName,
          });
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _sendMessage() async {
    if (_msgCtrl.text.trim().isEmpty) return;

    final userMsg = {
      "sender": "user",
      "text": _msgCtrl.text.trim(),
      "time": "Just now",
      "chatWith": widget.userName,
    };

    setState(() {
      _messages.add(userMsg);
    });

    String userText = _msgCtrl.text;
    _msgCtrl.clear();

    // Save user message to API
    try {
      await ApiService.addChat(userMsg);
    } catch (e) {
      print(e);
    }

    // Simulate Fake AI response
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final botMsg = {
        "sender": "bot",
        "text": "This is an automated reply to: '$userText'",
        "time": "Just now",
        "chatWith": widget.userName,
      };

      setState(() {
        _messages.add(botMsg);
      });

      // Save bot message to API
      try {
        await ApiService.addChat(botMsg);
      } catch (e) {
        print(e);
      }

      // Show small notification at corner (SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New message from ${widget.userName}"),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        )
      );

      // Add to global notifications
      try {
        await ApiService.addNotification({
          "title": "New Message",
          "subtitle": "From ${widget.userName}: This is an automated reply...",
          "type": "message",
          "read": false,
          "date": DateTime.now().toIso8601String()
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.avatar),
              radius: 16,
            ),
            const SizedBox(width: 10),
            Text(widget.userName, style: const TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      bool isMe = _messages[index]["sender"] == "user";
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.teal : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _messages[index]["text"],
                            style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _msgCtrl,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: const CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.send, color: Colors.white, size: 18),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
