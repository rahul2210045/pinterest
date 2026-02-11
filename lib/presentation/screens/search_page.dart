import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pinterest/presentation/models/search_input_arg.dart';
import 'package:pinterest/presentation/state_management/provider/search_provider.dart';
import 'package:pinterest/reusable_element.dart/app_loader.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  int _index = 0;
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!_pageController.hasClients) return;

      final next = (_currentPage + 1) % 7;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _searchBar(),

          if (state.isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: PinterestPaginationLoader(), 
              ),
            ),

          if (!state.isLoading) ...[
            _carousel(state),
            _featuredCollections(state),
            ..._ideaSections(state),
          ],
        ],
      ),
    );
  }

  

  SliverAppBar _searchBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.black,
      titleSpacing: 0,
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          context.push('/search-input');
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.white54),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Search for ideas",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ),
              Icon(Icons.camera_alt_outlined, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _carousel(SearchState state) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 360,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: state.carousel.length,
              onPageChanged: (i) {
                setState(() => _currentPage = i);
              },
              itemBuilder: (_, i) {
                final p = state.carousel[i];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: p['src']['portrait'],
                      fit: BoxFit.cover,
                    ),

                    Positioned(
                      left: 16,
                      bottom: 40,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['photographer'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p['alt'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (i) {
                  final isActive = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _featuredCollections(SearchState state) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Explore featured boards',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Ideas you might like',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 260,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: state.collections.length,
              itemBuilder: (_, i) {
                final c = state.collections[i];
                return Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _collectionCollage(c.photos),
                      const SizedBox(height: 8),
                      Text(
                        c.info['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${c.info['media_count']} Pins',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
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
    );
  }

  Widget _collectionCollage(List<dynamic> photos) {
    if (photos.length < 3) {
      return const SizedBox.shrink();
    }

    final img1 = photos[0]['src']?['medium'];
    final img2 = photos[1]['src']?['medium'];
    final img3 = photos[2]['src']?['medium'];

    if (img1 == null || img2 == null || img3 == null) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 160,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: SizedBox.expand(
                child: CachedNetworkImage(
                  imageUrl: img1,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: Colors.grey.shade800),
                  errorWidget: (_, __, ___) =>
                      Container(color: Colors.grey.shade700),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: CachedNetworkImage(
                        imageUrl: img2,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade800),
                        errorWidget: (_, __, ___) =>
                            Container(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: CachedNetworkImage(
                        imageUrl: img3,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade800),
                        errorWidget: (_, __, ___) =>
                            Container(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _ideaSections(SearchState state) {
    return state.ideas.entries.map((e) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ideaHeader(
                e.key,
                onTap: () {
                 
                  context.push(
                    '/search-result',
                    extra: {
                      'query': e.key,
                      'args': SearchInputArgs(source: SearchSource.unknown),
                    },
                  );
                },
              ),
              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 140,
                  child: Row(
                    children: List.generate(e.value.length * 2 - 1, (i) {
                      // Divider
                      if (i.isOdd) {
                        return Container(width: 2, color: Colors.black);
                      }

                      final index = i ~/ 2;
                      final p = e.value[index];

                      return Expanded(
                        child: SizedBox.expand(
                          child: CachedNetworkImage(
                            imageUrl: p['src']['medium'],
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: Colors.grey.shade900),
                            errorWidget: (_, __, ___) =>
                                Container(color: Colors.grey.shade800),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

 
  Widget _ideaHeader(String title, {required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.all(Radius.circular(12)),

            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
