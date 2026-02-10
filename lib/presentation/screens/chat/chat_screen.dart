import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String profileImage;

  const ChatScreen({
    super.key,
    this.userName = "Ishika Shukla",
    this.profileImage = "assets/images/profile.jpg",
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _heartOnRight = false; // To toggle heart position

  @override
  void initState() {
    super.initState();
    // Initial static message from "Ishika"
    _messages.add({
      "text": "cisco",
      "isMe": false,
      "time": "Feb 6, 2:44 pm",
      "isHeart": false,
    });

    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        "text": _messageController.text,
        "isMe": true,
        "time": "Just now",
        "isHeart": false,
      });
      _messageController.clear();
    });
    _scrollToBottom();
  }

  void _sendHeart() {
    setState(() {
      _messages.add({
        "text": "❤️",
        "isMe": true, // Toggles side based on your requirement
        "time": "Just now",
        "isHeart": true,
      });
      _heartOnRight = !_heartOnRight; // Switch for next tap
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 30,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(widget.profileImage),
            ),
            const SizedBox(width: 10),
            Text(
              widget.userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {
              context.push('/message-settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 20),
                // Header section
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(widget.profileImage),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "This is the beginning of your\nmessage history with Ishika",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "Feb 6, 2:44 pm",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),

                // Message List
                ..._messages.map((msg) => _buildChatBubble(msg)).toList(),
              ],
            ),
          ),
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> msg) {
    bool isMe = msg['isMe'];
    bool isHeart = msg['isHeart'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(widget.profileImage),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isHeart ? 10 : 16,
              vertical: isHeart ? 10 : 6,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: isHeart
                ? null
                : BoxDecoration(
                    color: isMe ? Colors.grey.shade700 : Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: isMe ? Colors.transparent : Colors.white,
                    ),
                  ),
            child: Text(
              msg['text'],
              style: TextStyle(
                color: Colors.white,
                fontSize: isHeart ? 35 : 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      color: Colors.black,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade900,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Send a message",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: _isTyping ? _sendMessage : _sendHeart,
            child: CircleAvatar(
              backgroundColor: _isTyping ? Colors.white : Colors.black,
              child: Icon(
                _isTyping ? Icons.send : Icons.favorite,
                color: _isTyping ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
