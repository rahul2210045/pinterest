import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PinTile extends StatefulWidget {
  final String id;
  final String imageUrl;
  final double aspectRatio;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  final bool showQuickSave;
  final bool isSavedInitially;
  final VoidCallback? onQuickSave;

  const PinTile({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.aspectRatio,
    this.onTap,
    this.onMoreTap,
    this.showQuickSave = false,
    this.isSavedInitially = false,
    this.onQuickSave,
  });

  @override
  State<PinTile> createState() => _PinTileState();
}

class _PinTileState extends State<PinTile> {
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _saved = widget.isSavedInitially;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: widget.aspectRatio,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            if (widget.showQuickSave)
              Positioned(
                left: 8,
                bottom: 8,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (_saved) return;
                    widget.onQuickSave?.call();
                    setState(() => _saved = true);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _saved ? Colors.white : Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _saved ? Icons.check : Icons.push_pin,
                      size: 18,
                      color: _saved ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),

        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: widget.onMoreTap,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.only(top: 6, right: 6),
              child: Icon(
                Icons.more_horiz,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
