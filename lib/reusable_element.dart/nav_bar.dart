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
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              icon: Icons.home_filled,
              selected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.search,
              selected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            _CreateButton(
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.chat_bubble_outline,
              selected: selectedIndex == 3,
              onTap: () => onTap(3),
            ),
            _ProfileNavItem(
              key: profileTabKey, 
              selected: selectedIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}
class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Icon(
        icon,
        size: 28,
        color: selected ? Colors.white : Colors.grey,
      ),
    );
  }
}
class _CreateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 28,
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: selected
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?img=3', 
          ),
        ),
      ),
    );
  }
}
