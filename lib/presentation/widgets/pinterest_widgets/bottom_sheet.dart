import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/save_boardsheet.dart';

class PinActionBottomSheet extends StatelessWidget {
  final dynamic photo;
  final BuildContext rootContext;
  final void Function(String boardName) onBoardSelected;

  const PinActionBottomSheet({
    super.key,
    required this.photo,
    required this.rootContext,
    required this.onBoardSelected,
  });

  Future<String?> openSaveToBoardSheet(BuildContext context, dynamic photo) {
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
    final height = MediaQuery.of(context).size.height * 0.40;

    return SizedBox(
      height: height,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _ActionList(
              onSaveTap: () async {
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
      ),
    );
  }
}

class _FloatingPinPreview extends StatelessWidget {
  final dynamic photo;

  const _FloatingPinPreview({required this.photo});

  @override
  Widget build(BuildContext context) {
    final aspectRatio = photo['width'] / photo['height'];

    const double imageWidth = 120;
    const double overlapDepth = 60;

    final double imageHeight = imageWidth / aspectRatio;
    final double topOffset = overlapDepth - imageHeight;

    return Positioned(
      top: topOffset, 
      left: 0,
      right: 0,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: imageWidth,
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
  final VoidCallback onSaveTap;

  const _ActionList({required this.onSaveTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0), 
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 16),

          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'This Pin is inspired by your recent activity',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              // ),
            ),
          ),

          _ActionItem(icon: Icons.push_pin, label: 'Save', onTap: onSaveTap),
          _ActionItem(icon: Icons.share, label: 'Share', onTap: () {}),
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
          _ActionItem(icon: Icons.flag, label: 'Report Pin', onTap: () {}),

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
      dense: true, 
      visualDensity: const VisualDensity(
        vertical: -3, 
      ),
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white, size: 16),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: onTap,
    );
  }
}

