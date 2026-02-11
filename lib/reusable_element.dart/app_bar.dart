import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/presentation/state_management/provider/dashboard_provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeTopChips extends ConsumerWidget {
  const HomeTopChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(dashboardProvider).isLoading;

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _ChipItem("For you", isLoading),
          _ChipItem("rahul", isLoading),
          _ChipItem("Radha krishna love wallpaper", isLoading),
        ],
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final String text;
  final bool shimmer;

  const _ChipItem(this.text, this.shimmer);

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: shimmer
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade700,
              highlightColor: Colors.grey.shade500,
              child: chip,
            )
          : chip,
    );
  }
}
