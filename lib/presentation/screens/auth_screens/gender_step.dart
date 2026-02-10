import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/step_dots.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? _selectedGender;

  void _selectGender(String value) {
    setState(() {
      _selectedGender = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = _selectedGender != null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              /// 🔝 Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const StepDots(currentStep: 4), // 👈 update step index
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 32),

              /// 🧠 Title
              const Text(
                "What's your gender?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// ℹ️ Subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "This helps us find you more relevant content.\nWe won't show it on your profile.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),

              const SizedBox(height: 32),

              /// 👩 Female
              _GenderTile(
                label: 'Female',
                selected: _selectedGender == 'female',
                onTap: () => _selectGender('female'),
              ),

              const SizedBox(height: 14),

              /// 👨 Male
              _GenderTile(
                label: 'Male',
                selected: _selectedGender == 'male',
                onTap: () => _selectGender('male'),
              ),

              const SizedBox(height: 14),

              /// 🧑 Specify another
              _GenderTile(
                label: 'Specify another',
                selected: _selectedGender == 'other',
                onTap: () => _selectGender('other'),
              ),

              const Spacer(),

              /// 🔴 Next button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSelected
                      ? () {
                          // TODO: save gender in Clerk metadata later
                          context.go('/step-country');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.red : Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔘 Gender Option Tile
class _GenderTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.red : const Color(0xFF4A4A44),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
