import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/widgets/animation/animation_login.dart';
import 'package:pinterest/presentation/services/auth_service.dart/auth_service.dart';


class AuthEmailScreen extends StatefulWidget {
  const AuthEmailScreen({super.key});

  @override
  State<AuthEmailScreen> createState() => _AuthEmailScreenState();
}

class _AuthEmailScreenState extends State<AuthEmailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AuthService _authService = AuthService();
bool _loading = false;


  String? errorText;
  late AnimationController _animationController;
  Future<void> _onContinue() async {
  final email = _emailController.text.trim();

  if (email.isEmpty) {
    setState(() => errorText = 'Please enter your email');
    return;
  }

  if (!_isValidEmail(email)) {
    setState(() => errorText = 'Enter a valid email address');
    return;
  }

  setState(() {
    errorText = null;
    _loading = true;
  });

  try {
    /// 🔑 TRY SIGN-IN WITH DUMMY PASSWORD
    await _authService.signInWithPassword(
      context: context,
      email: email,
      password: '99999900',
    );

    /// ⚠️ If sign-in succeeds (very rare here), still go to password screen
    context.go('/password-screen', extra: email);
  } catch (e) {
    final message = e.toString();

    if (message.contains('Password is incorrect')) {
      /// ✅ USER EXISTS → LOGIN FLOW
      context.go('/password-screen', extra: email);
    } else if (message.contains("Couldn't find your account")) {
      /// 🆕 NEW USER → SIGNUP FLOW
      context.go('/password-create', extra: email);
    } else {
      /// ❌ UNKNOWN ERROR
      setState(() {
        errorText = 'Something went wrong. Try again.';
      });
    }
  } finally {
    setState(() => _loading = false);
  }
}


  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // void _onContinue() {
  //   final email = _emailController.text.trim();

  //   if (email.isEmpty) {
  //     setState(() => errorText = 'Please enter your email');
  //     return;
  //   }

  //   if (!_isValidEmail(email)) {
  //     setState(() => errorText = 'Enter a valid email address');
  //     return;
  //   }

  //   setState(() => errorText = null);
  //   context.go('/password-create', extra: email);
  //   // context.go('/password-screen', extra: email);

  //   // TODO: Navigate to password screen
  // }

  @override
  Widget build(BuildContext context) {
    final hasText = _emailController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔥 Animated collage
            const AnimatedPinterestCollage(),

            // AnimatedImageGrid(),

            /// Content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 280),

                  /// Pinterest logo
                  Image.asset('assets/images/logo.png', height: 40),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: const Text(
                      'Create a life you love',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Email field
                  TextField(
                    controller: _emailController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Email address',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.transparent,
                      suffixIcon: hasText
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                _emailController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          color: errorText != null
                              ? Colors.red
                              : Colors.white54,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide(
                          color: errorText != null ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ),

                  if (errorText != null) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorText!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  /// Continue button
                  SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    onPressed: _loading ? null : _onContinue,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    ),
    child: _loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : const Text(
            'Continue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
  ),
),

                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 52,
                  //   child: ElevatedButton(
                  //     onPressed: _onContinue,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.red,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(28),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Continue',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 16),

                  /// Google button
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Image.asset('assets/images/logo.png', height: 18),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ),

                  const SizedBox(height: 120),

                  /// Footer text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        children: [
                          TextSpan(
                            text: 'By continuing, you agree to Pinterest’s ',
                          ),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: ' and acknowledge that you’ve read our ',
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: '.'),
                          TextSpan(
                            text: 'Notice at Collection',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
