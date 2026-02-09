import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';

class CreateBoardBottomSheet extends ConsumerStatefulWidget {
  final dynamic photo;
  final VoidCallback onComplete;

  const CreateBoardBottomSheet({
    super.key,
    required this.photo,
    required this.onComplete,
  });

  @override
  ConsumerState<CreateBoardBottomSheet> createState() =>
      _CreateBoardBottomSheetState();
}

class _CreateBoardBottomSheetState
    extends ConsumerState<CreateBoardBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isSecret = false;
  bool _collabAdded = false;

  @override
  void initState() {
    super.initState();
    _controller.text =
        widget.photo['alt']?.toString().split(' ').take(3).join(' ') ??
            'My board';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2B),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Create board',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _createBoard,
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// PREVIEW CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: widget.photo['src']['medium'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        _emptyBox(),
                        const SizedBox(height: 6),
                        _emptyBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// BOARD NAME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name your board',
                      style: TextStyle(color: Colors.white54),
                    ),
                    TextField(
                      controller: _controller,
                      maxLength: 50,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// COLLABORATORS
            _sectionTitle('Collaborators'),
            _collaboratorTile(
              name: 'Ishika shukla',
              username: '@ishs4873',
            ),
            _collaboratorTile(
              name: 'Aesthetics',
              username: '@aesthetics',
            ),
            _addCollaborator(),

            const SizedBox(height: 24),

            /// VISIBILITY
            _sectionTitle('Visibility'),
            SwitchListTile(
              activeColor: Colors.deepPurple,
              value: _isSecret,
              onChanged: (v) => setState(() => _isSecret = v),
              title: const Text(
                'Keep this board secret',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'If you don’t want others to see this board',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _createBoard() {
  ref.read(boardProvider.notifier).createBoard(
    name: _controller.text.trim(),
    photo: widget.photo,
  );

  Navigator.pop(context);
  widget.onComplete();
}



  Widget _emptyBox() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _collaboratorTile({
    required String name,
    required String username,
  }) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.grey),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(username, style: const TextStyle(color: Colors.white54)),
      trailing: TextButton(
        onPressed: () => setState(() => _collabAdded = !_collabAdded),
        child: Text(
          _collabAdded ? 'Added' : 'Add',
          style: TextStyle(
            color: _collabAdded ? Colors.grey : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _addCollaborator() {
    return ListTile(
      leading: const Icon(Icons.person_add, color: Colors.white),
      title: const Text(
        'Add collaborators',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
