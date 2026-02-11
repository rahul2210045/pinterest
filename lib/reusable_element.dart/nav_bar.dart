

import 'package:flutter/material.dart';
import 'package:pinterest/core/key/global_key.dart';

class PinterestBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const PinterestBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_filled,
              label: "Home",
              selected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.search,
              label: "Search",
              selected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),

            /// CREATE BUTTON
            _CreateButton(selected: selectedIndex == 2, onTap: () => () {}),

            _NavItem(
              icon: Icons.chat_bubble_outline,
              label: "Inbox",
              selected: selectedIndex == 3,
              onTap: () => onTap(3),
            ),

            ValueListenableBuilder<bool>(
              valueListenable: profileIconVisibility,
              builder: (_, visible, child) {
                return Opacity(
                  opacity: visible ? 1 : 0,
                  child: IgnorePointer(ignoring: !visible, child: child),
                );
              },
              child: _ProfileNavItem(
                selected: selectedIndex == 4,
                onTap: () => onTap(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _CreateButton({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.grey.shade500, size: 28),
            Text(
              "Create",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileNavItem extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _ProfileNavItem({
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade800,
              border: selected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            alignment: Alignment.center,
            child: const Text(
              "R",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Saved",
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
