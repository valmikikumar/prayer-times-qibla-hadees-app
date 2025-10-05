import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/hadees_provider.dart';
import '../providers/settings_provider.dart';
import 'home_screen.dart';
import 'qibla_screen.dart';
import 'hadees_screen.dart';
import 'more_screen.dart';
import '../widgets/ad_banner.dart';

/// Main screen with bottom navigation
/// 
/// Contains the primary navigation structure of the app
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // Screen list for bottom navigation
  final List<Widget> _screens = [
    const HomeScreen(),
    const QiblaScreen(),
    const HadeesScreen(),
    const MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  /// Initialize all providers
  Future<void> _initializeProviders() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
    final hadeesProvider = Provider.of<HadeesProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    // Initialize all providers
    await Future.wait([
      appProvider.initialize(),
      prayerProvider.initialize(),
      hadeesProvider.initialize(),
      settingsProvider.initialize(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ad banner (if not premium)
              if (!appProvider.isPremium) const AdBanner(),
              
              // Bottom navigation
              BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabTapped,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore),
                    activeIcon: Icon(Icons.explore),
                    label: 'Qibla',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book),
                    activeIcon: Icon(Icons.menu_book),
                    label: 'Hadees',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz),
                    activeIcon: Icon(Icons.more_horiz),
                    label: 'More',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// Handle tab selection
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
