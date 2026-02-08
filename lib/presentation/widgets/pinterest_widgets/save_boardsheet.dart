import 'package:flutter/material.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/board_button.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/board_list.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/suggested_board.dart';

class SaveToBoardBottomSheet extends StatelessWidget {
  final dynamic photo;

  const SaveToBoardBottomSheet({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.45,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
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
                    ...boardsSection(context),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),
                    ...suggestedBoardsSection(context),
                    const SizedBox(height: 80), 
                  ],
                ),
              ),

              const CreateBoardButton(),
            ],
          ),
        );
      },
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
