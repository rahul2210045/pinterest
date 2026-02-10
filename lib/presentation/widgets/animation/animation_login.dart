// import 'dart:math';

// import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedPinterestCollage extends StatefulWidget {
  const AnimatedPinterestCollage({super.key});

  @override
  State<AnimatedPinterestCollage> createState() =>
      _AnimatedPinterestCollageState();
}

class _AnimatedPinterestCollageState extends State<AnimatedPinterestCollage>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      6,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2500 + i * 600),
      )..repeat(reverse: true),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // double _scale(AnimationController c, double min, double max) {
  //   return min + (max - min) * Curves.easeInOut.transform(c.value);
  // }

  double _scale(AnimationController c, double min, double max) {
    return min + (max - min) * sin(c.value * pi);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 1️⃣ Left Top (small)
          Positioned(
            left: 0,
            top: 0,
            child: _AnimatedImage(
              controller: _controllers[0],
              width: 110,
              height: 80,
              radius: const BorderRadius.only(
                // bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              // radius: BorderRadius.circular(18),
              scale: () => _scale(_controllers[0], 1.0, 1.06),
            ),
          ),

          /// 2️⃣ Left Bottom (medium)
          Positioned(
            left: 0,
            bottom: 0,
            child: _AnimatedImage(
              controller: _controllers[1],
              width: 90,
              height: 130,
              radius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              // radius: BorderRadius.circular(22),
              scale: () => _scale(_controllers[1], 1.0, 1.08),
            ),
          ),
          Positioned(
            left: 250,
            top: 90,
            child: _AnimatedImage(
              controller: _controllers[3],
              width: 70,
              height: 100,
              radius: BorderRadius.circular(18),
              scale: () => _scale(_controllers[3], 1.0, 1.07),
            ),
          ),

          /// 3️⃣ Center (BIG – overlapping)
          Positioned(
            left: 100,
            top: 40,
            child: _AnimatedImage(
              controller: _controllers[2],
              width: 170,
              height: 220,
              radius: BorderRadius.circular(30),
              scale: () => _scale(_controllers[2], 1.0, 1.04),
              elevation: true,
            ),
          ),

          /// 4️⃣ Right of center (small)

          /// 5️⃣ Right Top (very small – bottom rounded only)
          Positioned(
            right: 0,
            top: 0,
            child: _AnimatedImage(
              controller: _controllers[4],
              width: 110,
              height: 15,
              radius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              scale: () => _scale(_controllers[4], 1.0, 1.05),
            ),
          ),

          /// 6️⃣ Right Bottom (curved left only)
          Positioned(
            right: 0,
            bottom: 0,
            child: _AnimatedImage(
              controller: _controllers[5],
              width: 95,
              height: 95,
              radius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                bottomLeft: Radius.circular(22),
              ),
              scale: () => _scale(_controllers[5], 1.0, 1.06),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedImage extends StatelessWidget {
  final AnimationController controller;
  final double width;
  final double height;
  final BorderRadius radius;
  final double Function() scale;
  final bool elevation;

  const _AnimatedImage({
    required this.controller,
    required this.width,
    required this.height,
    required this.radius,
    required this.scale,
    this.elevation = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Transform.scale(
          scale: scale(),
          child: Material(
            elevation: elevation ? 8 : 0,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: radius,
              child: Image.asset(
                'assets/images/collage.png',
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
