import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri.dart';

/// Islamic calendar widget
/// 
/// Displays Hijri calendar alongside Gregorian calendar
class IslamicCalendarWidget extends StatefulWidget {
  const IslamicCalendarWidget({super.key});

  @override
  State<IslamicCalendarWidget> createState() => _IslamicCalendarWidgetState();
}

class _IslamicCalendarWidgetState extends State<IslamicCalendarWidget> {
  late HijriDate _hijriDate;
  late DateTime _gregorianDate;

  @override
  void initState() {
    super.initState();
    _updateDates();
  }

  /// Update dates
  void _updateDates() {
    _gregorianDate = DateTime.now();
    _hijriDate = HijriDate.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current date card
            _buildCurrentDateCard(),
            
            const SizedBox(height: 24),
            
            // Calendar information
            _buildCalendarInfo(),
            
            const SizedBox(height: 24),
            
            // Important Islamic dates
            _buildImportantDates(),
          ],
        ),
      ),
    );
  }

  /// Build current date card
  Widget _buildCurrentDateCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Gregorian date
            Text(
              'Gregorian Calendar',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatGregorianDate(_gregorianDate),
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Hijri date
            Text(
              'Hijri Calendar',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatHijriDate(_hijriDate),
              style: GoogleFonts.amiri(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build calendar information
  Widget _buildCalendarInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar Information',
              style: GoogleFonts.amiri(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildInfoRow('Hijri Year', _hijriDate.hYear.toString()),
            _buildInfoRow('Hijri Month', _getHijriMonthName(_hijriDate.hMonth)),
            _buildInfoRow('Hijri Day', _hijriDate.hDay.toString()),
            _buildInfoRow('Weekday', _getWeekdayName(_gregorianDate.weekday)),
            _buildInfoRow('Day of Year', _gregorianDate.difference(DateTime(_gregorianDate.year, 1, 1)).inDays + 1),
          ],
        ),
      ),
    );
  }

  /// Build important dates
  Widget _buildImportantDates() {
    final importantDates = _getImportantDates();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Important Islamic Dates',
              style: GoogleFonts.amiri(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ...importantDates.map((date) => _buildImportantDateItem(date)),
          ],
        ),
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build important date item
  Widget _buildImportantDateItem(Map<String, String> date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date['name']!,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date['date']!,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Format Gregorian date
  String _formatGregorianDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Format Hijri date
  String _formatHijriDate(HijriDate date) {
    return '${date.hDay} ${_getHijriMonthName(date.hMonth)} ${date.hYear} AH';
  }

  /// Get Hijri month name
  String _getHijriMonthName(int month) {
    const months = [
      'Muharram', 'Safar', 'Rabi\' al-awwal', 'Rabi\' al-thani',
      'Jumada al-awwal', 'Jumada al-thani', 'Rajab', 'Sha\'ban',
      'Ramadan', 'Shawwal', 'Dhu al-Qi\'dah', 'Dhu al-Hijjah'
    ];
    
    return months[month - 1];
  }

  /// Get weekday name
  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    
    return weekdays[weekday - 1];
  }

  /// Get important Islamic dates
  List<Map<String, String>> _getImportantDates() {
    return [
      {
        'name': 'Ramadan',
        'date': '9th month of Hijri calendar',
      },
      {
        'name': 'Eid al-Fitr',
        'date': '1st Shawwal',
      },
      {
        'name': 'Hajj',
        'date': '8th-13th Dhu al-Hijjah',
      },
      {
        'name': 'Eid al-Adha',
        'date': '10th Dhu al-Hijjah',
      },
      {
        'name': 'Ashura',
        'date': '10th Muharram',
      },
      {
        'name': 'Mawlid al-Nabi',
        'date': '12th Rabi\' al-awwal',
      },
    ];
  }
}
