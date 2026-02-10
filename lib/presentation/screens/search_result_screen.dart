import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/presentation/models/search_input_arg.dart';
import 'package:pinterest/presentation/state_management/provider/all_saved_pins_provider.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';
import 'package:pinterest/presentation/state_management/provider/search_bar_provider.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/board_card.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/local_search.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/pin_tile.dart';
import 'package:pinterest/reusable_element.dart/app_loader.dart';
import 'package:pinterest/reusable_element.dart/nav_bar.dart';

// class SearchResultScreen extends ConsumerStatefulWidget {
//   final String query;
//   final SearchInputArgs args;

//   const SearchResultScreen({
//     super.key,
//     required this.query,
//     required this.args,
//   });

//   @override
//   ConsumerState<SearchResultScreen> createState() =>
//       _SearchResultScreenState();
// }

class SearchResultScreen extends ConsumerStatefulWidget {
  final String query;
  final SearchInputArgs args;

  const SearchResultScreen({
    super.key,
    required this.query,
    required this.args,
  });

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  final ScrollController _controller = ScrollController();
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    print(
      'SearchResultScreen initialized with query: from source: ${widget.args.source}',
    );
    _controller.addListener(() {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - 400) {
        ref.read(searchResultProvider(widget.query).notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// 🔑 CONTEXT CHECK
    final isContextualSearch =
        widget.args.source == SearchSource.boards ||
        widget.args.source == SearchSource.profile;

    /// API STATE
    final apiState = ref.watch(searchResultProvider(widget.query));

    /// LOCAL DATA
    final boards = ref.watch(boardProvider);
    final allPins = ref.watch(allSavedPinsProvider);

    final matchedBoards = searchBoards(boards, widget.query);
    final matchedPins = searchPins(allPins, widget.query);

    final hasLocalResults = matchedBoards.isNotEmpty || matchedPins.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,

      /// 🚫 NO APP BAR FOR CONTEXTUAL SEARCH
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          /// ===============================
          /// CONTEXTUAL SEARCH (BOARDS / PROFILE)
          /// ===============================
          if (isContextualSearch) ...[
            const SliverPadding(padding: EdgeInsets.only(top: 40)),

            /// BOARDS
            if (matchedBoards.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Results from your boards',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      BoardCard(board: matchedBoards.first),
                    ],
                  ),
                ),
              ),

            /// PINS
            if (matchedPins.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childCount: matchedPins.length,
                  itemBuilder: (_, i) {
                    final pin = matchedPins[i];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(pin.large, fit: BoxFit.cover),
                    );
                  },
                ),
              ),

            /// END TEXT
            if (hasLocalResults)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    "You've reached the end of your saved Pins about ${widget.query}",
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            if (!hasLocalResults)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
                  child: Text(
                    "Can’t find any saved Pins for ${widget.query}.",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: Divider(color: Colors.white24)),

            /// MORE IDEAS HEADER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Column(
                  children: [
                    const Text(
                      'More Ideas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Here are some other ideas you might like about ${widget.query}',
                      style: const TextStyle(color: Colors.white54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],

          /// ===============================
          /// NORMAL SEARCH (DEFAULT)
          /// ===============================
          if (!isContextualSearch) ...[
            /// ⬇️ USE YOUR OLD NORMAL SEARCH UI HERE
            /// (SliverAppBar + Filter chips + Grid)
            /// KEEP YOUR COMMENTED CODE AS-IS
          ],

          /// ===============================
          /// API GRID (USED BY BOTH)
          /// ===============================
          if (apiState.isInitialLoading)
            const SliverToBoxAdapter(child: SearchShimmer()),

          if (!apiState.isInitialLoading)
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childCount: apiState.photos.length,
                itemBuilder: (_, i) {
                  final p = apiState.photos[i];
                  return PinTile(
                    id: p['id'].toString(),
                    imageUrl: p['src']['large'],
                    aspectRatio: p['width'] / p['height'],
                  );
                },
              ),
            ),

          if (apiState.isPaginating)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: PinterestPaginationLoader()),
              ),
            ),
        ],
      ),

      bottomNavigationBar: PinterestBottomNav(
        selectedIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
//   final ScrollController _controller = ScrollController();
//   int _currentIndex = 1;

//   @override
//   void initState() {
//     super.initState();

//     _controller.addListener(() {
//       if (_controller.position.pixels >
//           _controller.position.maxScrollExtent - 400) {
//         ref.read(searchResultProvider(widget.query).notifier).loadMore();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isContextualSearch = widget.args.source == SearchSource.profile;

//     /// API STATE
//     final apiState = ref.watch(searchResultProvider(widget.query));

//     /// LOCAL DATA
//     final boards = ref.watch(boardProvider);
//     final allPins = ref.watch(allSavedPinsProvider);

//     final matchedBoards = searchBoards(boards, widget.query);
//     final matchedPins = searchPins(allPins, widget.query);

//     final hasLocalResults = matchedBoards.isNotEmpty || matchedPins.isNotEmpty;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: CustomScrollView(
//         controller: _controller,
//         slivers: [
//           /// ===== LOCAL RESULTS =====
//           if (hasLocalResults) ...[
//             const SliverPadding(padding: EdgeInsets.only(top: 40)),

//             /// BOARDS
//             if (matchedBoards.isNotEmpty)
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Results from your boards',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       BoardCard(board: matchedBoards.first),
//                     ],
//                   ),
//                 ),
//               ),

//             /// PINS
//             if (matchedPins.isNotEmpty)
//               SliverPadding(
//                 padding: const EdgeInsets.all(12),
//                 sliver: SliverMasonryGrid.count(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 12,
//                   crossAxisSpacing: 12,
//                   childCount: matchedPins.length,
//                   itemBuilder: (_, i) {
//                     final pin = matchedPins[i];
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(18),
//                       child: Image.network(pin.large, fit: BoxFit.cover),
//                     );
//                   },
//                 ),
//               ),

//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 24),
//                 child: Text(
//                   "You've reached the end of your saved Pins about ${widget.query}",
//                   style: const TextStyle(color: Colors.white54, fontSize: 13),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),

//             const SliverToBoxAdapter(child: Divider(color: Colors.white24)),
//           ],

//           /// ===== NO LOCAL RESULTS =====
//           if (!hasLocalResults)
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
//                 child: Text(
//                   "Can’t find any saved Pins for ${widget.query}.",
//                   style: const TextStyle(color: Colors.white70, fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),

//           /// ===== MORE IDEAS HEADER =====
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
//               child: Column(
//                 children: [
//                   const Text(
//                     'More Ideas',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Here are some other ideas you might like about ${widget.query}',
//                     style: const TextStyle(color: Colors.white54),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           /// ===== API SHIMMER =====
//           if (apiState.isInitialLoading)
//             const SliverToBoxAdapter(child: SearchShimmer()),

//           /// ===== API GRID =====
//           if (!apiState.isInitialLoading)
//             SliverPadding(
//               padding: const EdgeInsets.all(12),
//               sliver: SliverMasonryGrid.count(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childCount: apiState.photos.length,
//                 itemBuilder: (_, i) {
//                   final p = apiState.photos[i];
//                   return PinTile(
//                     id: p['id'].toString(),
//                     imageUrl: p['src']['large'],
//                     aspectRatio: p['width'] / p['height'],
//                   );
//                 },
//               ),
//             ),

//           /// ===== PAGINATION LOADER =====
//           if (apiState.isPaginating)
//             const SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.all(24),
//                 child: Center(child: PinterestPaginationLoader()),
//               ),
//             ),
//         ],
//       ),

//       bottomNavigationBar: PinterestBottomNav(
//         selectedIndex: _currentIndex,
//         onTap: (i) => setState(() => _currentIndex = i),
//       ),
//     );
//   }
// }

// class SearchResultScreen extends ConsumerStatefulWidget {
//   final String query;
//   const SearchResultScreen({super.key, required this.query});

//   @override
//   ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
// }

// class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
//   final ScrollController _controller = ScrollController();
//   bool _showCompactChip = false;
//   int _currentIndex = 1;

//   @override
//   void initState() {
//     super.initState();

//     _controller.addListener(() {
//       final offset = _controller.offset;

//       // 🔥 Toggle compact chip
//       if (offset > 120 && !_showCompactChip) {
//         setState(() => _showCompactChip = true);
//       } else if (offset < 80 && _showCompactChip) {
//         setState(() => _showCompactChip = false);
//       }

//       // Pagination
//       if (_controller.position.pixels >
//           _controller.position.maxScrollExtent - 400) {
//         ref.read(searchResultProvider(widget.query).notifier).loadMore();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(searchResultProvider(widget.query));

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           CustomScrollView(
//             controller: _controller,
//             slivers: [
//               SliverAppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: Colors.black,
//                 expandedHeight: 150,
//                 floating: false,
//                 pinned: false,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         _SearchBarExpanded(query: widget.query),
//                         const SizedBox(height: 12),
//                         if (!state.isInitialLoading)
//                           _FilterChipsRow(photos: state.photos),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               /// INITIAL SHIMMER
//               if (state.isInitialLoading)
//                 const SliverToBoxAdapter(child: SearchShimmer())
//               else
//                 _SearchGrid(state),

//               /// PAGINATION LOADER
//               if (state.isPaginating)
//                 const SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.all(24),
//                     child: Center(child: PinterestPaginationLoader()),
//                   ),
//                 ),
//             ],
//           ),

//           Positioned(
//             top: 40, // 🔒 fixed position (no movement)
//             left: 0,
//             right: 0,
//             child: Center(
//               child: AnimatedOpacity(
//                 duration: const Duration(milliseconds: 220),
//                 curve: Curves.easeOut,
//                 opacity: _showCompactChip ? 1 : 0,
//                 child: AnimatedScale(
//                   duration: const Duration(milliseconds: 220),
//                   curve: Curves.easeOutBack,
//                   scale: _showCompactChip ? 1 : 0.95,
//                   child: IgnorePointer(
//                     ignoring: !_showCompactChip,
//                     child: _SearchChipFloating(query: widget.query),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: PinterestBottomNav(
//         selectedIndex: _currentIndex,
//         onTap: (i) {
//           setState(() => _currentIndex = i);
//         },
//       ),
//     );
//   }
// }

class _SearchBarExpanded extends StatelessWidget {
  final String query;
  const _SearchBarExpanded({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              query,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.camera_alt_outlined, color: Colors.white70),
        ],
      ),
    );
  }
}

