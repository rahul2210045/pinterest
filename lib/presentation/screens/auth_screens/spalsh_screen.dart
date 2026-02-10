// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// // import 'package:pinterest/core/controllers/auth_controller.dart';

// class AuthStartScreen extends ConsumerWidget {
//   final emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             controller: emailController,
//             style: TextStyle(color: Colors.white),
//             decoration: InputDecoration(hintText: 'Email address'),
//           ),

//           ElevatedButton(
//             onPressed: () async {
//               // final email = emailController.text.trim();
//               // final exists = await ref
//               //     .read(authProvider.notifier)
//               //     .checkEmailExists(email);

//               // if (exists) {
//               //   context.push('/login', extra: email);
//               // } else {
//               //   context.push('/signup', extra: email);
//               // }
//             },
//             child: Text('Continue'),
//           ),

//           ElevatedButton(
//             onPressed: () async {
//               // await ref.read(authProvider.notifier).signInWithGoogle();
//               // context.go('/');
//             },
//             child: Text('Continue with Google'),
//           ),
//         ],
//       ),
//     );
//   }
// }
