import 'dart:math';

import 'package:flutter/material.dart';

void showConfetti(BuildContext context, Offset origin) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  final controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 750),
  );

  entry = OverlayEntry(
    builder: (_) {
      return Positioned.fill(
        child: IgnorePointer(
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              return CustomPaint(
                painter: ConfettiPhysicsPainter(
                  progress: controller.value,
                  origin: origin.translate(-12, -8),
                  screenSize: MediaQuery.of(context).size,
                ),
              );
            },
          ),
        ),
      );
    },
  );

  overlay.insert(entry);
  controller.forward().whenComplete(() {
    entry.remove();
    controller.dispose();
  });
}


void showSquareConfetti(
  BuildContext context, {
  required Offset origin,
  required double maxHeight,
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: SquareConfettiPainter(origin, maxHeight),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(milliseconds: 900), () {
    entry.remove();
  });
}



class ConfettiPhysicsPainter extends CustomPainter {
  final double progress; // 0 → 1
  final Offset origin;
  final Size screenSize;
  final Random _rand = Random();

  ConfettiPhysicsPainter({
    required this.progress,
    required this.origin,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final time = progress * 0.75; // total duration ≈ 750ms

    const gravity = 2200.0;
    const speed = 1100.0;
    const angle = -135 * pi / 180;

    final vx = speed * cos(angle);
    final vy = speed * sin(angle);

    for (int i = 0; i < 14; i++) {
      final delay = i * 0.03;
      final t = max(0, time - delay);

      final dx = vx * t;
      final dy = vy * t + 0.5 * gravity * t * t;

      final pos = Offset(
        origin.dx + dx,
        origin.dy + dy,
      );

      if (pos.dx < -40 || pos.dy > screenSize.height + 40) continue;

      final rotation = (t * 6 + i).toDouble();
      final size = 6 + _rand.nextDouble() * 6;

      paint.color = _colors[i % _colors.length];

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: size,
          height: size * 0.7,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPhysicsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

const _colors = [
  Color(0xFFFFC107),
  Color(0xFFE91E63),
  Color(0xFF03A9F4),
  Color(0xFF4CAF50),
  Color(0xFFFF5722),
];

class SquareConfettiPainter extends CustomPainter {
  final Offset origin;
  final double maxHeight;
  final Random _rnd = Random();

  SquareConfettiPainter(this.origin, this.maxHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < 22; i++) {
      final progress = _rnd.nextDouble();

      final dx = (_rnd.nextDouble() - 0.5) * 180;
      final dy = -progress * maxHeight;

      paint.color = Colors.primaries[_rnd.nextInt(Colors.primaries.length)];

      canvas.save();
      canvas.translate(origin.dx + dx, origin.dy + dy);
      canvas.rotate(_rnd.nextDouble() * pi);
      canvas.drawRect(
        const Rect.fromLTWH(-4, -4, 8, 8), // square shards
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



class ConfettiPainter extends CustomPainter {
  final Offset center;
  final Random _rand = Random();

  ConfettiPainter(this.center);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < 18; i++) {
      paint.color = Colors.primaries[i % Colors.primaries.length];
      final angle = (2 * pi / 18) * i;
      final radius = 20 + _rand.nextDouble() * 14;

      final offset = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      canvas.drawCircle(offset, 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
