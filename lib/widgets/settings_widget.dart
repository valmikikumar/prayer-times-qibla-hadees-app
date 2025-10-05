import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';
import '../providers/app_provider.dart';

/// Settings widget
/// 
/// Provides app configuration options and settings
class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Prayer settings
            _buildPrayerSettings(context),
            
            const SizedBox(height: 16),
            
            // Notification settings
            _buildNotificationSettings(context),
            
            const SizedBox(height: 16),
            
            // App settings
            _buildAppSettings(context),
            
            const SizedBox(height: 16),
            
            // About section
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }

  /// Build prayer settings
  Widget _buildPrayerSettings(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prayer Settings',
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Calculation method
                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text('Calculation Method'),
                  subtitle: Text(settings.calculationMethod),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showCalculationMethodDialog(context),
                ),
                
                const Divider(),
                
                // Location settings
                SwitchListTile(
                  secondary: const Icon(Icons.location_on),
                  title: const Text('Use Location'),
                  subtitle: const Text('Automatically detect location'),
                  value: settings.locationEnabled,
                  onChanged: (value) => settings.setLocationEnabled(value),
                ),
                
                const Divider(),
                
                // Adhan sound
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up),
                  title: const Text('Adhan Sound'),
                  subtitle: const Text('Play Adhan for prayer times'),
                  value: settings.adhanSound,
                  onChanged: (value) => settings.setAdhanSound(value),
                ),
                
                if (settings.adhanSound) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.music_note),
                    title: const Text('Adhan Type'),
                    subtitle: Text(settings.getAdhanTypeDisplayName(settings.adhanType)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showAdhanTypeDialog(context),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build notification settings
  Widget _buildNotificationSettings(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Settings',
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Prayer notifications
                SwitchListTile(
                  secondary: const Icon(Icons.schedule),
                  title: const Text('Prayer Notifications'),
                  subtitle: const Text('Notify before prayer times'),
                  value: settings.prayerNotifications,
                  onChanged: (value) => settings.setPrayerNotifications(value),
                ),
                
                const Divider(),
                
                // Hadees notifications
                SwitchListTile(
                  secondary: const Icon(Icons.menu_book),
                  title: const Text('Daily Hadees'),
                  subtitle: const Text('Daily Hadees notification'),
                  value: settings.hadeesNotifications,
                  onChanged: (value) => settings.setHadeesNotifications(value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build app settings
  Widget _buildAppSettings(BuildContext context) {
    return Consumer2<SettingsProvider, AppProvider>(
      builder: (context, settings, appProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Settings',
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Theme mode
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Theme'),
                  subtitle: Text(_getThemeModeText(appProvider.themeMode)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showThemeModeDialog(context),
                ),
                
                const Divider(),
                
                // Language
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: Text(settings.getLanguageDisplayName(settings.language)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showLanguageDialog(context),
                ),
                
                const Divider(),
                
                // Haptic feedback
                SwitchListTile(
                  secondary: const Icon(Icons.vibration),
                  title: const Text('Haptic Feedback'),
                  subtitle: const Text('Vibrate on interactions'),
                  value: settings.hapticFeedback,
                  onChanged: (value) => settings.setHapticFeedback(value),
                ),
                
                const Divider(),
                
                // Ads settings
                SwitchListTile(
                  secondary: const Icon(Icons.ad_units),
                  title: const Text('Show Ads'),
                  subtitle: Text(appProvider.isPremium ? 'Premium - No Ads' : 'Free version with ads'),
                  value: !appProvider.isPremium && settings.adsEnabled,
                  onChanged: appProvider.isPremium ? null : (value) => settings.setAdsEnabled(value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build about section
  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: GoogleFonts.amiri(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showPrivacyPolicy(context),
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showHelpSupport(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Show calculation method dialog
  void _showCalculationMethodDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final methods = settings.getCalculationMethods();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calculation Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: methods.map((method) {
            return RadioListTile<String>(
              title: Text(method),
              subtitle: Text(settings.getMethodDescription(method)),
              value: method,
              groupValue: settings.calculationMethod,
              onChanged: (value) {
                if (value != null) {
                  settings.setCalculationMethod(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Show Adhan type dialog
  void _showAdhanTypeDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final types = settings.getAdhanTypes();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adhan Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: types.map((type) {
            return RadioListTile<String>(
              title: Text(settings.getAdhanTypeDisplayName(type)),
              value: type,
              groupValue: settings.adhanType,
              onChanged: (value) {
                if (value != null) {
                  settings.setAdhanType(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Show theme mode dialog
  void _showThemeModeDialog(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: appProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: appProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: appProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Show language dialog
  void _showLanguageDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final languages = settings.getLanguages();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            return RadioListTile<String>(
              title: Text(settings.getLanguageDisplayName(language)),
              value: language,
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  settings.setLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Show privacy policy
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This app respects your privacy and does not collect personal data. '
            'Location data is used only for prayer time calculations and is not stored. '
            'All data is stored locally on your device.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show help and support
  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const SingleChildScrollView(
          child: Text(
            'For support and feedback, please contact us at:\n\n'
            'Email: support@prayertimesapp.com\n'
            'Website: www.prayertimesapp.com\n\n'
            'We appreciate your feedback and suggestions.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Get theme mode text
  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
