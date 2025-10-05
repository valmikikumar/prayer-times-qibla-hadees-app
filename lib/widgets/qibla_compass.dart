import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

/// Qibla compass widget
/// 
/// Displays a compass with Qibla direction indicator
class QiblaCompass extends StatelessWidget {
  final double? deviceHeading;
  final double? qiblaAngle;

  const QiblaCompass({
    super.key,
    this.deviceHeading,
    this.qiblaAngle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Compass container
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Compass background
                      _buildCompassBackground(context),
                      
                      // Qibla direction indicator
                      if (qiblaAngle != null)
                        _buildQiblaIndicator(context),
                      
                      // Center dot
                      _buildCenterDot(context),
                    ],
                  ),
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

  /// Build compass background with directions
  Widget _buildCompassBackground(BuildContext context) {
    return CustomPaint(
      painter: CompassPainter(
        deviceHeading: deviceHeading,
        primaryColor: Theme.of(context).primaryColor,
      ),
      size: const Size.infinite,
    );
  }

  /// Build Qibla direction indicator
  Widget _buildQiblaIndicator(BuildContext context) {
    return Positioned.fill(
      child: Transform.rotate(
        angle: (qiblaAngle! * math.pi / 180),
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build center dot
  Widget _buildCenterDot(BuildContext context) {
    return Center(
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
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
          // Qibla direction text
          Text(
            'Qibla Direction',
            style: GoogleFonts.amiri(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Direction information
          if (qiblaAngle != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoItem(
                  context,
                  'Direction',
                  _getDirectionText(qiblaAngle!),
                ),
                _buildInfoItem(
                  context,
                  'Angle',
                  '${qiblaAngle!.abs().toStringAsFixed(1)}°',
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Accuracy indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getAccuracyColor(qiblaAngle!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getAccuracyColor(qiblaAngle!),
                  width: 1,
                ),
              ),
              child: Text(
                _getAccuracyText(qiblaAngle!),
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getAccuracyColor(qiblaAngle!),
                ),
              ),
            ),
          ] else ...[
            Text(
              'Point your device towards Qibla',
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
            'Hold your device flat and rotate until the red arrow points to Qibla',
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

  /// Get direction text based on angle
  String _getDirectionText(double angle) {
    if (angle.abs() < 5) return 'Perfect';
    if (angle.abs() < 15) return 'Good';
    if (angle.abs() < 30) return 'Fair';
    if (angle.abs() < 45) return 'Turn';
    return 'Turn More';
  }

  /// Get accuracy color based on angle
  Color _getAccuracyColor(double angle) {
    if (angle.abs() < 5) return Colors.green;
    if (angle.abs() < 15) return Colors.orange;
    return Colors.red;
  }

  /// Get accuracy text based on angle
  String _getAccuracyText(double angle) {
    if (angle.abs() < 5) return 'Excellent';
    if (angle.abs() < 15) return 'Good';
    if (angle.abs() < 30) return 'Fair';
    return 'Needs Adjustment';
  }
}

/// Custom painter for compass background
class CompassPainter extends CustomPainter {
  final double? deviceHeading;
  final Color primaryColor;

  CompassPainter({
    this.deviceHeading,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw compass circle
    final circlePaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, circlePaint);

    // Draw direction markers
    _drawDirectionMarkers(canvas, center, radius);
  }

  /// Draw direction markers
  void _drawDirectionMarkers(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    const directions = ['N', 'E', 'S', 'W'];
    const angles = [0, 90, 180, 270];

    for (int i = 0; i < directions.length; i++) {
      final angle = angles[i] * math.pi / 180;
      final x = center.dx + radius * 0.8 * math.cos(angle - math.pi / 2);
      final y = center.dy + radius * 0.8 * math.sin(angle - math.pi / 2);

      textPainter.text = TextSpan(
        text: directions[i],
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CompassPainter && oldDelegate.deviceHeading != deviceHeading;
  }
}
