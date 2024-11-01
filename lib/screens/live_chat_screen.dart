import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date and time

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  _LiveChatScreenState createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      "message": "Hello, how can I assist you today?",
      "sender": "support",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      "message": "I need help with my loan application.",
      "sender": "user",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 3)),
    },
    {
      "message": "Sure! Can you provide more details about your issue?",
      "sender": "support",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 1)),
    },
  ]; // Preloaded chat messages

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          "message": _messageController.text,
          "sender": "user",
          "timestamp": DateTime.now(),
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor, // Army Green
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['sender'] == 'user';
                return _buildChatBubble(message, isUserMessage);
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type your message',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build chat bubble with message, sender, and timestamp
  Widget _buildChatBubble(Map<String, dynamic> message, bool isUserMessage) {
    final formattedTime =
        DateFormat('hh:mm a, MMM d').format(message['timestamp']);
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isUserMessage
              ? Theme.of(context).primaryColor.withOpacity(0.8)
              : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUserMessage
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: isUserMessage
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['message'],
              style: TextStyle(
                color: isUserMessage ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              formattedTime,
              style: TextStyle(
                color: isUserMessage ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
