import 'package:flutter/material.dart';

class ProfileTabs extends StatelessWidget {
  final TabController controller;

  const ProfileTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorColor: Colors.white,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      tabs: const [
        
        Tab(text: 'Pins'),
        Tab(text: 'Boards'),
        Tab(text: 'Collages'),
      ],
    );
  }
}
