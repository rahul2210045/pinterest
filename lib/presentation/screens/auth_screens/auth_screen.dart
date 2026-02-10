import 'package:flutter/material.dart';
import 'package:pinterest/presentation/services/auth_service.dart/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authService = AuthService();

  bool isSignUp = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isSignUp ? 'Create Account' : 'Welcome Back',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),

              if (errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ],

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();

                  if (isSignUp) {
                    await _authService.signUpWithPassword(
                      context: context,
                      email: email,
                      password: password,
                      name: 'User',
                      dob: DateTime.now(),
                      gender: 'Other',
                      country: 'US',
                    );
                  } else {
                    await _authService.signInWithPassword(
                      context: context,
                      email: email,
                      password: password,
                    );
                  }
                },
                child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  setState(() {
                    isSignUp = !isSignUp;
                    errorText = null;
                  });
                },
                child: Text(
                  isSignUp
                      ? 'Already have an account? Sign In'
                      : 'New here? Create an account',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () async {
                  await _authService.signInWithGoogle(context);
                },
                child: const Text('Continue with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
