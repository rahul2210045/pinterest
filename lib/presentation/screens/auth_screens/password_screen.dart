import 'package:flutter/material.dart';
import 'package:pinterest/presentation/services/auth_service.dart/auth_service.dart';

class LoginPasswordScreen extends StatefulWidget {
  final String email;

  const LoginPasswordScreen({super.key, required this.email});

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}
class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _loading = false;
  String? _errorText;

// class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              /// 🔝 Header
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 24),

              /// Google button
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Google login
                },
                icon: Image.asset('assets/images/logo.png', height: 18),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Colors.white38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text('Or', style: TextStyle(color: Colors.white70)),
              ),

              const SizedBox(height: 20),

              /// Email field (prefilled, read-only)
              TextField(
                enabled: false,
                controller: TextEditingController(text: widget.email),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: Colors.white38),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: Colors.white54),
                  suffixIcon: IconButton(
                    splashRadius: 18,
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              if (_errorText != null) ...[
  const SizedBox(height: 8),
  Text(
    _errorText!,
    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
  ),
],


              const SizedBox(height: 24),

              /// Login button
               SizedBox(
  height: 52,
  child: ElevatedButton(
    onPressed: _loading
        ? null
        : () async {
            final password = _passwordController.text.trim();

            if (password.isEmpty) {
              setState(() => _errorText = 'Enter your password');
              return;
            }

            setState(() {
              _loading = true;
              _errorText = null;
            });

            try {
              await _authService.signInWithPassword(
                context: context,
                email: widget.email,
                password: password,
              );

              /// ✅ SUCCESS → GoRouter redirect will send to dashboard
            } catch (e) {
              setState(() {
                _errorText = 'Incorrect password. Try again.';
              });
            } finally {
              setState(() => _loading = false);
            }
          },
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
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : const Text(
            'Log In',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
  ),
),

              // SizedBox(
              //   height: 52,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // TODO: Call Clerk login
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.red,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(28),
              //       ),
              //     ),
              //     child: const Text(
              //       'Log In',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 16),

              /// Forgot password
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Forgot password flow
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
