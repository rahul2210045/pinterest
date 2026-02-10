import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/presentation/screens/board_tab.dart';
import 'package:pinterest/presentation/screens/collage_tab.dart';
import 'package:pinterest/presentation/screens/pins_tab.dart';
import 'package:pinterest/presentation/widgets/pinterest_widgets/profile_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;

  /// Default → Boards (index 1)
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentIndex,
    );

    _pageController = PageController(initialPage: _currentIndex);

    /// TAB → PAGE
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.go('/profile-detail');
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Text(
                  'r',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            /// PROFILE HEADER (avatar etc — keep yours)
            const SizedBox(height: 12),

            /// TAB BAR
            ProfileTabs(controller: _tabController),

            /// PAGES
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                  _tabController.animateTo(index);
                },
                children: const [PinsTab(), BoardsTab(), CollagesTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
