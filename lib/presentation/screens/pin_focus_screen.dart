import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/reusable_element.dart/app_loader.dart';
import 'package:pinterest/reusable_element.dart/nav_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pinterest/presentation/state_management/provider/dashboard_provider.dart';

class PinFocusScreen extends ConsumerStatefulWidget {
  final dynamic photo;

  const PinFocusScreen({super.key, required this.photo});

  @override
  ConsumerState<PinFocusScreen> createState() => _PinFocusScreenState();
}

class _PinFocusScreenState extends ConsumerState<PinFocusScreen>
    with TickerProviderStateMixin {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  bool _showExpandedAppBar = false;
  bool _sheetHidden = true; 
  bool _showNavbar = false;
  int _currentIndex = 0;
  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _sheetHidden = false);

      Future.delayed(const Duration(milliseconds: 16), () {
        if (!mounted) return;

        if (_sheetController.isAttached) {
          _sheetController.animateTo(
            0.4,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
          );
        }
      });
    });

    _sheetController.addListener(() {
      final size = _sheetController.size;

      setState(() {
        _sheetHidden = size <= 0.08;
        _showExpandedAppBar = size >= 0.85;
        _showNavbar = size >= 0.85;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final dashboard = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF8B5A2B),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            top: _sheetHidden
                ? (screen.height - (screen.height * 0.6)) /
                      2 
                : 0,

            left: 0,
            right: 0,
            child: AnimatedScale(
              scale: _sheetHidden ? 1.0 : 0.92,
              duration: const Duration(milliseconds: 420),
              child: CachedNetworkImage(
                imageUrl: widget.photo['src']['large'],
                height: screen.height * 0.6,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _roundedIcon(
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      _roundedIcon(icon: Icons.open_in_new, onTap: () {}),
                      const SizedBox(width: 8),
                      _roundedIcon(icon: Icons.more_horiz, onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildBottomSheet(context),

        
          if (_sheetHidden)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 24,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,

                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -6) {
                    if (_sheetController.isAttached) {
                      _sheetController.animateTo(
                        0.4,
                        duration: const Duration(milliseconds: 420),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  }
                },

                onTap: () {
                  if (_sheetController.isAttached) {
                    _sheetController.animateTo(
                      0.4,
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutCubic,
                    );
                  }
                },

                child: Column(
                  children: const [
                    Text(
                      "Swipe up to explore area",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    _DragPill(),
                  ],
                ),
              ),
            ),
        ],
      ),

      bottomNavigationBar: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _showNavbar
            ? PinterestBottomNav(
                key: const ValueKey('nav'),
                selectedIndex: _currentIndex,
                onTap: (i) {
                  setState(() => _currentIndex = i);
                },
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }

  Widget _roundedIcon({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return DraggableScrollableSheet(
      key: const ValueKey('sheet_visible'),
      controller: _sheetController,
      initialChildSize: 0.0,
      minChildSize: 0.0,
      maxChildSize: 1,
      snap: true,
      snapSizes: const [0.4, 1],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF6F3E1D), 
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              if (_showExpandedAppBar)
                SliverAppBar(
                  pinned: true,
                  backgroundColor: const Color(0xFF6F3E1D),
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, size: 28),
                    onPressed: () {
                      if (_sheetController.isAttached) {
                        _sheetController.animateTo(
                          0.4,
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    },
                  ),
                  title: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: widget.photo['src']['tiny'],
                      height: 32,
                      width: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                  centerTitle: true,
                  actions: const [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.more_horiz),
                    ),
                  ],
                ),

              if (dashboard.isLoading)
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childCount: 8,
                    itemBuilder: (context, i) {
                      return Shimmer.fromColors(
                        baseColor: Colors.brown.shade400,
                        highlightColor: Colors.amber.shade300,
                        child: Container(
                          height: i.isEven ? 220 : 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              if (!dashboard.isLoading)
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childCount: dashboard.photos.length,
                    itemBuilder: (context, index) {
                      final photo = dashboard.photos[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: photo['src']['medium'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),

              if (dashboard.isPaginating)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: PinterestPaginationLoader(),
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 1,
                  child: Builder(
                    builder: (context) {
                      notifier.loadMore();
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DragPill extends StatelessWidget {
  const _DragPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
