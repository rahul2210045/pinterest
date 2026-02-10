import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/models/pin_view_model.dart';
import 'package:pinterest/presentation/models/search_input_arg.dart';
import 'package:pinterest/presentation/state_management/provider/board_provider.dart';
import 'package:pinterest/presentation/state_management/provider/pins_provider.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/empty_pin_state.dart';

enum PinLayout { standard, wide, compact }

class PinsTab extends ConsumerStatefulWidget {
  const PinsTab({super.key});

  @override
  ConsumerState<PinsTab> createState() => _PinsTabState();
}

class _PinsTabState extends ConsumerState<PinsTab> {
  PinLayout layout = PinLayout.standard;
  bool showFavorites = false;
  bool showCreated = false;
  void _openLayoutSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            _LayoutOption(
              title: 'Wide',
              selected: layout == PinLayout.wide,
              onTap: () {
                setState(() => layout = PinLayout.wide);
                Navigator.pop(context);
              },
            ),
            _LayoutOption(
              title: 'Standard',
              selected: layout == PinLayout.standard,
              onTap: () {
                setState(() => layout = PinLayout.standard);
                Navigator.pop(context);
              },
            ),
            _LayoutOption(
              title: 'Compact',
              selected: layout == PinLayout.compact,
              onTap: () {
                setState(() => layout = PinLayout.compact);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) {
        return [
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinsHeaderDelegate(
              layout: layout,
              showFavorites: showFavorites,
              showCreated: showCreated,
              onLayoutTap: _openLayoutSheet,
              onFavoritesTap: () {
                setState(() {
                  showFavorites = !showFavorites;
                  showCreated = false;
                });
              },
              onCreatedTap: () {
                setState(() {
                  showCreated = !showCreated;
                  showFavorites = false;
                });
              },
            ),
          ),
        ];
      },
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (showFavorites || showCreated) {
      return EmptyPinsState();
    }

    final boards = ref.watch(boardProvider);

    final allPins = boards
        .expand((b) => b.pins)
        .map(
          (p) => PinViewModel(
            id: p.id,
            imageUrl: p.large,
            photographer: p.photographer,
            liked: p.liked,
            width: p.width,
            height: p.height,
            title: '',
            savedAt: DateTime.now(),
          ),
        )
        .toList();

    if (allPins.isEmpty) {
      return EmptyPinsState();
    }

    return _PinsGrid(layout: layout, pins: allPins);
  }
}

class _LayoutOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LayoutOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: selected ? const Icon(Icons.check, color: Colors.white) : null,
    );
  }
}

class _PinsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final PinLayout layout;
  final bool showFavorites;
  final bool showCreated;
  final VoidCallback onLayoutTap;
  final VoidCallback onFavoritesTap;
  final VoidCallback onCreatedTap;

  _PinsHeaderDelegate({
    required this.layout,
    required this.showFavorites,
    required this.showCreated,
    required this.onLayoutTap,
    required this.onFavoritesTap,
    required this.onCreatedTap,
  });

  @override
  double get maxExtent => 130;
  @override
  double get minExtent => 130;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _SearchBarRow(),
          const SizedBox(height: 10),
          Row(
            children: [
              _FilterIcon(layout, onLayoutTap),
              const SizedBox(width: 8),
              _Chip('Favorites', showFavorites, onFavoritesTap),
              const SizedBox(width: 8),
              _Chip('Created by you', showCreated, onCreatedTap),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _Chip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _Chip(this.text, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            if (selected)
              const Icon(Icons.close, size: 16, color: Colors.black),
            if (selected) const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinsGrid extends StatelessWidget {
  final List<PinViewModel> pins;
  final PinLayout layout;

  const _PinsGrid({required this.pins, required this.layout});

  @override
  Widget build(BuildContext context) {
    // WIDE layout (list)
    if (layout == PinLayout.wide) {
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: pins.length,
        itemBuilder: (_, i) {
          final pin = pins[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(pin.imageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pin.photographer,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(
                    pin.liked ? Icons.star : Icons.star_border,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      );
    }

    /// 🔥 STANDARD / COMPACT → Pinterest Masonry Grid
    final crossAxisCount = layout == PinLayout.compact ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: MasonryGridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: pins.length,
        itemBuilder: (_, i) {
          final pin = pins[i];

          final aspectRatio = pin.width / pin.height;

          return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Image.network(pin.imageUrl, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}

class _SearchBarRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              context.push(
  '/search-input',
  extra: const SearchInputArgs(source: SearchSource.pins),
);

            },
            borderRadius: BorderRadius.circular(28),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
          children: const [
            Icon(Icons.search, color: Colors.white54),
            SizedBox(width: 8),
            Text(
              'Search your Pins',
              style: TextStyle(color: Colors.white54),
            ),
          ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.add, color: Colors.white, size: 28),
      ],
    );
  }
}

class _FilterIcon extends StatelessWidget {
  final PinLayout layout;
  final VoidCallback onTap;

  const _FilterIcon(this.layout, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          layout == PinLayout.compact
              ? Icons.grid_view
              : layout == PinLayout.wide
              ? Icons.view_agenda
              : Icons.dashboard,
          color: Colors.white,
        ),
      ),
    );
  }
}


