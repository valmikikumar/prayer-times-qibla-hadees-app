import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_time.dart';
import '../services/prayer_service.dart';

/// Provider for prayer times and location management
/// 
/// Handles prayer time calculations, location services, and user preferences
class PrayerProvider extends ChangeNotifier {
  final PrayerService _prayerService = PrayerService();
  
  // State variables
  List<PrayerTime> _prayerTimes = [];
  PrayerTime? _nextPrayer;
  String _currentLocation = '';
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  String? _error;
  String _calculationMethod = 'ISNA';
  bool _isLocationEnabled = false;

  // Getters
  List<PrayerTime> get prayerTimes => _prayerTimes;
  PrayerTime? get nextPrayer => _nextPrayer;
  String get currentLocation => _currentLocation;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get calculationMethod => _calculationMethod;
  bool get isLocationEnabled => _isLocationEnabled;

  /// Initialize prayer provider
  Future<void> initialize() async {
    await _loadSettings();
    await _getCurrentLocation();
    if (_latitude != null && _longitude != null) {
      await _fetchPrayerTimes();
    }
  }

  /// Load user settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _calculationMethod = prefs.getString('calculation_method') ?? 'ISNA';
    _isLocationEnabled = prefs.getBool('location_enabled') ?? true;
  }

  /// Get current device location
  Future<void> _getCurrentLocation() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Location permission denied';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Location permission permanently denied';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _latitude = position.latitude;
      _longitude = position.longitude;
      _isLocationEnabled = true;

      // Get location name (simplified - in production, use reverse geocoding)
      _currentLocation = '${_latitude!.toStringAsFixed(2)}, ${_longitude!.toStringAsFixed(2)}';

    } catch (e) {
      _error = 'Failed to get location: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch prayer times for current location
  Future<void> _fetchPrayerTimes() async {
    if (_latitude == null || _longitude == null) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prayerTimes = await _prayerService.getPrayerTimes(
        _latitude!,
        _longitude!,
        _calculationMethod,
      );

      _prayerTimes = prayerTimes;
      _updateNextPrayer();
      
    } catch (e) {
      _error = 'Failed to fetch prayer times: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update next prayer time
  void _updateNextPrayer() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    for (final prayer in _prayerTimes) {
      final prayerDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        prayer.time.hour,
        prayer.time.minute,
      );
      
      if (prayerDateTime.isAfter(now)) {
        _nextPrayer = prayer;
        return;
      }
    }
    
    // If no prayer found for today, get tomorrow's first prayer
    if (_prayerTimes.isNotEmpty) {
      _nextPrayer = _prayerTimes.first;
    }
  }

  /// Set calculation method
  Future<void> setCalculationMethod(String method) async {
    _calculationMethod = method;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calculation_method', method);
    
    if (_latitude != null && _longitude != null) {
      await _fetchPrayerTimes();
    }
  }

  /// Set manual location
  Future<void> setManualLocation(double latitude, double longitude, String locationName) async {
    _latitude = latitude;
    _longitude = longitude;
    _currentLocation = locationName;
    _isLocationEnabled = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('manual_latitude', latitude);
    await prefs.setDouble('manual_longitude', longitude);
    await prefs.setString('manual_location', locationName);
    await prefs.setBool('location_enabled', true);
    
    await _fetchPrayerTimes();
  }

  /// Refresh prayer times
  Future<void> refreshPrayerTimes() async {
    if (_isLocationEnabled) {
      await _getCurrentLocation();
      if (_latitude != null && _longitude != null) {
        await _fetchPrayerTimes();
      }
    }
  }

  /// Get time until next prayer
  Duration? getTimeUntilNextPrayer() {
    if (_nextPrayer == null) return null;
    
    final now = DateTime.now();
    final nextPrayerTime = DateTime(
      now.year,
      now.month,
      now.day,
      _nextPrayer!.time.hour,
      _nextPrayer!.time.minute,
    );
    
    if (nextPrayerTime.isBefore(now)) {
      // If prayer time has passed, get next day's first prayer
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowPrayerTime = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        _prayerTimes.first.time.hour,
        _prayerTimes.first.time.minute,
      );
      return tomorrowPrayerTime.difference(now);
    }
    
    return nextPrayerTime.difference(now);
  }
}
