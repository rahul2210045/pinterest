import 'package:flutter/material.dart';

class StepDots extends StatelessWidget {
  final int currentStep;
  const StepDots({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (index) {
        if (index < currentStep) {
          return _dot(Colors.white);
        } else if (index == currentStep) {
          return _outlinedDot();
        } else {
          return _dot(Colors.white24);
        }
      }),
    );
  }

  Widget _dot(Color color) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: CircleAvatar(radius: 4, backgroundColor: color),
      );

  Widget _outlinedDot() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white),
          ),
        ),
      );
}
