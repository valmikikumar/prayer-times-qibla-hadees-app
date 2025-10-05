import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/prayer_time.dart';

/// Widget displaying all prayer times in a card format
/// 
/// Shows the five daily prayers with their times and Arabic names
class PrayerTimesCard extends StatelessWidget {
  final List<PrayerTime> prayerTimes;

  const PrayerTimesCard({
    super.key,
    required this.prayerTimes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Prayer Times',
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...prayerTimes.map((prayer) => _buildPrayerTimeItem(context, prayer)),
          ],
        ),
      ),
    );
  }

  /// Build individual prayer time item
  Widget _buildPrayerTimeItem(BuildContext context, PrayerTime prayer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: prayer.isNext 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: prayer.isNext 
            ? Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              )
            : null,
      ),
      child: Row(
        children: [
          // Prayer icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getPrayerColor(prayer.name).withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              _getPrayerIcon(prayer.name),
              color: _getPrayerColor(prayer.name),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Prayer details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      prayer.name,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (prayer.isNext) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'NEXT',
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  prayer.arabicName,
                  style: GoogleFonts.amiri(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          
          // Prayer time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                prayer.formattedTime,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: prayer.isNext 
                      ? Theme.of(context).primaryColor
                      : null,
                ),
              ),
              Text(
                prayer.formattedTime24,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get prayer color based on prayer name
  Color _getPrayerColor(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Colors.deepPurple;
      case 'dhuhr':
        return Colors.orange;
      case 'asr':
        return Colors.blue;
      case 'maghrib':
        return Colors.red;
      case 'isha':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  /// Get prayer icon based on prayer name
  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Icons.wb_sunny;
      case 'dhuhr':
        return Icons.wb_sunny_outlined;
      case 'asr':
        return Icons.wb_cloudy;
      case 'maghrib':
        return Icons.wb_sunny;
      case 'isha':
        return Icons.nightlight_round;
      default:
        return Icons.schedule;
    }
  }
}
