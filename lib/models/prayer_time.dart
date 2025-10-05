/// Model class for prayer time data
/// 
/// Represents a single prayer time with name, time, and additional metadata
class PrayerTime {
  final String name;
  final String arabicName;
  final DateTime time;
  final String timeString;
  final bool isNext;
  final int order;

  const PrayerTime({
    required this.name,
    required this.arabicName,
    required this.time,
    required this.timeString,
    this.isNext = false,
    required this.order,
  });

  /// Create PrayerTime from JSON data
  factory PrayerTime.fromJson(Map<String, dynamic> json, int order) {
    return PrayerTime(
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? '',
      time: DateTime.parse(json['time']),
      timeString: json['timeString'] ?? '',
      isNext: json['isNext'] ?? false,
      order: order,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arabicName': arabicName,
      'time': time.toIso8601String(),
      'timeString': timeString,
      'isNext': isNext,
      'order': order,
    };
  }

  /// Get prayer time in 12-hour format
  String get formattedTime {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Get prayer time in 24-hour format
  String get formattedTime24 {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'PrayerTime(name: $name, time: $timeString)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrayerTime &&
        other.name == name &&
        other.time == time;
  }

  @override
  int get hashCode => name.hashCode ^ time.hashCode;
}
