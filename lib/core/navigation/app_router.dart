import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/screens/dashboard_screen.dart';
import 'package:pinterest/presentation/screens/detial_screen.dart';
import 'package:pinterest/presentation/screens/pin_focus_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),

    GoRoute(
      path: '/pin-detail',
      builder: (context, state) {
        final photo = state.extra as dynamic;
        return PinDetailScreen(photo: photo);
      },
    ),

    GoRoute(
      path: '/pin-focus',
      builder: (context, state) {
        final photo = state.extra as dynamic;
        return PinFocusScreen(photo: photo);
      },
    ),
  ],
);
