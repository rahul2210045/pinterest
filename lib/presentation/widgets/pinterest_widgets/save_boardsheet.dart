import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/data/local/board_model.dart';
import 'package:pinterest/presentation/screens/create_board_bottomsheet.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';
import 'package:pinterest/presentation/widgets/animation/save_pin_animation.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/board_button.dart';

class SaveToBoardBottomSheet extends ConsumerWidget {
  final dynamic photo;

  const SaveToBoardBottomSheet({super.key, required this.photo});

  static const List<String> _suggestedBoardNames = [
    'Dream Home',
    'Travel Goals',
    'Workout',
    'Recipes',
    'Fashion Inspo',
    'Art Ideas',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boards = ref.watch(boardProvider);

    final existingNames = boards.map((b) => b.name.toLowerCase()).toSet();

    final suggestions = _suggestedBoardNames
        .where((name) => !existingNames.contains(name.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _SaveToBoardHeader(),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 8),

                    if (boards.isNotEmpty) ...[
                      const BoardSectionTitle(title: 'My boards'),
                      const SizedBox(height: 8),
                      ...boards.map(
                        (board) => BoardListTile(
                          board: board,
                          onTap: () {
                            ref
                                .read(boardProvider.notifier)
                                .savePinToBoard(board, photo);
                            Navigator.pop(context);
                            playSavePinAnimation(
                              context: context,
                              imageUrl: photo['src']['large'],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white24),
                    ],

                    if (suggestions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const BoardSectionTitle(title: 'Suggested'),
                      const SizedBox(height: 8),
                      ...suggestions.map(
                        (name) => SuggestedBoardTile(
                          name: name,
                          photo: photo,
                          onTap: () {
                            ref
                                .read(boardProvider.notifier)
                                .createBoard(name: name, photo: photo);

                            Navigator.pop(context);
                            playSavePinAnimation(
                              context: context,
                              imageUrl: photo['src']['large'],
                            );
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),

              CreateBoardButton(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) {
                      return CreateBoardBottomSheet(
                        photo: photo,
                        onComplete: () async {
                          await playSavePinAnimation(
                            context: context,
                            imageUrl: photo['src']['large'],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class BoardSectionTitle extends StatelessWidget {
  final String title;

  const BoardSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class BoardListTile extends StatelessWidget {
  final BoardModel board;
  final VoidCallback onTap;

  const BoardListTile({super.key, required this.board, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final preview = board.pins.isNotEmpty ? board.pins.first.tiny : null;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: preview != null
            ? Image.network(preview, width: 48, height: 48, fit: BoxFit.cover)
            : Container(width: 48, height: 48, color: Colors.grey.shade800),
      ),
      title: Text(
        board.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${board.pins.length} Pins',
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}

class SuggestedBoardTile extends StatelessWidget {
  final String name;
  final dynamic photo;
  final VoidCallback onTap;

  const SuggestedBoardTile({
    super.key,
    required this.name,
    required this.photo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          photo['src']['tiny'],
          width: 48,
          height: 48,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: const Text(
        'Suggested board',
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}

class _SaveToBoardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Save to board',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}
