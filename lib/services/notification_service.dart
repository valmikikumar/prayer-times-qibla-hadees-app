import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/prayer_time.dart';

/// Service for managing local notifications
/// 
/// Handles prayer time notifications and daily Hadees notifications
class NotificationService {
  static final NotificationService instance = NotificationService._init();
  static FlutterLocalNotificationsPlugin? _notifications;

  NotificationService._init();

  /// Get notifications plugin instance
  FlutterLocalNotificationsPlugin get notifications {
    _notifications ??= FlutterLocalNotificationsPlugin();
    return _notifications!;
  }

  /// Initialize notification service
  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();
    
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestPermissions();
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to specific screen
    debugPrint('Notification tapped: ${response.payload}');
  }

  /// Schedule prayer time notifications
  Future<void> schedulePrayerNotifications(List<PrayerTime> prayerTimes) async {
    // Cancel existing notifications
    await cancelAllNotifications();

    for (int i = 0; i < prayerTimes.length; i++) {
      final prayer = prayerTimes[i];
      final scheduledTime = tz.TZDateTime.from(
        prayer.time,
        tz.local,
      );

      // Schedule notification 5 minutes before prayer time
      final notificationTime = scheduledTime.subtract(const Duration(minutes: 5));

      await notifications.zonedSchedule(
        i + 1, // Unique ID for each prayer
        'Prayer Time Reminder',
        '${prayer.name} prayer is in 5 minutes',
        notificationTime,
        _getNotificationDetails(prayer.name),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'prayer_${prayer.name.toLowerCase()}',
      );
    }
  }

  /// Schedule daily Hadees notification
  Future<void> scheduleDailyHadeesNotification() async {
    // Schedule for 6:00 AM daily
    final now = DateTime.now();
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      6, // 6:00 AM
    );

    await notifications.zonedSchedule(
      100, // Unique ID for daily Hadees
      'Daily Hadees',
      'Read today\'s beautiful Hadees',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_hadees',
          'Daily Hadees',
          channelDescription: 'Daily Hadees notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'daily_hadees',
    );
  }

  /// Get notification details for prayer
  NotificationDetails _getNotificationDetails(String prayerName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_times',
        'Prayer Times',
        channelDescription: 'Prayer time notifications',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        sound: const RawResourceAndroidNotificationSound('adhan'),
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'adhan.caf',
      ),
    );
  }

  /// Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await notifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'immediate',
          'Immediate Notifications',
          channelDescription: 'Immediate notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await notifications.cancelAll();
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await notifications.cancel(id);
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await notifications.pendingNotificationRequests();
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final androidImplementation = notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }
    
    return true; // Assume enabled for iOS
  }

  /// Open notification settings
  Future<void> openNotificationSettings() async {
    final androidImplementation = notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      await androidImplementation.openNotificationSettings();
    }
  }
}
