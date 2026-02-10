import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/step_dots.dart';
import 'package:pinterest/presentation/services/auth_service.dart/auth_service.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String email;
  const CreatePasswordScreen({super.key, required this.email});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  double _strength = 0.0;
  final AuthService _authService = AuthService();
  bool _loading = false;
  String? _errorText;

  bool get isStrong => _strength >= 0.75;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _updateStrength(String value) {
    double strength = 0;

    if (value.length >= 8) strength += 0.3;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) strength += 0.3;

    setState(() {
      _strength = strength.clamp(0.0, 1.0);
    });
  }

  Color get strengthColor {
    if (_strength < 0.4) return Colors.red;
    if (_strength < 0.7) return Colors.orange;
    return Colors.green;
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

              /// 🔝 Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  StepDots(currentStep: 1),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'Create a password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// 🔐 Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.red,
                onChanged: _updateStrength,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintText: 'Create a strong password',
                  hintStyle: const TextStyle(color: Colors.white38),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() => _obscure = !_obscure);
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 📊 Strength indicator
              if (_passwordController.text.isNotEmpty) ...[
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: _strength,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: strengthColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Make it more complicated',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Use 8 or more letters, numbers and symbols',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],

              const SizedBox(height: 20),

              /// ℹ️ Password tips
              GestureDetector(
                onTap: () => _showPasswordTips(context),
                child: Row(
                  children: const [
                    Text(
                      'Password tips',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(width: 6),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.info, size: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// 🔴 Next button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (!isStrong || _loading)
                      ? null
                      : () async {
                          final password = _passwordController.text.trim();

                          setState(() {
                            _loading = true;
                            _errorText = null;
                          });

                          try {
                            await _authService.signUpWithPassword(
                              context: context,
                              email: widget.email,
                              password: password,
                              name: 'User',
                              dob: DateTime.now(),
                              gender: 'Other',
                              country: 'US',
                            );

                            /// ✅ Signup success → move to next onboarding screen
                            /// Example:
                            context.go('/step-name');
                          } catch (e) {
                            setState(() {
                              _errorText =
                                  'Failed to create account. Try again.';
                            });
                          } finally {
                            setState(() => _loading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isStrong ? Colors.red : Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Next', style: TextStyle(fontSize: 16)),
                ),
              ),

              // SizedBox(
              //   width: double.infinity,
              //   height: 52,
              //   child: ElevatedButton(
              //     onPressed: isStrong ? () {} : null,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor:
              //           isStrong ? Colors.red : Colors.grey[700],
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(28),
              //       ),
              //     ),
              //     child: const Text(
              //       'Next',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPasswordTips(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF2A2A2A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password tips',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              'A strong password helps keep your account safe.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Text(
              'What to avoid',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Common passwords, words and names',
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              '• Recent dates or dates associated with you',
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              '• Simple patterns and repeated text',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Okay'),
              ),
            ),
          ],
        ),
      );
    },
  );
}
