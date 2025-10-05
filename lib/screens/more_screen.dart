import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/tasbeeh_widget.dart';
import '../widgets/duas_widget.dart';
import '../widgets/islamic_calendar_widget.dart';
import '../widgets/settings_widget.dart';

/// More screen with additional features
/// 
/// Contains Tasbeeh counter, Duas collection, Islamic calendar, and settings
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'More Features',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              icon: Icon(Icons.touch_app),
              text: 'Tasbeeh',
            ),
            Tab(
              icon: Icon(Icons.favorite),
              text: 'Duas',
            ),
            Tab(
              icon: Icon(Icons.calendar_today),
              text: 'Calendar',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TasbeehWidget(),
          DuasWidget(),
          IslamicCalendarWidget(),
          SettingsWidget(),
        ],
      ),
    );
  }
}
