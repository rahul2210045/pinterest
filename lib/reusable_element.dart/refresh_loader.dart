import 'package:flutter/material.dart';

class PinterestRefreshLoader extends StatefulWidget {
  const PinterestRefreshLoader({super.key});

  @override
  State<PinterestRefreshLoader> createState() =>
      _PinterestRefreshLoaderState();
}

class _PinterestRefreshLoaderState
    extends State<PinterestRefreshLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Center(
        child: RotationTransition(
          turns: _controller,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ScaleTransition(
                  scale: Tween(begin: 0.6, end: 1.1).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        i * 0.2,
                        1,
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.white,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
