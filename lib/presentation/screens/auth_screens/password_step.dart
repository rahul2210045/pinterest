import 'package:flutter/material.dart';
import 'package:pinterest/presentation/screens/auth_screens/step_wrapper.dart';

class PasswordStep extends StatefulWidget {
  final VoidCallback onNext;
  const PasswordStep({super.key, required this.onNext});

  @override
  State<PasswordStep> createState() => _PasswordStepState();
}

class _PasswordStepState extends State<PasswordStep> {
  final controller = TextEditingController();
  double strength = 0;

  void checkStrength(String value) {
    setState(() {
      strength = value.length / 12;
      if (strength > 1) strength = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepWrapper(
      title: 'Create a password',
      child: Column(
        children: [
          TextField(
            controller: controller,
            obscureText: true,
            onChanged: checkStrength,
            style: const TextStyle(color: Colors.white),
            decoration: inputDecoration('Password'),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: strength,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(Colors.red),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Next',
            enabled: strength > 0.5,
            onTap: widget.onNext,
          ),
        ],
      ),
    );
  }
}
