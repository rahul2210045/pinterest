import 'package:flutter/material.dart';
import 'package:pinterest/core/controllers/profile_icon_controller.dart';
import 'package:pinterest/core/key/global_key.dart';
import 'package:pinterest/presentation/widgets/animation/confetti_painter.dart';
Future<void> playSavePinAnimation({
  required BuildContext context,
  required String imageUrl,
}) async {
  final overlay = Overlay.of(context);
  final screenSize = MediaQuery.of(context).size;

  final profileBox =
      profileTabKey.currentContext!.findRenderObject() as RenderBox;
  final profilePos = profileBox.localToGlobal(Offset.zero);
  final profileCenter = profilePos +
      Offset(profileBox.size.width / 2, profileBox.size.height / 2);

  late OverlayEntry entry;

  final controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 1050), 
  );

  final scaleAnim = TweenSequence([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.9)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 30,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.9, end: 1.05)
          .chain(CurveTween(curve: Curves.easeOutBack)),
      weight: 30,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.05, end: 0.0)
          .chain(CurveTween(curve: Curves.easeIn)),
      weight: 40,
    ),
  ]).animate(controller);

  final offsetAnim = Tween(
    begin: profileCenter - const Offset(0, 36),
    end: profileCenter,
  ).chain(CurveTween(curve: Curves.easeIn)).animate(controller);

  entry = OverlayEntry(
    builder: (_) => AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Positioned(
          left: offsetAnim.value.dx - 28,
          top: offsetAnim.value.dy - 28,
          child: Transform.scale(
            scale: scaleAnim.value,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    ),
  );

  profileIconVisibility.value = false;

  overlay.insert(entry);
  await controller.forward();

  entry.remove();
  controller.dispose();

  profileIconVisibility.value = true;

  showSquareConfetti(
    context,
    origin: profileCenter,
    maxHeight: screenSize.height * 0.25,
  );
}
