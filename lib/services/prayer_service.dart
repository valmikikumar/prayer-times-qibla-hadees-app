import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';

/// Service for fetching prayer times from AlAdhan API
/// 
/// Handles API communication and data parsing for prayer times
class PrayerService {
  static const String _baseUrl = 'https://api.aladhan.com/v1/timings';
  
  /// Prayer names mapping
  static const Map<String, Map<String, String>> _prayerNames = {
    'Fajr': {'name': 'Fajr', 'arabic': 'الفجر'},
    'Dhuhr': {'name': 'Dhuhr', 'arabic': 'الظهر'},
    'Asr': {'name': 'Asr', 'arabic': 'العصر'},
    'Maghrib': {'name': 'Maghrib', 'arabic': 'المغرب'},
    'Isha': {'name': 'Isha', 'arabic': 'العشاء'},
  };

  /// Get prayer times for given coordinates
  /// 
  /// [latitude] - Latitude coordinate
  /// [longitude] - Longitude coordinate  
  /// [method] - Calculation method (ISNA, MWL, Umm al-Qura, etc.)
  Future<List<PrayerTime>> getPrayerTimes(
    double latitude,
    double longitude,
    String method,
  ) async {
    try {
      final url = '$_baseUrl/$_getDateString?latitude=$latitude&longitude=$longitude&method=${_getMethodCode(method)}';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parsePrayerTimes(data);
      } else {
        throw Exception('Failed to fetch prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }

  /// Get prayer times for a specific city
  /// 
  /// [city] - City name
  /// [country] - Country name
  /// [method] - Calculation method
  Future<List<PrayerTime>> getPrayerTimesByCity(
    String city,
    String country,
    String method,
  ) async {
    try {
      final url = '$_baseUrl/$_getDateString?city=$city&country=$country&method=${_getMethodCode(method)}';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parsePrayerTimes(data);
      } else {
        throw Exception('Failed to fetch prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }

  /// Parse prayer times from API response
  List<PrayerTime> _parsePrayerTimes(Map<String, dynamic> data) {
    final List<PrayerTime> prayerTimes = [];
    
    if (data['data'] != null && data['data']['timings'] != null) {
      final timings = data['data']['timings'] as Map<String, dynamic>;
      
      int order = 0;
      for (final entry in _prayerNames.entries) {
        final prayerKey = entry.key;
        final prayerInfo = entry.value;
        
        if (timings.containsKey(prayerKey)) {
          final timeString = timings[prayerKey] as String;
          final time = _parseTimeString(timeString);
          
          prayerTimes.add(PrayerTime(
            name: prayerInfo['name']!,
            arabicName: prayerInfo['arabic']!,
            time: time,
            timeString: timeString,
            order: order++,
          ));
        }
      }
    }
    
    return prayerTimes;
  }

  /// Parse time string to DateTime
  DateTime _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  /// Get current date string for API
  String _getDateString() {
    final now = DateTime.now();
    return '${now.day}-${now.month}-${now.year}';
  }

  /// Get method code for API
  int _getMethodCode(String method) {
    const methodCodes = {
      'ISNA': 2,
      'MWL': 3,
      'Umm al-Qura': 4,
      'Egyptian': 5,
      'Karachi': 1,
      'Tehran': 7,
      'Makkah': 4,
      'Dubai': 5,
    };
    
    return methodCodes[method] ?? 2; // Default to ISNA
  }

  /// Get available calculation methods
  static List<String> getCalculationMethods() {
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

  /// Get method description
  static String getMethodDescription(String method) {
    const descriptions = {
      'ISNA': 'Islamic Society of North America',
      'MWL': 'Muslim World League',
      'Umm al-Qura': 'Umm al-Qura University, Makkah',
      'Egyptian': 'Egyptian General Authority of Survey',
      'Karachi': 'University of Islamic Sciences, Karachi',
      'Tehran': 'Institute of Geophysics, University of Tehran',
      'Makkah': 'Umm al-Qura University, Makkah',
      'Dubai': 'Dubai (UAE)',
    };
    
    return descriptions[method] ?? method;
  }
}
