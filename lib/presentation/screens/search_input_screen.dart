// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/models/search_input_arg.dart';
// import 'package:pinterest/presentation/state_management/provider/recent_viewed_provider.dart';
// import 'package:pinterest/presentation/state_management/provider/recent_saved_provider.dart';
import 'package:pinterest/presentation/state_management/provider/recently_viewed_provider.dart';
// import 'package:pinterest/presentation/widgets/pinterest_widgets/recent_pins_row.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/recently_viewed_row.dart';

class SearchInputScreen extends ConsumerStatefulWidget {
  final SearchInputArgs args;

  const SearchInputScreen({super.key, required this.args});

  @override
  ConsumerState<SearchInputScreen> createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends ConsumerState<SearchInputScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }
void _submit() {
  final query = _controller.text.trim();
  if (query.isEmpty) return;

  context.push(
    '/search-result',
    extra: {
      'query': query,
      'args': widget.args, 
    },
  );
}

  // void _submit() {
  //   final query = _controller.text.trim();
  //   if (query.isEmpty) return;

  //   context.push('/search-result', extra: query);
  // }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentViewed = ref.watch(recentViewedProvider);
    // final recentSaved = ref.watch(recentSavedProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔍 SEARCH BAR ROW
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          if (_controller.text.isEmpty)
                            const Icon(Icons.search, color: Colors.white54),
                          if (_controller.text.isEmpty)
                            const SizedBox(width: 8),

                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.search,
                              decoration: const InputDecoration(
                                hintText: 'Search for ideas',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                              onChanged: (_) => setState(() {}),
                              onSubmitted: (_) => _submit(),
                            ),
                          ),

                          const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),

              /// 🔥 ONLY SHOW FOR PROFILE SEARCH
              if (widget.args.source == SearchSource.boards) ...[
                const SizedBox(height: 24),

                if (recentViewed.isNotEmpty)
                  RecentPinsRow(
                    title: 'Recently viewed',
                    pins: recentViewed,
                    onSeeMore: () {
                      context.push('/recent-pins', extra: 'viewed');
                    },
                  ),

                const SizedBox(height: 24),

                if (recentViewed.isNotEmpty)
                  RecentPinsRow(
                    title: 'Recently saved',
                    pins: recentViewed,
                    onSeeMore: () {
                      context.push(
                        '/recent-pins',
                        extra: 'viewed', // or 'saved'
                      );

                      // context.push('/recent-pins', extra: 'saved');
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// class SearchInputScreen extends StatefulWidget {
//   const SearchInputScreen({super.key});

//   @override
//   State<SearchInputScreen> createState() => _SearchInputScreenState();
// }

// class _SearchInputScreenState extends State<SearchInputScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();

//     // Auto focus keyboard
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _focusNode.requestFocus();
//     });
//   }

//   void _submit() {
//     final query = _controller.text.trim();
//     if (query.isEmpty) return;

//     context.push('/search-result', extra: query);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Row(
//             children: [
//               // SEARCH FIELD
//               Expanded(
//                 child: Container(
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade900,
//                     borderRadius: BorderRadius.circular(28),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       // Search icon (hidden when typing)
//                       if (_controller.text.isEmpty)
//                         const Icon(Icons.search, color: Colors.white54),

//                       if (_controller.text.isEmpty)
//                         const SizedBox(width: 8),

//                       Expanded(
//                         child: TextField(
//                           controller: _controller,
//                           focusNode: _focusNode,
//                           style: const TextStyle(color: Colors.white),
//                           textInputAction: TextInputAction.search,
//                           decoration: const InputDecoration(
//                             hintText: 'Search for ideas',
//                             hintStyle:
//                                 TextStyle(color: Colors.white54),
//                             border: InputBorder.none,
//                           ),
//                           onChanged: (_) => setState(() {}),
//                           onSubmitted: (_) => _submit(),
//                         ),
//                       ),

//                       const Icon(
//                         Icons.camera_alt_outlined,
//                         color: Colors.white54,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // CANCEL BUTTON
//               const SizedBox(width: 12),
//               GestureDetector(
//                 onTap: () => context.pop(),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
