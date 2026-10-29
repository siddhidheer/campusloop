import 'package:flutter/material.dart';
import '../theme/campus_theme.dart';
import 'home/home_screen.dart';
import 'discover/discover_screen.dart';
import 'communities/communities_screen.dart';
import 'updates/updates_screen.dart';
import 'profile/profile_screen.dart';

/// Main app shell with bottom navigation.
/// Five tabs: Home, Discover, Communities, Updates, Profile.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  static void switchTab(BuildContext context, int index, {int? subTab}) {
    if (index == 1 && subTab != null) {
      DiscoverScreen.switchToSubTab(subTab);
    }
    final state = context.findAncestorStateOfType<_AppShellState>();
    state?.setTab(index, subTab: subTab);
  }

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  int _discoverSubTab = 0;
  int _discoverKeyNonce = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    });
  }

  void setTab(int index, {int? subTab}) {
    if (mounted && index >= 0 && index < 5) {
      if (index == 0 && _currentIndex != 0) {
        HomeScreen.refreshNotifier.value++;
      }
      setState(() {
        _currentIndex = index;
        if (subTab != null) {
          _discoverSubTab = subTab;
          _discoverKeyNonce++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      DiscoverScreen(
        key: ValueKey('discover_${_discoverSubTab}_$_discoverKeyNonce'),
        initialSubTab: _discoverSubTab,
      ),
      const CommunitiesScreen(),
      const UpdatesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: CampusTheme.divider.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0 && _currentIndex != 0) {
              HomeScreen.refreshNotifier.value++;
            }
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore_rounded),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people_rounded),
              label: 'Communities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              activeIcon: Icon(Icons.campaign_rounded),
              label: 'Updates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
