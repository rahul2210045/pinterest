import 'package:flutter/material.dart';

List<Widget> suggestedBoardsSection(BuildContext context) {
  final suggestions = [
    'Wallpaper',
    'Stuff to buy',
    'Places to visit',
    'Projects to try',
    'Things to wear',
  ];

  return suggestions.map((s) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      title: Text(
        s,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context, s);
      },
    );
  }).toList();
}
