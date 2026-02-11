
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
  final List<String> images = [
    'assets/images/collage.png',
    'assets/images/collage.png',
    'assets/images/chat_logo.png',
    'assets/images/collage.png',
    'assets/images/chat_logo.png',
    'assets/images/collage.png',
  ];

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
          Positioned(
            left: 0,
            top: 0,
            child: _AnimatedImage(
              controller: _controllers[0],
              imagePath: images[0],
              width: 110,
              height: 80,
              radius: const BorderRadius.only(
                bottomRight: Radius.circular(16),
              ),
              scale: () => _scale(_controllers[0], 1.0, 1.06),
            ),
          ),

          Positioned(
            left: 0,
            bottom: 0,
            child: _AnimatedImage(
              controller: _controllers[1],
              imagePath: images[1],
              width: 90,
              height: 130,
              radius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              scale: () => _scale(_controllers[1], 1.0, 1.08),
            ),
          ),
          Positioned(
            left: 250,
            top: 90,
            child: _AnimatedImage(
              controller: _controllers[3],
              imagePath: images[3],
              width: 70,
              height: 100,
              radius: BorderRadius.circular(18),
              scale: () => _scale(_controllers[3], 1.0, 1.07),
            ),
          ),

          Positioned(
            left: 100,
            top: 40,
            child: _AnimatedImage(
              controller: _controllers[2],
              imagePath: images[2],
              width: 170,
              height: 220,
              radius: BorderRadius.circular(30),
              scale: () => _scale(_controllers[2], 1.0, 1.04),
              elevation: true,
            ),
          ),
          Positioned(
            left: 175,
            bottom: -20,
            child: Image.asset('assets/images/pinterest_icon.png', height: 40),
          ),

          
          Positioned(
            right: 0,
            top: 0,
            child: _AnimatedImage(
              controller: _controllers[4],
              imagePath: images[4],
              width: 110,
              height: 15,
              radius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              scale: () => _scale(_controllers[4], 1.0, 1.05),
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: _AnimatedImage(
              controller: _controllers[5],
              imagePath: images[5],
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
  final String imagePath;

  const _AnimatedImage({
    required this.controller,
    required this.width,
    required this.height,
    required this.radius,
    required this.scale,
    required this.imagePath,
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
                imagePath,
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
