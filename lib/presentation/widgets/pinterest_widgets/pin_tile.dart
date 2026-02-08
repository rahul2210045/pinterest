import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PinTile extends StatefulWidget {
  final String id;
  final String imageUrl;
  final double aspectRatio;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  final void Function(void Function(String board))? registerSaveHandler;

  const PinTile({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.aspectRatio,
    this.onTap,
    this.onMoreTap,
    this.registerSaveHandler,
  });

  @override
  State<PinTile> createState() => _PinTileState();
}

class _PinTileState extends State<PinTile> {
  bool _saved = false;
  String _boardName = '';

  @override
  void initState() {
    super.initState();

    widget.registerSaveHandler?.call(showSaved);
  }

  void showSaved(String board) {
    setState(() {
      _saved = true;
      _boardName = board;
    });

   
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: widget.aspectRatio,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              if (_saved)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

              if (_saved)
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Saved to $_boardName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onMoreTap,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.only(top: 4, right: 4),
                child: Icon(Icons.more_horiz, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

