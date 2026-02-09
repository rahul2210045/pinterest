import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/presentation/screens/detial_screen.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';
import 'package:pinterest/presentation/state_management/provider/board_tab_provider.dart';
import 'package:pinterest/presentation/state_management/provider/dashboard_provider.dart';
import 'package:pinterest/presentation/widgets/animation/save_pin_animation.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/bottom_sheet.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/dashboard_tabs.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/pin_tile.dart';
import 'package:pinterest/presentation/widgets/shimmer/grdi_shimmer.dart';
import 'package:pinterest/reusable_element.dart/nav_bar.dart';
import 'package:pinterest/reusable_element.dart/refresh_loader.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final ScrollController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final notifier = ref.read(dashboardProvider.notifier);

    if (_controller.position.pixels < -80 &&
        !ref.read(dashboardProvider).isRefreshing) {
      notifier.refresh();
    }

    if (_controller.position.pixels >
        _controller.position.maxScrollExtent - 400) {
      notifier.loadMore();
    }
  }

  void openPinActionsSheet(
    BuildContext context,
    dynamic photo,
    void Function(String) onBoardSelected,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return PinActionBottomSheet(
          photo: photo,
          rootContext: context,
          onBoardSelected: onBoardSelected,
        );
      },
    );
  }

  void openPinDetail(BuildContext context, dynamic photo) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, __, ___) => PinDetailScreen(photo: photo),
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final dashboardNotifier = ref.read(dashboardProvider.notifier);

    final selectedTab = ref.watch(boardTabProvider);
    final boards = ref.watch(boardProvider);

    final bool isForYou = selectedTab == 0;
    final bool isBoardTab = selectedTab > 0 && selectedTab <= boards.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DashboardBoardTabs(),
            if (dashboardState.isRefreshing) const PinterestRefreshLoader(),

            Expanded(
              child: RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.black,
                onRefresh: dashboardNotifier.refresh,
                child: CustomScrollView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    if (isForYou && dashboardState.isLoading)
                      const SliverToBoxAdapter(child: ShimmerGrid()),

                    if (isForYou)
                      _dashboardGrid(state: dashboardState, context: context),
                    if (isBoardTab) ...[
                      _boardContent(
                        board: boards[selectedTab - 1],
                        dashboardState: dashboardState,
                        context: context,
                      ),

                      _dashboardGrid(state: dashboardState, context: context),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PinterestBottomNav(
        selectedIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
        },
      ),
    );
  }

  SliverPadding _dashboardGrid({
    required DashboardState state,
    required BuildContext context,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childCount: state.photos.length + (state.isPaginating ? 1 : 0),
        itemBuilder: (context, index) {
          final photo = state.photos[index];
          return Builder(
            builder: (tileContext) {
              void Function(String board)? saveUI;

              return PinTile(
                id: photo['id'].toString(),
                imageUrl: photo['src']['large'],
                aspectRatio: photo['width'] / photo['height'],
                onTap: () => openPinDetail(context, photo),
                registerSaveHandler: (fn) => saveUI = fn,
                onMoreTap: () {
                  openPinActionsSheet(context, photo, (board) async {
                    saveUI?.call(board);
                    await playSavePinAnimation(
                      context: context,
                      imageUrl: photo['src']['large'],
                    );
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  SliverList _boardContent({
    required board,
    required DashboardState dashboardState,
    required BuildContext context,
  }) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            board.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${board.pins.length} Pins · Your saves',
            style: const TextStyle(color: Colors.white70),
          ),
        ),

        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: board.pins.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final pin = board.pins[i];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(pin.tiny, width: 90, fit: BoxFit.cover),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'More ideas for this board',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 12),
      ]),
    );
  }

}
