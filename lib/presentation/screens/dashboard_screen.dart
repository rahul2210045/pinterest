import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/data/local/board_model.dart';
import 'package:pinterest/presentation/screens/detial_screen.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';
import 'package:pinterest/presentation/state_management/provider/board_tab_provider.dart';
import 'package:pinterest/presentation/state_management/provider/dashboard_provider.dart';
import 'package:pinterest/presentation/widgets/animation/save_pin_animation.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/bottom_sheet.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/dashboard_tabs.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/pin_tile.dart';
import 'package:pinterest/presentation/widgets/shimmer/grdi_shimmer.dart';
import 'package:pinterest/reusable_element.dart/app_loader.dart';
import 'package:pinterest/reusable_element.dart/refresh_loader.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final ScrollController _controller;
  late final PageController _pageController;
  Timer? _paginationDebounce;
  int _lastPhotoCount = 0;
  bool _didAnimateForThisPage = false;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _paginationDebounce?.cancel();
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
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

  void _onScroll() {
    _lastScrollOffset = _controller.offset;

    final notifier = ref.read(dashboardProvider.notifier);
    final state = ref.read(dashboardProvider);

    if (_controller.position.pixels < -80 && !state.isRefreshing) {
      notifier.refresh();
    }

    if (_controller.position.pixels >
        _controller.position.maxScrollExtent - 400) {
      if (state.isPaginating || state.isLoading) return;

      _paginationDebounce?.cancel();
      _paginationDebounce = Timer(const Duration(milliseconds: 250), () {
        notifier.loadMore();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(boardTabProvider);
    final isForYouTab = selectedTab == 0;
    

    final dashboardState = ref.watch(dashboardProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentCount = dashboardState.photos.length;

      if (!dashboardState.isPaginating &&
          currentCount > _lastPhotoCount &&
          _controller.hasClients) {
        if (!_didAnimateForThisPage) {
          _didAnimateForThisPage = true;
          _controller.animateTo(
            (_lastScrollOffset + 160).clamp(
              0.0,
              _controller.position.maxScrollExtent,
            ),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          );
        }
      }

      if (dashboardState.isPaginating) {
        _didAnimateForThisPage = false;
      }

      _lastPhotoCount = currentCount;
    });

    final dashboardNotifier = ref.read(dashboardProvider.notifier);
    final boards = ref.watch(boardProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DashboardBoardTabs(
              onTabSelected: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              },
            ),

            if (dashboardState.isRefreshing) const PinterestRefreshLoader(),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(boardTabProvider.notifier).state = index;
                },
                itemCount: boards.length + 1,
                itemBuilder: (context, index) {
                  final isForYou = index == 0;
                  final isBoardTab = index > 0 && index <= boards.length;

                  return RefreshIndicator(
                    color: Colors.transparent,
                    backgroundColor: Colors.black,
                    onRefresh: dashboardNotifier.refresh,
                    child: CustomScrollView(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        if (isForYou && dashboardState.isLoading)
                          const SliverToBoxAdapter(child: ShimmerGrid()),

                        if (isForYou)
                          _dashboardGrid(
                            state: dashboardState,
                            context: context,
                            isForYouTab: true,
                          ),

                        if (isBoardTab) ...[
                          _boardContent(
                            board: boards[index - 1],
                            dashboardState: dashboardState,
                            context: context,
                          ),
                          _dashboardGrid(
                            state: dashboardState,
                            context: context,
                            isForYouTab: false,
                            currentBoard: boards[index - 1],
                          ),
                        ],
                        if (dashboardState.isPaginating)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 24,
                                bottom:
                                    MediaQuery.of(context).padding.bottom + 72,
                              ),
                              child: const Center(
                                child: PinterestPaginationLoader(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 
  SliverPadding _dashboardGrid({
    required DashboardState state,
    required BuildContext context,
    BoardModel? currentBoard,
    required bool isForYouTab,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childCount: state.photos.length,
        itemBuilder: (context, index) {
          final photo = state.photos[index];

          final alreadySaved =
              currentBoard?.pins.any(
                (p) => p.id.toString() == photo['id'].toString(),
              ) ??
              false;

          return PinTile(
            id: photo['id'].toString(),
            imageUrl: photo['src']['large'],
            aspectRatio: photo['width'] / photo['height'],
            onTap: () => openPinDetail(context, photo),

            showQuickSave: !isForYouTab,
            isSavedInitially: alreadySaved,

            onQuickSave: () {
              if (currentBoard == null) return;

              ref
                  .read(boardProvider.notifier)
                  .savePinToBoard(currentBoard, photo);

              playSavePinAnimation(
                context: context,
                imageUrl: photo['src']['large'],
              );
            },
            onMoreTap: () {
              openPinActionsSheet(context, photo, (boardName) async {
                await playSavePinAnimation(
                  context: context,
                  imageUrl: photo['src']['large'],
                );
              });
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
        SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            board.name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${board.pins.length} Pins ',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Your saves ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
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
