import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/prayer_provider.dart';
import '../providers/hadees_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/prayer_times_card.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/todays_hadees_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

/// Home screen displaying prayer times, next prayer, and today's Hadees
/// 
/// Main dashboard of the app with key information at a glance
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prayer Times & Qibla',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return IconButton(
                icon: Icon(
                  settings.darkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => settings.toggleDarkMode(),
                tooltip: 'Toggle Theme',
              );
            },
          ),
        ],
      ),
      body: Consumer2<PrayerProvider, HadeesProvider>(
        builder: (context, prayerProvider, hadeesProvider, child) {
          if (prayerProvider.isLoading) {
            return const LoadingWidget();
          }

          if (prayerProvider.error != null) {
            return CustomErrorWidget(
              error: prayerProvider.error!,
              onRetry: () => prayerProvider.refreshPrayerTimes(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await prayerProvider.refreshPrayerTimes();
              await hadeesProvider.refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  _buildWelcomeMessage(context),
                  
                  const SizedBox(height: 16),
                  
                  // Next prayer card
                  if (prayerProvider.nextPrayer != null)
                    NextPrayerCard(prayer: prayerProvider.nextPrayer!),
                  
                  const SizedBox(height: 16),
                  
                  // Prayer times card
                  if (prayerProvider.prayerTimes.isNotEmpty)
                    PrayerTimesCard(prayerTimes: prayerProvider.prayerTimes),
                  
                  const SizedBox(height: 16),
                  
                  // Today's Hadees card
                  if (hadeesProvider.todaysHadees != null)
                    TodaysHadeesCard(hadees: hadeesProvider.todaysHadees!),
                  
                  const SizedBox(height: 16),
                  
                  // Quick actions
                  _buildQuickActions(context),
                  
                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build welcome message
  Widget _buildWelcomeMessage(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: GoogleFonts.amiri(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'May Allah bless your day',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// Build quick actions section
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.amiri(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.explore,
                title: 'Qibla',
                subtitle: 'Find Direction',
                onTap: () {
                  // Navigate to Qibla screen
                  DefaultTabController.of(context)?.animateTo(1);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.menu_book,
                title: 'Hadees',
                subtitle: 'Read More',
                onTap: () {
                  // Navigate to Hadees screen
                  DefaultTabController.of(context)?.animateTo(2);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.touch_app,
                title: 'Tasbeeh',
                subtitle: 'Count Dhikr',
                onTap: () {
                  // Navigate to More screen
                  DefaultTabController.of(context)?.animateTo(3);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.settings,
                title: 'Settings',
                subtitle: 'Configure',
                onTap: () {
                  // Navigate to More screen
                  DefaultTabController.of(context)?.animateTo(3);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build quick action card
  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
