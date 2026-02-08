import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/save_boardsheet.dart';

class PinActionBottomSheet extends StatelessWidget {
  final dynamic photo;
   final BuildContext rootContext;
   final void Function(String boardName) onBoardSelected;

  const PinActionBottomSheet({super.key, required this.photo,  required this.rootContext,required this.onBoardSelected,});
Future<String?> openSaveToBoardSheet(
  BuildContext context,
  dynamic photo,
) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (_) => SaveToBoardBottomSheet(photo: photo),
  );
}



  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.35,
      maxChildSize: 0.65,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _ActionList(
                controller: scrollController,
                onSaveTap: ()  async {
                  Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 220));

    final board = await openSaveToBoardSheet(rootContext, photo);

    if (board != null) {
      onBoardSelected(board);
    }
    
                },
              ),

              _FloatingPinPreview(photo: photo),
            ],
          ),
        );
      },
    );
  }
}
class _FloatingPinPreview extends StatelessWidget {
  final dynamic photo;

  const _FloatingPinPreview({required this.photo});

  @override
  Widget build(BuildContext context) {
    final aspectRatio = photo['width'] / photo['height'];

    return Positioned(
      top: -80, 
      left: 0,
      right: 0,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 120,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CachedNetworkImage(
                imageUrl: photo['src']['large'],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionList extends StatelessWidget {
  final ScrollController controller;
  final VoidCallback onSaveTap;

  const _ActionList({
    required this.controller,
    required this.onSaveTap,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: ListView(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 16),

          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                'This Pin is inspired by your recent activity',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _ActionItem(
            icon: Icons.push_pin,
            label: 'Save',
            onTap: onSaveTap,
          ),
          _ActionItem(
            icon: Icons.share,
            label: 'Share',
            onTap: () {},
          ),
          _ActionItem(
            icon: Icons.download,
            label: 'Download image',
            onTap: () {},
          ),
          _ActionItem(
            icon: Icons.favorite_border,
            label: 'See more like this',
            onTap: () {},
          ),
          _ActionItem(
            icon: Icons.visibility_off,
            label: 'See less like this',
            onTap: () {},
          ),
          _ActionItem(
            icon: Icons.flag,
            label: 'Report Pin',
            onTap: () {},
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
