import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:clerk_auth/clerk_auth.dart' as clerk;

class AuthService {
  /// EMAIL + PASSWORD SIGN IN
  Future<void> signInWithPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final auth = ClerkAuth.of(context);

    await auth.attemptSignIn(
      strategy: clerk.Strategy.password,
      identifier: email,
      password: password,
    );
  }

  /// EMAIL + PASSWORD SIGN UP
  Future<void> signUpWithPassword({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required DateTime dob,
    required String gender,
    required String country,
  }) async {
    final auth = ClerkAuth.of(context);

    await auth.attemptSignUp(
      strategy: clerk.Strategy.password,
      emailAddress: email,
      password: password,
      passwordConfirmation: password,
      // username: name,
    );

    // Save extra profile data
    //   await auth.updateUser(
    // metadata: {
    //   "onboardingCompleted": false,
    // },
    // );
    // await auth.updateUser(
    //   metadata: {
    //     "dob": dob.toIso8601String(),
    //     "gender": gender,
    //     "country": country,
    //   },
    // );
  }

  /// GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    final auth = ClerkAuth.of(context);

    await auth.oauthSignIn(
      strategy: clerk.Strategy.oauthGoogle,
      redirect: Uri.parse('yourapp://oauth-callback'),
    );
  }

  /// LOGOUT
  Future<void> signOut(BuildContext context) async {
    final auth = ClerkAuth.of(context);
    await auth.signOut();
  }
}
