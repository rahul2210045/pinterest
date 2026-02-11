import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = ClerkAuth.of(context);
    final user = auth.user;

    final name =
        user?.firstName ?? user?.username ?? 'Rahul'; 
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'R';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeader(
              firstLetter: firstLetter,
              name: name,
              onTap: () {
              },
            ),

            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 8),

            _SettingsTile(title: 'Account management'),
            _SettingsTile(title: 'Profile visibility'),
            _SettingsTile(title: 'Refine your recommendations'),
            _SettingsTile(title: 'Claimed external accounts'),
            _SettingsTile(title: 'Social permissions'),
            _SettingsTile(title: 'Notifications'),
            _SettingsTile(title: 'Privacy and data'),
            _SettingsTile(title: 'Reports and violations center'),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 8),

            _SettingsTile(title: 'Add account'),
            _SettingsTile(title: 'Security'),

            const SizedBox(height: 16),

            _LogoutTile(
              onTap: () async {
                await auth.signOut();
              },
            ),

            const SizedBox(height: 24),

            _SettingsTile(title: 'Support'),
            _SettingsTile(title: 'Help center'),
            _SettingsTile(title: 'Terms of service'),
            _SettingsTile(title: 'Privacy policy'),
            _SettingsTile(title: 'About'),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
class _SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
class _LogoutTile extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(
          'Log out',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}



class _ProfileHeader extends StatelessWidget {
  final String firstLetter;
  final String name;
  final VoidCallback onTap;

  const _ProfileHeader({
    required this.firstLetter,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blueAccent,
              child: Text(
                firstLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'View profile',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
