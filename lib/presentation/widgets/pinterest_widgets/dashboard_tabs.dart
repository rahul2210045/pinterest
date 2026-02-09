import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';
import 'package:pinterest/presentation/state_management/provider/board_tab_provider.dart';

class DashboardBoardTabs extends ConsumerWidget {
  const DashboardBoardTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(boardProvider);
    final selectedIndex = ref.watch(boardTabProvider);

    final totalTabs = boards.length + 2; 

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: totalTabs,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _TabItem(
              title: 'For you',
              isSelected: selectedIndex == 0,
              onTap: () => ref.read(boardTabProvider.notifier).state = 0,
            );
          }

          if (index == totalTabs - 1) {
            return _AddBoardButton(
              onTap: () {
              },
            );
          }

          final board = boards[index - 1];
          return _TabItem(
            title: board.name,
            isSelected: selectedIndex == index,
            onTap: () =>
                ref.read(boardTabProvider.notifier).state = index,
          );
        },
      ),
    );
  }
}
class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isSelected ? 22 : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _AddBoardButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddBoardButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
