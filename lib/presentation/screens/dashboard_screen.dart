import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/core/key/global_key.dart';
import 'package:pinterest/presentation/screens/detial_screen.dart';
import 'package:pinterest/presentation/state_management/provider/dashboard_provider.dart';
import 'package:pinterest/presentation/widgets/animation/confetti_painter.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/bottom_sheet.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/pin_tile.dart';
import 'package:pinterest/presentation/widgets/shimmer/grdi_shimmer.dart';
import 'package:pinterest/reusable_element.dart/app_bar.dart';
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



Future<void> handleSaveComplete({
  required BuildContext context,
  required Offset start,
  required String imageUrl,
}) async {
  final profileBox =
      profileTabKey.currentContext!.findRenderObject() as RenderBox;
  final end = profileBox.localToGlobal(
    Offset(profileBox.size.width / 2, profileBox.size.height / 2),
  );

  final controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 420),
  );

  final animation =
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) {
      return AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          final pos = Offset.lerp(start, end, animation.value)!;
          final scale =
              Tween(begin: 1.0, end: 0.2).transform(animation.value);

          return Positioned(
            left: pos.dx,
            top: pos.dy,
            child: Transform.scale(
              scale: scale,
              child: Image.network(imageUrl, width: 120),
            ),
          );
        },
      );
    },
  );

  Overlay.of(context).insert(entry);
  await controller.forward();
  entry.remove();
  controller.dispose();

  showConfetti(context, end);
}


  void showConfetti(BuildContext context, Offset center) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: ConfettiPainter(center)),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 350), () {
      entry.remove();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final notifier = ref.read(dashboardProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeTopChips(),
            if (state.isRefreshing) const PinterestRefreshLoader(),

            Expanded(
              child: RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.black,
                onRefresh: notifier.refresh,
                child: CustomScrollView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    if (state.isLoading)
                      const SliverToBoxAdapter(child: ShimmerGrid()),

                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childCount:
                            state.photos.length + (state.isPaginating ? 1 : 0),
                        itemBuilder: (context, index) {
  final photo = state.photos[index];
return Builder(
  builder: (tileContext) {
    late void Function(String) saveHandler;

    return PinTile(
      id: photo['id'].toString(),
      imageUrl: photo['src']['large'],
      aspectRatio: photo['width'] / photo['height'],
      onTap: () => openPinDetail(context, photo),
      registerSaveHandler: (fn) => saveHandler = fn,
      onMoreTap: () {
        openPinActionsSheet(
          context,
          photo,
          (board) {
            saveHandler(board);

            final translation = tileContext
                .findRenderObject()!
                .getTransformTo(null)
                .getTranslation();
            
            handleSaveComplete(
              context: context,
              start: Offset(translation.x, translation.y),
              imageUrl: photo['src']['large'],
            );
          },
        );
      },
    );
  },
);

},

                      ),
                    ),
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
          _currentIndex = i;
        },
      ),
    );
  }
}
