import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/prayer_time.dart';

/// Widget displaying the next prayer with countdown
/// 
/// Shows the upcoming prayer time with a countdown timer
class NextPrayerCard extends StatefulWidget {
  final PrayerTime prayer;

  const NextPrayerCard({
    super.key,
    required this.prayer,
  });

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  late Duration _timeRemaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Update time remaining until next prayer
  void _updateTimeRemaining() {
    final now = DateTime.now();
    final prayerTime = DateTime(
      now.year,
      now.month,
      now.day,
      widget.prayer.time.hour,
      widget.prayer.time.minute,
    );

    if (prayerTime.isAfter(now)) {
      setState(() {
        _timeRemaining = prayerTime.difference(now);
      });
    } else {
      // If prayer time has passed, get next day's first prayer
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowPrayerTime = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        5, // Assuming Fajr is around 5 AM
        0,
      );
      setState(() {
        _timeRemaining = tomorrowPrayerTime.difference(now);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Next Prayer',
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Prayer name and Arabic
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prayer.name,
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.prayer.arabicName,
                        style: GoogleFonts.amiri(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.prayer.formattedTime,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.prayer.formattedTime24,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Countdown timer
            _buildCountdownTimer(),
          ],
        ),
      ),
    );
  }

  /// Build countdown timer display
  Widget _buildCountdownTimer() {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimeUnit('Hours', hours.toString().padLeft(2, '0')),
          _buildTimeSeparator(),
          _buildTimeUnit('Minutes', minutes.toString().padLeft(2, '0')),
          _buildTimeSeparator(),
          _buildTimeUnit('Seconds', seconds.toString().padLeft(2, '0')),
        ],
      ),
    );
  }

  /// Build individual time unit
  Widget _buildTimeUnit(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  /// Build time separator
  Widget _buildTimeSeparator() {
    return Text(
      ':',
      style: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
