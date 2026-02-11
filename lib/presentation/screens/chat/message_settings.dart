import 'package:flutter/material.dart';

class MessageSettingsScreen extends StatelessWidget {
  final String userName;
  final String profileImage;

  const MessageSettingsScreen({
    super.key,
    this.userName = "Ishika Shukla",
    this.profileImage = "assets/images/chat_logo.png",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Message settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          const Text(
            'Members',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          _buildMemberRow(userName, profileImage, "Block"),
          const SizedBox(height: 16),

          _buildMemberRow("Agam Tyagi", profileImage, "Block"),

          const SizedBox(height: 12),
          const Text(
            "Blocking a member prevents them from sending you messages or interacting with your pins. People aren't notified when you block them ",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 32),

          const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Notifications on',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 18,
            ),
            onTap: () {},
          ),

          const SizedBox(height: 28),

          const Text(
            'Privacy and support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

         
          const SizedBox(height: 12),

          _buildSupportItem("Report this conversation"),
          _buildSupportItem("Leave conversation", isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildMemberRow(String name, String image, String actionText) {
    return Row(
      children: [
        CircleAvatar(radius: 28, backgroundImage: AssetImage(image)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.grey.shade700,
          ),
          child: Text(
            actionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportItem(String title, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
