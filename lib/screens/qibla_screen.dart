import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../widgets/qibla_compass.dart';
import '../widgets/qibla_map.dart';

/// Qibla screen with compass and map functionality
/// 
/// Provides Qibla direction using device compass and GPS
class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  double? _deviceHeading;
  double? _qiblaDirection;
  bool _isCompassAvailable = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeCompass();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Initialize compass functionality
  void _initializeCompass() async {
    try {
      // Check if compass is available
      final compassAvailable = await FlutterCompass.events?.first;
      if (compassAvailable != null) {
        setState(() {
          _isCompassAvailable = true;
        });

        // Listen to compass events
        FlutterCompass.events?.listen((event) {
          if (mounted) {
            setState(() {
              _deviceHeading = event.heading;
              _qiblaDirection = _calculateQiblaDirection();
            });
          }
        });
      } else {
        setState(() {
          _error = 'Compass not available on this device';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize compass: $e';
      });
    }
  }

  /// Calculate Qibla direction (simplified calculation)
  /// In a real app, you would use the user's GPS coordinates
  double? _calculateQiblaDirection() {
    if (_deviceHeading == null) return null;
    
    // Simplified Qibla direction calculation
    // In reality, this should be calculated based on user's location
    // For now, we'll use a fixed direction (Makkah is roughly southeast from most places)
    const double qiblaBearing = 135.0; // Southeast direction
    
    return qiblaBearing;
  }

  /// Get the angle between device heading and Qibla direction
  double? get _qiblaAngle {
    if (_deviceHeading == null || _qiblaDirection == null) return null;
    
    double angle = _qiblaDirection! - _deviceHeading!;
    
    // Normalize angle to -180 to 180
    while (angle > 180) angle -= 360;
    while (angle < -180) angle += 360;
    
    return angle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Qibla Direction',
          style: GoogleFonts.amiri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.explore),
              text: 'Compass',
            ),
            Tab(
              icon: Icon(Icons.map),
              text: 'Map',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCompassTab(),
          _buildMapTab(),
        ],
      ),
    );
  }

  /// Build compass tab
  Widget _buildCompassTab() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = null;
                });
                _initializeCompass();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!_isCompassAvailable) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Initializing compass...',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      );
    }

    return QiblaCompass(
      deviceHeading: _deviceHeading,
      qiblaAngle: _qiblaAngle,
    );
  }

  /// Build map tab
  Widget _buildMapTab() {
    return QiblaMap(
      deviceHeading: _deviceHeading,
      qiblaDirection: _qiblaDirection,
    );
  }
}
