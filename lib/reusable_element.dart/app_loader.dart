import 'dart:math' as Math;

import 'package:flutter/material.dart';

class PinterestPaginationLoader extends StatefulWidget {
  const PinterestPaginationLoader({super.key});

  @override
  State<PinterestPaginationLoader> createState() =>
      _PinterestPaginationLoaderState();
}

class _PinterestPaginationLoaderState
    extends State<PinterestPaginationLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Center(
        child: RotationTransition(
          turns: _controller,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(3, (i) {
              final angle = (i * 120) * 3.14 / 180;
              return Transform.translate(
                offset: Offset(
                  12 * Math.cos(angle),
                  12 * Math.sin(angle),
                ),
                child: ScaleTransition(
                  scale: Tween(begin: 0.6, end: 1.0).animate(
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
