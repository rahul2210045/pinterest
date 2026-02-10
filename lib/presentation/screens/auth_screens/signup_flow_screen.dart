import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:pinterest/core/controllers/auth_controller.dart';
import 'package:pinterest/core/controllers/signup_controller.dart';
import 'package:pinterest/presentation/screens/auth_screens/country_step.dart';
import 'package:pinterest/presentation/screens/auth_screens/dob_step.dart';
import 'package:pinterest/presentation/screens/auth_screens/gender_step.dart';
import 'package:pinterest/presentation/screens/auth_screens/name_step.dart';
import 'package:pinterest/presentation/screens/auth_screens/password_step.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/progress_dot.dart';

class SignupFlowScreen extends ConsumerStatefulWidget {
  final String email;
  const SignupFlowScreen({super.key, required this.email});

  @override
  ConsumerState<SignupFlowScreen> createState() =>
      _SignupFlowScreenState();
}

class _SignupFlowScreenState extends ConsumerState<SignupFlowScreen> {
  final PageController _pageController = PageController();
  int step = 0;

  void nextStep() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    setState(() => step++);
  }

  @override
  Widget build(BuildContext context) {
    final signupData = ref.watch(signupProvider(widget.email));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            ProgressDots(current: step, total: 5),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PasswordStep(onNext: nextStep),
                  NameStep(onNext: nextStep),
                  DobStep(onNext: nextStep),
                  GenderStep(onNext: nextStep),
                  CountryStep(
                    onFinish: () async {
                      // await ref
                      //     .read(authProvider.notifier)
                      //     .completeSignup(signupData);
                      // context.go('/');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
