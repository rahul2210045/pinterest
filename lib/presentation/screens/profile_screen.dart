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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push('/profile-detail');
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      child: Text(
                        'r',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(child: ProfileTabs(controller: _tabController)),
                ],
              ),
            ),

           
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