class _SearchChipFloating extends StatelessWidget {
  final String query;
  const _SearchChipFloating({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Icon(Icons.search, color: Colors.white70, size: 18),
          // const SizedBox(width: 8),
          Text(
            query,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  final List<dynamic> photos;

  const _FilterChipsRow({required this.photos});

  @override
  Widget build(BuildContext context) {
    final filters = [
      'Wallpaper',
      'Aesthetic',
      'Pfp',
      'Tattoo',
      'Drawing',
      'Stickers',
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          if (i == 0) {
            return Container(
              width: 48,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.tune, color: Colors.white),
            );
          }

          final image = photos.isNotEmpty ? photos[i % photos.length] : null;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                if (image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image['src']['tiny'],
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  filters[i - 1],
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

SliverPadding _SearchGrid(SearchResultState state) {
  return SliverPadding(
    padding: const EdgeInsets.all(10),
    sliver: SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childCount: state.photos.length,
      itemBuilder: (_, i) {
        final p = state.photos[i];
        return PinTile(
          id: p['id'].toString(),
          imageUrl: p['src']['large'],
          aspectRatio: p['width'] / p['height'],
        );
      },
    ),
  );
}

class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          8,
          (i) => Container(
            width: MediaQuery.of(context).size.width / 2 - 20,
            height: i.isEven ? 220 : 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
