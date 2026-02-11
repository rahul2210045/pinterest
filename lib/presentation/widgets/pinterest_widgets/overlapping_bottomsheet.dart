import 'package:flutter/material.dart';

void showPinOptions(BuildContext context, String imageUrl) {
  Widget _buildOption(IconData icon, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 20),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin:  EdgeInsets.only(top: 60),
          decoration: const BoxDecoration(
            color: Color(0xFF1C1C1C), 
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 100), 
              Text("This Pin is inspired by your recent activity", 
                   style: TextStyle(color: Colors.white, fontSize: 14)),
              _buildOption(Icons.bolt, "Save"),
              _buildOption(Icons.share, "Share"),
              _buildOption(Icons.download, "Download image"),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          top: 0, 
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageUrl, height: 160, width: 110, fit: BoxFit.cover),
          ),
        ),
      ],
    ),
  );

  

}