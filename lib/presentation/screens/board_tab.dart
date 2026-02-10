import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/models/search_input_arg.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/board_card.dart';
import 'package:pinterest/reusable_element.dart/empty_page.dart';

class BoardsTab extends ConsumerStatefulWidget {
  const BoardsTab({super.key});

  @override
  ConsumerState<BoardsTab> createState() => _BoardsTabState();
}

class _BoardsTabState extends ConsumerState<BoardsTab> {
  bool isGroupMode = false;

  @override
  Widget build(BuildContext context) {
    final boards = ref.watch(boardProvider);

    return Column(
      children: [
        /// 🔒 FIXED HEADER
        _BoardsHeader(
          isGroupMode: isGroupMode,
          onGroupToggle: () {
            setState(() => isGroupMode = !isGroupMode);
          },
        ),

        /// CONTENT
        Expanded(
          child: isGroupMode
              ? const GroupEmptyState()
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.78,
                        ),
                    itemCount: boards.length,
                    itemBuilder: (_, i) {
                      return BoardCard(board: boards[i]);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _BoardsHeader extends StatelessWidget {
  final bool isGroupMode;
  final VoidCallback onGroupToggle;

  const _BoardsHeader({required this.isGroupMode, required this.onGroupToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: Colors.black,
      child: Column(
        children: [
          /// SEARCH + ADD
          Row(
            children: [
                Expanded(
                child: InkWell(
                  onTap: () {
                    context.push(
  '/search-input',
  extra: const SearchInputArgs(source: SearchSource.boards),
);

                  },
                  child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: const [
                    Icon(Icons.search, color: Colors.white54),
                    SizedBox(width: 8),
                    Text(
                      'Search your Pins',
                      style: TextStyle(color: Colors.white54),
                    ),
                    ],
                  ),
                  ),
                ),
                ),
              const SizedBox(width: 12),
              const Icon(Icons.add, color: Colors.white, size: 28),
            ],
          ),

          const SizedBox(height: 12),

          /// FILTER ROW
          Row(
            children: [
              _FilterChip(
                child: Row(
                  children: const [
                    Icon(Icons.swap_vert, size: 18),
                    SizedBox(width: 6),
                    Icon(Icons.keyboard_arrow_down, size: 18),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _FilterChip(
                active: isGroupMode,
                onTap: onGroupToggle,
                child: Row(
                  children: [
                    if (isGroupMode) const Icon(Icons.close, size: 16),
                    if (isGroupMode) const SizedBox(width: 6),
                    const Text('Group'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final Widget child;
  final bool active;
  final VoidCallback? onTap;

  const _FilterChip({required this.child, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.grey.shade200 : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(22),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
          child: child,
        ),
      ),
    );
  }
}
