import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SeeMoreMessagesScreen extends StatelessWidget {
  const SeeMoreMessagesScreen({super.key});

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
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white, size: 22),
            onPressed: () {context.push('/new-message');},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 10),
          // Messages Header
          const Text(
            'Messages',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Your Provided Chat Tile
          _chatTile(onTap: (){
            context.push('/chat-screen');
          }),
          
          const SizedBox(height: 30),
          
          // Contacts Header
          const Text(
            'Contacts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Your Provided Find People Card
          _findPeopleCard(),
          
          const SizedBox(height: 24),
          
          // Additional Chat Tiles as requested
          _chatTile(onTap: () {context.push('/chat-screen');}),
          const SizedBox(height: 16),
          _chatTile(onTap: () {}),
        ],
      ),
    );
  }

  Widget _chatTile({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
      children: [
        const CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/profile.jpg'),
        ),
        const SizedBox(width: 12),
        Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
          Text(
            'Ishika Shukla',
            style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Hi', 
            style: TextStyle(color: Colors.grey, fontSize: 12)
          ),
          ],
        ),
        ),
        const Text(
        '9m', 
        style: TextStyle(color: Colors.grey, fontSize: 12)
        ),
      ],
      ),
    );
  }

  Widget _findPeopleCard() {
    return Container(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_add_alt_1, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Find people to message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Connect to start chatting',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}