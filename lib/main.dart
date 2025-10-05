import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'providers/app_provider.dart';
import 'providers/prayer_provider.dart';
import 'providers/hadees_provider.dart';
import 'providers/settings_provider.dart';
import 'services/notification_service.dart';
import 'services/database_service.dart';
import 'screens/main_screen.dart';
import 'utils/theme.dart';

/// Main entry point of the Prayer Times & Qibla app
/// 
/// This app provides comprehensive Islamic features including:
/// - Prayer times with countdown
/// - Qibla compass and map
/// - Daily Hadees collection
/// - Digital Tasbeeh counter
/// - Islamic calendar
/// - Duas collection
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone data for notifications
  tz.initializeTimeZones();
  
  // Initialize database
  await DatabaseService.instance.initializeDatabase();
  
  // Initialize notification service
  await NotificationService.instance.initialize();
  
  runApp(const PrayerTimesApp());
}

class PrayerTimesApp extends StatelessWidget {
  const PrayerTimesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => HadeesProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'Prayer Times & Qibla',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.themeMode,
            home: const MainScreen(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
