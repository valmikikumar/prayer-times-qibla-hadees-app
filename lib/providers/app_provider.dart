import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Main app provider for global state management
/// 
/// Handles theme mode, language settings, and app-wide state
class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'en';
  bool _isFirstLaunch = true;
  bool _isPremium = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isPremium => _isPremium;

  /// Initialize app settings from SharedPreferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme mode
    final themeIndex = prefs.getInt('theme_mode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    
    // Load language
    _language = prefs.getString('language') ?? 'en';
    
    // Load first launch status
    _isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    
    // Load premium status
    _isPremium = prefs.getBool('is_premium') ?? false;
    
    notifyListeners();
  }

  /// Set theme mode (light, dark, or system)
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  /// Set app language
  Future<void> setLanguage(String language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    notifyListeners();
  }

  /// Mark first launch as completed
  Future<void> setFirstLaunchCompleted() async {
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
    notifyListeners();
  }

  /// Set premium status
  Future<void> setPremium(bool isPremium) async {
    _isPremium = isPremium;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', isPremium);
    notifyListeners();
  }

  /// Toggle premium status
  Future<void> togglePremium() async {
    await setPremium(!_isPremium);
  }
}
