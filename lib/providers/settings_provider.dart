import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for app settings management
/// 
/// Handles user preferences for notifications, adhan settings, and app configuration
class SettingsProvider extends ChangeNotifier {
  // Notification settings
  bool _prayerNotifications = true;
  bool _hadeesNotifications = true;
  bool _adhanSound = true;
  String _adhanType = 'full'; // 'full', 'short', 'silent'
  
  // Prayer settings
  String _calculationMethod = 'ISNA';
  bool _locationEnabled = true;
  
  // App settings
  bool _darkMode = false;
  String _language = 'en';
  bool _hapticFeedback = true;
  
  // Ad settings
  bool _adsEnabled = true;
  bool _isPremium = false;

  // Getters
  bool get prayerNotifications => _prayerNotifications;
  bool get hadeesNotifications => _hadeesNotifications;
  bool get adhanSound => _adhanSound;
  String get adhanType => _adhanType;
  String get calculationMethod => _calculationMethod;
  bool get locationEnabled => _locationEnabled;
  bool get darkMode => _darkMode;
  String get language => _language;
  bool get hapticFeedback => _hapticFeedback;
  bool get adsEnabled => _adsEnabled;
  bool get isPremium => _isPremium;

  /// Initialize settings from SharedPreferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    _prayerNotifications = prefs.getBool('prayer_notifications') ?? true;
    _hadeesNotifications = prefs.getBool('hadees_notifications') ?? true;
    _adhanSound = prefs.getBool('adhan_sound') ?? true;
    _adhanType = prefs.getString('adhan_type') ?? 'full';
    _calculationMethod = prefs.getString('calculation_method') ?? 'ISNA';
    _locationEnabled = prefs.getBool('location_enabled') ?? true;
    _darkMode = prefs.getBool('dark_mode') ?? false;
    _language = prefs.getString('language') ?? 'en';
    _hapticFeedback = prefs.getBool('haptic_feedback') ?? true;
    _adsEnabled = prefs.getBool('ads_enabled') ?? true;
    _isPremium = prefs.getBool('is_premium') ?? false;
    
    notifyListeners();
  }

  /// Set prayer notifications
  Future<void> setPrayerNotifications(bool enabled) async {
    _prayerNotifications = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prayer_notifications', enabled);
    notifyListeners();
  }

  /// Set Hadees notifications
  Future<void> setHadeesNotifications(bool enabled) async {
    _hadeesNotifications = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hadees_notifications', enabled);
    notifyListeners();
  }

  /// Set Adhan sound
  Future<void> setAdhanSound(bool enabled) async {
    _adhanSound = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_sound', enabled);
    notifyListeners();
  }

  /// Set Adhan type
  Future<void> setAdhanType(String type) async {
    _adhanType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhan_type', type);
    notifyListeners();
  }

  /// Set calculation method
  Future<void> setCalculationMethod(String method) async {
    _calculationMethod = method;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calculation_method', method);
    notifyListeners();
  }

  /// Set location enabled
  Future<void> setLocationEnabled(bool enabled) async {
    _locationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_enabled', enabled);
    notifyListeners();
  }

  /// Set dark mode
  Future<void> setDarkMode(bool enabled) async {
    _darkMode = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', enabled);
    notifyListeners();
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    notifyListeners();
  }

  /// Set haptic feedback
  Future<void> setHapticFeedback(bool enabled) async {
    _hapticFeedback = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptic_feedback', enabled);
    notifyListeners();
  }

  /// Set ads enabled
  Future<void> setAdsEnabled(bool enabled) async {
    _adsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ads_enabled', enabled);
    notifyListeners();
  }

  /// Set premium status
  Future<void> setPremium(bool isPremium) async {
    _isPremium = isPremium;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', isPremium);
    notifyListeners();
  }

  /// Toggle prayer notifications
  Future<void> togglePrayerNotifications() async {
    await setPrayerNotifications(!_prayerNotifications);
  }

  /// Toggle Hadees notifications
  Future<void> toggleHadeesNotifications() async {
    await setHadeesNotifications(!_hadeesNotifications);
  }

  /// Toggle Adhan sound
  Future<void> toggleAdhanSound() async {
    await setAdhanSound(!_adhanSound);
  }

  /// Toggle location
  Future<void> toggleLocation() async {
    await setLocationEnabled(!_locationEnabled);
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    await setDarkMode(!_darkMode);
  }

  /// Toggle haptic feedback
  Future<void> toggleHapticFeedback() async {
    await setHapticFeedback(!_hapticFeedback);
  }

  /// Toggle ads
  Future<void> toggleAds() async {
    await setAdsEnabled(!_adsEnabled);
  }

  /// Get available calculation methods
  List<String> getCalculationMethods() {
    return [
      'ISNA',
      'MWL',
      'Umm al-Qura',
      'Egyptian',
      'Karachi',
      'Tehran',
      'Makkah',
      'Dubai',
    ];
  }

  /// Get available languages
  List<String> getLanguages() {
    return ['en', 'ur', 'ar'];
  }

  /// Get available Adhan types
  List<String> getAdhanTypes() {
    return ['full', 'short', 'silent'];
  }

  /// Get language display name
  String getLanguageDisplayName(String language) {
    switch (language) {
      case 'en':
        return 'English';
      case 'ur':
        return 'اردو';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  /// Get Adhan type display name
  String getAdhanTypeDisplayName(String type) {
    switch (type) {
      case 'full':
        return 'Full Adhan';
      case 'short':
        return 'Short Beep';
      case 'silent':
        return 'Silent';
      default:
        return 'Full Adhan';
    }
  }
}
