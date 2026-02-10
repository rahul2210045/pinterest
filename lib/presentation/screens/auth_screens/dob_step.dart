import 'package:flutter/material.dart';
import 'package:pinterest/presentation/screens/auth_screens/step_wrapper.dart';

class DobStep extends StatelessWidget {
  final VoidCallback onNext;
  const DobStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return StepWrapper(
      title: 'Enter your birthdate',
      child: Column(
        children: [
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Select Date',
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (date != null) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.grey[900],
                  builder: (_) => _DobConfirmSheet(
                    date: date,
                    onConfirm: onNext,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _DobConfirmSheet extends StatelessWidget {
  final DateTime date;
  final VoidCallback onConfirm;

  const _DobConfirmSheet({
    required this.date,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Is ${date.day}/${date.month}/${date.year} your birthday?',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Confirm', onTap: onConfirm),
        ],
      ),
    );
  }
}
