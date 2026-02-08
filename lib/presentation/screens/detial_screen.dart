import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PinDetailScreen extends StatelessWidget {
  final dynamic photo;

  const PinDetailScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final aspectRatio = photo['width'] / photo['height'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: aspectRatio,
                  child: CachedNetworkImage(
                    imageUrl: photo['src']['large'],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.favorite_border,
                      color: Colors.white),
                  const SizedBox(width: 16),
                  const Icon(Icons.chat_bubble_outline,
                      color: Colors.white),
                  const SizedBox(width: 16),
                  const Icon(Icons.share, color: Colors.white),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {},
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
