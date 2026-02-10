import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/models/search_input_arg.dart';
import 'package:pinterest/presentation/screens/auth_screens/country_picker_screen.dart';
import 'package:pinterest/presentation/screens/auth_screens/country_step.dart';
import 'package:pinterest/presentation/screens/auth_screens/create_password_screen.dart';
import 'package:pinterest/presentation/screens/auth_screens/dob_step.dart';
import 'package:pinterest/presentation/screens/auth_screens/email_screen.dart';
import 'package:pinterest/presentation/screens/auth_screens/gender_step.dart';
import 'package:pinterest/presentation/screens/auth_screens/name_step.dart';
import 'package:pinterest/presentation/screens/auth_screens/password_screen.dart';
import 'package:pinterest/presentation/screens/chat/chat_dashboard.dart';
import 'package:pinterest/presentation/screens/chat/chat_screen.dart';
import 'package:pinterest/presentation/screens/chat/message_settings.dart';
import 'package:pinterest/presentation/screens/chat/new_message_screen.dart';
import 'package:pinterest/presentation/screens/chat/see_more_screen.dart';
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
  final user = auth.user;

  final isLoggedIn = user != null;
  final onboardingDone =
      user?.unsafeMetadata?['onboardingCompleted'] == true;

  final location = state.matchedLocation;

  const authAllowedRoutes = [
    '/auth',
    '/password-screen',
    '/password-create',
    '/forgot-password',
  ];

  const onboardingAllowedRoutes = [
    '/step-name',
    '/step-dob',
    '/step-gender',
    '/step-country',
    '/country-picker',
  ];

  const shellRoutes = [
    '/',
    '/search',
    '/create',
    '/inbox',
    '/profile',
  ];

  if (!isLoggedIn) {
    if (authAllowedRoutes.contains(location)) return null;
    return '/auth';
  }


  if (!onboardingDone) {
    if (onboardingAllowedRoutes.contains(location)) return null;
    return '/step-name';
  }


  if (shellRoutes.any(location.startsWith)) {
    return null; 
  }

  return '/'; 
},

 
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => AuthEmailScreen(),
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
                 NoTransitionPage(child: InboxScreen()),
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

          return SearchResultScreen(query: query, args: args);
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
      GoRoute(
        path: '/password-screen',
        builder: (context, state) {
          final email = state.extra as String;
          return LoginPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: '/password-create',
        builder: (context, state) {
          final email = state.extra as String;
          return CreatePasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: '/step-name',
        builder: (context, state) {
          return NameScreen();
        },
      ),
      GoRoute(
        path: '/step-dob',
        builder: (context, state) {
          return DobScreen();
        },
      ),
      GoRoute(
        path: '/step-gender',
        builder: (context, state) {
          return GenderScreen();
        },
      ),
      GoRoute(
        path: '/step-country',
        builder: (context, state) => const CountryScreen(),
      ),
      GoRoute(
        path: '/country-picker',
        builder: (context, state) => CountryPickerScreen(),
      ),
      GoRoute(
        path: '/see-more-messages',
        builder: (context, state) => const SeeMoreMessagesScreen(),
      ),
      GoRoute(
        path: '/new-message',
        builder: (context, state) => const NewMessageScreen(),
      ),
       GoRoute(
        path: '/chat-screen',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(path:   '/message-settings', builder: (context, state) => const MessageSettingsScreen()),
    ],
  );
}

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
