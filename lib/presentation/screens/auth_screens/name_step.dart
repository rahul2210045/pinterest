import 'package:flutter/material.dart';
import 'package:pinterest/presentation/screens/auth_screens/step_wrapper.dart';

class NameStep extends StatelessWidget {
  final VoidCallback onNext;
  const NameStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return StepWrapper(
      title: "What's your name?",
      child: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: inputDecoration('Full name'),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Next', onTap: onNext),
        ],
      ),
    );
  }
}
