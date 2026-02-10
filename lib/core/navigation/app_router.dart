import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/models/search_input_arg.dart';
import 'package:pinterest/presentation/screens/auth_screens/auth_screen.dart';
import 'package:pinterest/presentation/screens/auth_screens/spalsh_screen.dart';
import 'package:pinterest/presentation/screens/board_tab.dart';
import 'package:pinterest/presentation/screens/dashboard_screen.dart';
import 'package:pinterest/presentation/screens/detial_screen.dart';
import 'package:pinterest/presentation/screens/pin_focus_screen.dart';
import 'package:pinterest/presentation/screens/profiel_detail_screen.dart';
import 'package:pinterest/presentation/screens/profile_screen.dart';
import 'package:pinterest/presentation/screens/recent_pin_screen.dart';
import 'package:pinterest/presentation/screens/search_input_screen.dart';
import 'package:pinterest/presentation/screens/search_page.dart';
import 'package:pinterest/presentation/screens/search_result_screen.dart';
import 'package:pinterest/reusable_element.dart/nav_bar.dart';
GoRouter createRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: ClerkAuth.of(context),
    redirect: (context, state) {
      final auth = ClerkAuth.of(context);
      final isSignedIn = auth.isSignedIn;

      final isAuthRoute = state.matchedLocation == '/auth';

      if (!isSignedIn && !isAuthRoute) {
        return '/auth';
      }

      if (isSignedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) =>  AuthScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return _NavShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            path: '/create',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Scaffold()),
          ),
          GoRoute(
            path: '/inbox',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Scaffold()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      GoRoute(
        path: '/pin-detail',
        builder: (context, state) {
          final photo = state.extra;
          return PinDetailScreen(photo: photo);
        },
      ),
GoRoute(
  path: '/search-input',
  builder: (context, state) {
    final args = state.extra is SearchInputArgs
        ? state.extra as SearchInputArgs
        : const SearchInputArgs();

    return SearchInputScreen(args: args);
  },
),
GoRoute(
  path: '/recent-pins',
  builder: (context, state) {
    final type = state.extra as String;
    return RecentPinsScreen(type: type);
  },
),
GoRoute(
  path: '/search-result',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;

    final query = extra['query'] as String;
    final args = extra['args'] as SearchInputArgs;

    return SearchResultScreen(
      query: query,
      args: args,
    );
  },
),
      GoRoute(
        path: '/pin-focus',
        builder: (context, state) {
          final photo = state.extra;
          return PinFocusScreen(photo: photo);
        },
      ),
      GoRoute(
        path: '/profile-detail',
        builder: (context, state) {
          final user = state.extra;
          return ProfileDetailScreen();
        },
      ),
    ],
  );
}

// final GoRouter appRouter = GoRouter(
//   initialLocation: '/',
//   redirect: (context, state) {
//     final isSignedIn = ClerkAuth.of(context).isSignedIn;

//     if (!isSignedIn && state.matchedLocation != '/auth') {
//       return '/auth';
//     }

//     if (isSignedIn && state.matchedLocation == '/auth') {
//       return '/';
//     }

//     return null;
//   },


//   routes: [
//     GoRoute(
//       path: '/auth',
//       builder: (context, state) => AuthStartScreen(),
//     ),
//     ShellRoute(
//       builder: (context, state, child) {
//         return _NavShell(child: child);
//       },
//       routes: [
//         GoRoute(
//           path: '/',
//           pageBuilder: (context, state) =>
//               const NoTransitionPage(child: DashboardScreen()),
//         ),

//         GoRoute(
//           path: '/search',
//           pageBuilder: (context, state) =>
//               const NoTransitionPage(child: SearchScreen()),
//         ),

//         GoRoute(
//           path: '/create',
//           pageBuilder: (context, state) =>
//               const NoTransitionPage(child: Scaffold()),
//         ),

//         GoRoute(
//           path: '/inbox',
//           pageBuilder: (context, state) =>
//               const NoTransitionPage(child: Scaffold()),
//         ),

//         GoRoute(
//           path: '/profile',
//           pageBuilder: (context, state) =>
//               const NoTransitionPage(child: ProfileScreen()),
//         ),
//       ],
//     ),

//     GoRoute(
//       path: '/pin-detail',
//       builder: (context, state) {
//         final photo = state.extra;
//         return PinDetailScreen(photo: photo);
//       },
//     ),

//     GoRoute(
//       path: '/pin-focus',
//       builder: (context, state) {
//         final photo = state.extra;
//         return PinFocusScreen(photo: photo);
//       },
//     ),
    
// GoRoute(
//   path: '/search-input',
//   builder: (context, state) {
//     final args = state.extra is SearchInputArgs
//         ? state.extra as SearchInputArgs
//         : const SearchInputArgs();

//     return SearchInputScreen(args: args);
//   },
// ),

// //    GoRoute(
// //   path: '/search-input',
// //   builder: (_, __) => const SearchInputScreen(),
// // ),
// GoRoute(
//   path: '/recent-pins',
//   builder: (context, state) {
//     final type = state.extra as String;
//     return RecentPinsScreen(type: type);
//   },
// ),
// GoRoute(
//   path: '/search-result',
//   builder: (context, state) {
//     final extra = state.extra as Map<String, dynamic>;

//     final query = extra['query'] as String;
//     final args = extra['args'] as SearchInputArgs;

//     return SearchResultScreen(
//       query: query,
//       args: args,
//     );
//   },
// ),


// // GoRoute(
// //   path: '/search-result',
// //   builder: (context, state) {
// //     final query = state.extra as String;
// //     return SearchResultScreen(query: query);
// //   },
// // ),

//   ],
// );

class _NavShell extends StatefulWidget {
  final Widget child;
  const _NavShell({required this.child});

  @override
  State<_NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<_NavShell> {
  int _indexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/create')) return 2;
    if (location.startsWith('/inbox')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/create');
        break;
      case 3:
        context.go('/inbox');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: PinterestBottomNav(
        selectedIndex: currentIndex,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}

