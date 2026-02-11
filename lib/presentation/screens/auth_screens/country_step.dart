
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/step_dots.dart';
import 'package:pinterest/reusable_element.dart/app_loader.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  String _selectedCountry = 'India';
  bool _loading = false;

  Future<void> _openCountryPicker() async {
    final result = await context.push<String>('/country-picker');

    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedCountry = result;
      });
    }
  }

  Future<void> _completeOnboarding() async {
    final auth = ClerkAuth.of(context);

    try {
      await auth.updateUser(
        metadata: {'onboardingCompleted': true, 'country': _selectedCountry},
      );
      await auth.refreshClient();
      context.go('/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to finish onboarding')),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  const Spacer(),
                  const StepDots(currentStep: 6),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "What's your country or region?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "This helps us find you more relevant content.\n"
                "We won't show it on your profile.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 32),

              InkWell(
                onTap: _openCountryPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 14,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white24)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedCountry,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: Colors.white54),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:PinterestPaginationLoader(),
                        )
                      : const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
