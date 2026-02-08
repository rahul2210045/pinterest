import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class PinterestFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: 20, 
      itemBuilder: (context, index) {
        return PinCard(index: index);
      },
    );
  }
}

class PinCard extends StatelessWidget {
  final int index;
  const PinCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: "https://images.pexels.com/photos/...", 
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(height: (index % 3 + 2) * 50, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Icon(Icons.more_horiz, size: 18, color: Colors.white70),
      ],
    );
  }
}