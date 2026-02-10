// import 'package:flutter/material.dart';
// import 'package:pinterest/data/local/board_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/data/local/board_model.dart';

class BoardCard extends StatelessWidget {
  final BoardModel board;

  const BoardCard({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    final pins = board.pins.take(3).toList();

    Widget placeholder() => Container(color: Colors.grey.shade800);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔥 IMAGE COLLAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 1,
            child: Row(
              children: [
                /// LEFT IMAGE (60%)
                Expanded(
                  flex: 6,
                  child: pins.isNotEmpty
                      ? SizedBox.expand(
                          child: CachedNetworkImage(
                            imageUrl: pins[0].large,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(color: Colors.grey.shade800),
                ),

                /// VERTICAL DIVIDER
                Container(width: 1, color: Colors.black),

                /// RIGHT COLUMN (40%)
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      /// TOP IMAGE
                      Expanded(
                        child: pins.length > 1
                            ? SizedBox.expand(
                                child: CachedNetworkImage(
                                  imageUrl: pins[1].large,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(color: Colors.grey.shade800),
                      ),

                      /// HORIZONTAL DIVIDER
                      Container(height: 1, color: Colors.black),

                      /// BOTTOM IMAGE
                      Expanded(
                        child: pins.length > 2
                            ? SizedBox.expand(
                                child: CachedNetworkImage(
                                  imageUrl: pins[2].large,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        /// 📌 BOARD NAME
        Text(
          board.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),

        /// 📊 PIN COUNT + TIME
        Text(
          '${board.pins.length} Pins · ${_timeAgo(board.createdAt)}',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

// class BoardCard extends StatelessWidget {
//   final BoardModel board;

//   const BoardCard({super.key, required this.board});

//   @override
//   Widget build(BuildContext context) {
//     final pins = board.pins.take(3).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// IMAGE COLLAGE
//         ClipRRect(
//           borderRadius: BorderRadius.circular(18),
//           child: AspectRatio(
//             aspectRatio: 1,
//             child: Row(
//               children: [
//                 if (pins.isNotEmpty)
//                   Expanded(
//                     flex: 6,
//                     child: Image.network(pins[0].large, fit: BoxFit.cover),
//                   ),

//                 if (pins.length > 1)
//                   Expanded(
//                     flex: 4,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Image.network(
//                             pins[1].large,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         if (pins.length > 2)
//                           Expanded(
//                             child: Image.network(
//                               pins[2].large,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),

//         // const SizedBox(height: 0),

//         /// BOARD INFO
//         Text(
//           board.name,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         Text(
//           '${board.pins.length} Pins · ${_timeAgo(board.createdAt)}',
//           style: const TextStyle(color: Colors.white54, fontSize: 12),
//         ),
//       ],
//     );
//   }

//   String _timeAgo(DateTime date) {
//     final diff = DateTime.now().difference(date);
//     if (diff.inHours < 24) return '${diff.inHours}h';
//     return '${diff.inDays}d';
//   }
// }
