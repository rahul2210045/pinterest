import 'dart:math';

import 'package:flutter/material.dart';

class ConfettiPainter extends CustomPainter {
  final Offset center;
  final Random _rnd = Random();

  ConfettiPainter(this.center);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < 16; i++) {
      paint.color = Colors.primaries[_rnd.nextInt(Colors.primaries.length)];
      final offset = Offset(
        center.dx + _rnd.nextDouble() * 40 - 20,
        center.dy + _rnd.nextDouble() * 40 - 20,
      );
      canvas.drawCircle(offset, 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
