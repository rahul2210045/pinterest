import 'package:flutter/material.dart';

class CollagesTab extends StatefulWidget {
  const CollagesTab({super.key});

  @override
  State<CollagesTab> createState() => _CollagesTabState();
}

class _CollagesTabState extends State<CollagesTab> {
  bool isCreatedByYou = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              _FilterChip(
                text: 'Created by you',
                selected: isCreatedByYou,
                onTap: () => setState(() => isCreatedByYou = true),
              ),
              const SizedBox(width: 10),
              _FilterChip(
                text: 'In progress',
                selected: !isCreatedByYou,
                onTap: () => setState(() => isCreatedByYou = false),
              ),
            ],
          ),
        ),

        Expanded(
          child: _CollageEmptyState(
            isCreatedByYou: isCreatedByYou,
          ),
        ),
      ],
    );
  }
}
class _FilterChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
class _CollageEmptyState extends StatelessWidget {
  final bool isCreatedByYou;

  const _CollageEmptyState({required this.isCreatedByYou});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🎨 ILLUSTRATION
            Image.asset(
              'assets/images/collage_illustration.png',
              height: 180,
            ),

            const SizedBox(height: 24),

            /// 📝 TITLE
            Text(
              isCreatedByYou
                  ? 'Create a collage'
                  : "You don't have any collages in progress!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            /// 📄 DESCRIPTION
            Text(
              isCreatedByYou
                  ? 'Snip-and-paste Pins to make something totally new—then publish it to inspire people with what you create.'
                  : 'Cut out and combine anything visual that inspires you to create a collage',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 28),

            /// 🔴 CTA BUTTON
            SizedBox(
              width: 200,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  // TODO: navigate to create collage flow
                },
                child: const Text(
                  'Create collage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
