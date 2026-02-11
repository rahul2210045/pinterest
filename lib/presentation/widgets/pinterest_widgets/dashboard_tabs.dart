import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';
import 'package:pinterest/presentation/state_management/provider/board_tab_provider.dart';

// class DashboardBoardTabs extends ConsumerWidget {
//   const DashboardBoardTabs({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final boards = ref.watch(boardProvider);
//     final selectedIndex = ref.watch(boardTabProvider);

//     final totalTabs = boards.length + 2;

//     return SizedBox(
//       height: 48,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: totalTabs,
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             return _TabItem(
//               title: 'For you',
//               isSelected: selectedIndex == 0,
//               onTap: () => ref.read(boardTabProvider.notifier).state = 0,
//             );
//           }

//           if (index == totalTabs - 1) {
//             return _AddBoardButton(
//               onTap: () {
//               },
//             );
//           }

//           final board = boards[index - 1];
//           return _TabItem(
//             title: board.name,
//             isSelected: selectedIndex == index,
//             onTap: () =>
//                 ref.read(boardTabProvider.notifier).state = index,
//           );
//         },
//       ),
//     );
//   }
// }
class DashboardBoardTabs extends ConsumerStatefulWidget {
  final ValueChanged<int> onTabSelected;

  const DashboardBoardTabs({super.key, required this.onTabSelected});

  @override
  ConsumerState<DashboardBoardTabs> createState() => _DashboardBoardTabsState();
}

class _DashboardBoardTabsState extends ConsumerState<DashboardBoardTabs> {
  late final ScrollController _scrollController;

  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (mounted) {
          setState(() {
            _scrollOffset = _scrollController.offset;
          });
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boards = ref.watch(boardProvider);
    final selectedIndex = ref.watch(boardTabProvider);

    final titles = ['For you', ...boards.map((e) => e.name)];

    double absoluteLeft = 12;
    for (int i = 0; i < selectedIndex; i++) {
      absoluteLeft += _textWidth(titles[i]) + 28;
    }

    final indicatorWidth = _textWidth(titles[selectedIndex]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final screenWidth = MediaQuery.of(context).size.width;
      final tabCenter = absoluteLeft + indicatorWidth / 2;

      final targetOffset = tabCenter - screenWidth / 2;

      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });

    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: titles.length + 1,
            itemBuilder: (context, index) {
              if (index == titles.length) {
                return _AddBoardButton(onTap: () {});
              }

              return GestureDetector(
                onTap: () {
                  ref.read(boardTabProvider.notifier).state = index;
                  widget.onTabSelected(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Center(
                    child: Text(
                      titles[index],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: selectedIndex == index
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeInOutCubic,
            left: absoluteLeft + 14 - _scrollOffset,
            bottom: 4,
            child: Container(
              width: indicatorWidth,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          
        ],
      ),
    );
  }

  double _textWidth(String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 15)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return painter.size.width;
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
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? IntrinsicWidth(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )
                  : const SizedBox(height: 2),
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
