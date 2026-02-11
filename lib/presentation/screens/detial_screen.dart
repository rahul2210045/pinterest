import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/reusable_element.dart/app_loader.dart';
import 'package:shimmer/shimmer.dart';

class PinDetailScreen extends StatefulWidget {
  final dynamic photo;

  const PinDetailScreen({super.key, required this.photo});

  @override
  State<PinDetailScreen> createState() => _PinDetailScreenState();
}

class _PinDetailScreenState extends State<PinDetailScreen> {
  final ScrollController _controller = ScrollController();
  bool isLoading = true;
  bool isPaginating = false;
  bool showExploreShimmer = true;

  List relatedPhotos = [];

  bool showBottomNav = false;
  int _currentIndex = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchRelated();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _controller.offset;

    if (offset > 120 && !showBottomNav) {
      setState(() => showBottomNav = true);
    } else if (offset <= 120 && showBottomNav) {
      setState(() => showBottomNav = false);
    }

    if (_controller.position.pixels >
            _controller.position.maxScrollExtent - 400 &&
        !isPaginating) {
      fetchMore();
    }
  }

  Future<void> fetchRelated() async {
    final query =
        widget.photo['alt'] ?? widget.photo['photographer'] ?? "wallpaper";

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      relatedPhotos = List.generate(10, (_) => widget.photo);

      isLoading = false;
      showExploreShimmer = false;
    });
  }

  Future<void> fetchMore() async {
    setState(() => isPaginating = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      relatedPhotos.addAll(List.generate(6, (i) => widget.photo));
      isPaginating = false;
      page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.photo['width'] / widget.photo['height'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: InkWell(
                    onTap: () {
                      context.push('/pin-focus', extra: widget.photo);
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.photo['src']['large'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _iconText(Icons.favorite_border, "10"),
                      _iconText(Icons.chat_bubble_outline, "1"),
                      const Icon(Icons.share, color: Colors.white),
                      const SizedBox(width: 12),
                      const Icon(Icons.more_horiz, color: Colors.white),
                      const Spacer(),
                      _saveButton(
                        onTap: () {
                        
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.green,
                        child: Text("G", style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Ggsharmahub",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: showExploreShimmer
                      ? _exploreTitleShimmer()
                      : Text(
                          "More to explore",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              if (isLoading)
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (_, index) {
                      final heights = [160.0, 220.0, 180.0, 260.0];
                      final height = heights[index % heights.length];

                      return _staggeredShimmer(height);
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (_, i) {
                      final p = relatedPhotos[i];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: p['src']['large'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    childCount: relatedPhotos.length,
                  ),
                ),

              if (isPaginating)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: PinterestPaginationLoader(),
                    ),
                  ),
                ),
            ],
          ),

          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),

      // bottomNavigationBar: AnimatedContainer(
      //   duration: const Duration(milliseconds: 400),
      //   height: showBottomNav ? 70 : 0,
      //   child: showBottomNav
      //       ? PinterestBottomNav(
      //           selectedIndex: _currentIndex,
      //           onTap: (i) {
      //             setState(() => _currentIndex = i);
      //           },
      //         )
      //       : null,
      // ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _saveButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Save",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

 

  Widget _shimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade800,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _exploreTitleShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade800,
      child: Container(
        height: 22,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _staggeredShimmer(double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade800,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
