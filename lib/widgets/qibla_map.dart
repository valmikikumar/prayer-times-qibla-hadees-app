import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

/// Qibla map widget
/// 
/// Displays a map view with Qibla direction arrow
class QiblaMap extends StatelessWidget {
  final double? deviceHeading;
  final double? qiblaDirection;

  const QiblaMap({
    super.key,
    this.deviceHeading,
    this.qiblaDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Map container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    // Map background (simplified)
                    _buildMapBackground(context),
                    
                    // Qibla direction arrow
                    if (qiblaDirection != null)
                      _buildQiblaArrow(context),
                    
                    // Center indicator
                    _buildCenterIndicator(context),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Information panel
          _buildInformationPanel(context),
        ],
      ),
    );
  }

  /// Build map background
  Widget _buildMapBackground(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: CustomPaint(
        painter: MapBackgroundPainter(
          primaryColor: Theme.of(context).primaryColor,
        ),
        size: const Size.infinite,
      ),
    );
  }

  /// Build Qibla direction arrow
  Widget _buildQiblaArrow(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: Transform.rotate(
          angle: (qiblaDirection! * math.pi / 180),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.navigation,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  /// Build center indicator
  Widget _buildCenterIndicator(BuildContext context) {
    return Center(
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
      ),
    );
  }

  /// Build information panel
  Widget _buildInformationPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          Text(
            'Qibla Map',
            style: GoogleFonts.amiri(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Direction information
          if (qiblaDirection != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoItem(
                  context,
                  'Qibla Direction',
                  '${qiblaDirection!.toStringAsFixed(1)}°',
                ),
                _buildInfoItem(
                  context,
                  'Device Heading',
                  deviceHeading != null 
                      ? '${deviceHeading!.toStringAsFixed(1)}°'
                      : 'Unknown',
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Distance to Makkah (simplified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Distance to Makkah: ~${_getDistanceToMakkah()} km',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ] else ...[
            Text(
              'Calculating Qibla direction...',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Instructions
          Text(
            'The red arrow points towards the Kaaba in Makkah',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build info item
  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  /// Get approximate distance to Makkah (simplified)
  String _getDistanceToMakkah() {
    // This is a simplified calculation
    // In a real app, you would calculate based on user's GPS coordinates
    return '5000'; // Example distance
  }
}

/// Custom painter for map background
class MapBackgroundPainter extends CustomPainter {
  final Color primaryColor;

  MapBackgroundPainter({
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw grid lines
    const gridSize = 50.0;
    
    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
