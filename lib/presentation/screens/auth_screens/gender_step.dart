import 'package:flutter/material.dart';
import 'package:pinterest/presentation/screens/auth_screens/step_wrapper.dart';

class GenderStep extends StatelessWidget {
  final VoidCallback onNext;
  const GenderStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return StepWrapper(
      title: "What's your gender?",
      child: Column(
        children: [
          OptionButton(label: 'Female', onTap: onNext),
          OptionButton(label: 'Male', onTap: onNext),
          OptionButton(label: 'Specify another', onTap: onNext),
        ],
      ),
    );
  }
}
