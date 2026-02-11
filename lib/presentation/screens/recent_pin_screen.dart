import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/state_management/provider/all_saved_pins_provider.dart';
import 'package:pinterest/presentation/state_management/provider/recent_pins_provider.dart';


class RecentPinsScreen extends ConsumerWidget {
  final String type; 

  const RecentPinsScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pins = type == 'viewed'
        ? ref.watch(recentViewedPinsProvider)
        : ref.watch(allSavedPinsProvider); 
    print('ALL SAVED PINS: ${pins.length}');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          type == 'viewed' ? 'Recently viewed' : 'Recently saved',
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childCount: pins.length,
              itemBuilder: (_, i) {
                final pin = pins[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(pin.large, fit: BoxFit.cover),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  type == 'viewed'
                      ? "You've seen all your recently viewed Pins from the last 7 days"
                      : "You've seen all your recently saved Pins",
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () => context.push('/'),
                  child: const Text(
                    'Discover more ideas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
