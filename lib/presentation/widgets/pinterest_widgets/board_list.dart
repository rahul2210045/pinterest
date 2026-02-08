import 'package:flutter/material.dart';

List<Widget> boardsSection(BuildContext context) {
  final boards = [
    'Cute cat',
    'Cute dogs',
    'Dreamy',
    'Flowers',
    'Friendship tattoos',
    'Madam ji',
  ];

  return boards.map((b) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 48,
          height: 48,
          color: Colors.grey.shade700,
        ),
      ),
      title: Text(
        b,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context, b); 
      },
    );
  }).toList();
}
