import 'package:flutter/material.dart';

class CreateBoardButton extends StatelessWidget {
  final VoidCallback onTap;
  const CreateBoardButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        border: Border(
          top: BorderSide(color: Colors.white24),
        ),
          ),
          child: Row(
        children: const [
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: 12),
          Text(
            'Create board',
            style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }
}
