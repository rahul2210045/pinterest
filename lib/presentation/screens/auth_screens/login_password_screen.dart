import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:pinterest/core/controllers/auth_controller.dart';

class LoginPasswordScreen extends ConsumerWidget {
  final String email;

  const LoginPasswordScreen({required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Text(email, style: TextStyle(color: Colors.white)),
          TextField(
            controller: controller,
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () async {
              // await ref.read(authProvider.notifier).loginWithPassword(
              //       email: email,
              //       password: controller.text,
              //     );
              // context.go('/');
            },
            child: Text('Log in'),
          ),
        ],
      ),
    );
  }
}
