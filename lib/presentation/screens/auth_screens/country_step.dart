import 'package:flutter/material.dart';
import 'package:pinterest/presentation/screens/auth_screens/step_wrapper.dart';

class CountryStep extends StatelessWidget {
  final VoidCallback onFinish;
  const CountryStep({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return StepWrapper(
      title: 'Country / Region',
      child: Column(
        children: [
          OptionButton(label: 'India', onTap: onFinish),
          OptionButton(label: 'United States', onTap: onFinish),
          OptionButton(label: 'Other', onTap: onFinish),
        ],
      ),
    );
  }
}
