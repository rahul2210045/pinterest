// // import 'package:flutter/material.dart';
// // import 'package:pinterest/data/local/saved_pin_model.dart';
// import 'package:flutter/material.dart';
// import 'package:pinterest/data/local/saved_pin_model.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/data/local/saved_pin_model.dart';

class RecentPinsRow extends StatelessWidget {
  final String title;
  final List<SavedPinModel> pins;
  final VoidCallback onSeeMore;

  const RecentPinsRow({
    super.key,
    required this.title,
    required this.pins,
    required this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    final display = pins.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        /// IMAGE ROW
        SizedBox(
          height: 110, // 🔥 FIXED HEIGHT (matches Pinterest)
          child: Row(
            children: List.generate(display.length, (i) {
              final pin = display[i];
              final isSeeMore = i == 3 && pins.length > 4;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == 3 ? 0 : 8),
                  child: GestureDetector(
                    onTap: isSeeMore ? onSeeMore : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand, // 🔥 FORCE FULL SIZE
                        children: [
                          /// IMAGE (fills whole space)
                          Image.network(pin.large, fit: BoxFit.cover),

                          /// SEE MORE OVERLAY
                          if (isSeeMore)
                            Container(
                              color: Colors.black.withOpacity(0.55),
                              alignment: Alignment.center,
                              child: const Text(
                                'See more',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// class RecentPinsRow extends StatelessWidget {
//   final String title;
//   final List<SavedPinModel> pins;
//   final VoidCallback onSeeMore;

//   const RecentPinsRow({
//     required this.title,
//     required this.pins,
//     required this.onSeeMore,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final display = pins.take(4).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
//         const SizedBox(height: 12),
//         Row(
//           children: List.generate(display.length, (i) {
//             final pin = display[i];
//             final isSeeMore = i == 3 && pins.length > 4;

//             return Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: GestureDetector(
//                   onTap: isSeeMore ? onSeeMore : null,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: Stack(
//                       children: [
//                         Image.network(pin.large, fit: BoxFit.cover),
//                         if (isSeeMore)
//                           Container(
//                             color: Colors.black54,
//                             alignment: Alignment.center,
//                             child: const Text(
//                               'See more',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }
