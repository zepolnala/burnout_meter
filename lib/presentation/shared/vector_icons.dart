import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

/// Custom Vector Icon showing a sleek crescent moon and star for Sleep Duration
class SleepVectorIcon extends StatelessWidget {
  final double size;
  final Color? color;
  const SleepVectorIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SleepPainter(color ?? AppTheme.accentTeal),
      ),
    );
  }
}

class _SleepPainter extends CustomPainter {
  final Color paintColor;
  _SleepPainter(this.paintColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Draw Crescent Moon
    final path = Path()
      ..moveTo(size.width * 0.7, size.height * 0.1)
      ..arcToPoint(
        Offset(size.width * 0.7, size.height * 0.9),
        radius: Radius.circular(size.width * 0.42),
        clockwise: true,
      )
      ..arcToPoint(
        Offset(size.width * 0.7, size.height * 0.1),
        radius: Radius.circular(size.width * 0.35),
        clockwise: false,
      )
      ..close();

    canvas.drawPath(path, paint);

    // Draw little sparkling star
    final starPaint = Paint()
      ..color = paintColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
      
    final starPath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.35, size.width * 0.2, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.35, size.width * 0.25, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.35, size.width * 0.3, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.35, size.width * 0.25, size.height * 0.3)
      ..close();
      
    canvas.drawPath(starPath, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Vector Icon representing a pulse heartbeat for Autonomic Recovery (HRV)
class RecoveryVectorIcon extends StatelessWidget {
  final double size;
  final Color? color;
  const RecoveryVectorIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RecoveryPainter(color ?? AppTheme.activeGreen),
      ),
    );
  }
}

class _RecoveryPainter extends CustomPainter {
  final Color paintColor;
  _RecoveryPainter(this.paintColor);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Heart Background (subtle)
    final heartPaint = Paint()
      ..color = paintColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final heartPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.25)
      ..cubicTo(size.width * 0.2, size.height * 0.05, 0, size.height * 0.3, size.width * 0.5, size.height * 0.85)
      ..cubicTo(size.width, size.height * 0.3, size.width * 0.8, size.height * 0.05, size.width * 0.5, size.height * 0.25)
      ..close();
    canvas.drawPath(heartPath, heartPaint);

    // 2. Draw Active Pulse Wave (glowing)
    final pulsePaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pulsePath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.4, size.height * 0.2)
      ..lineTo(size.width * 0.5, size.height * 0.8)
      ..lineTo(size.width * 0.6, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.5)
      ..lineTo(size.width * 0.9, size.height * 0.5);

    canvas.drawPath(pulsePath, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Vector Icon representing a glowing storm/stress spike for Stress Index
class StressVectorIcon extends StatelessWidget {
  final double size;
  final Color? color;
  const StressVectorIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StressPainter(color ?? AppTheme.activeOrange),
      ),
    );
  }
}

class _StressPainter extends CustomPainter {
  final Color paintColor;
  _StressPainter(this.paintColor);

  @override
  void paint(Canvas canvas, Size size) {
    final stormPaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw 3 stress wave lines resembling neural/activity signals
    final path1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.1, size.width * 0.4, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height * 0.3)
      ..lineTo(size.width * 0.75, size.height * 0.8)
      ..lineTo(size.width * 0.9, size.height * 0.5);

    canvas.drawPath(path1, stormPaint);

    final dotPaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.3), size.width * 0.08, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Vector Icon showing a glowing segmented power battery for Physical Load
class LoadVectorIcon extends StatelessWidget {
  final double size;
  final Color? color;
  const LoadVectorIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LoadPainter(color ?? AppTheme.activeRed),
      ),
    );
  }
}

class _LoadPainter extends CustomPainter {
  final Color paintColor;
  _LoadPainter(this.paintColor);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Battery Frame
    final framePaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2, size.width * 0.7, size.height * 0.6),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(rrect, framePaint);

    // Draw Battery Tip
    final tipPaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.81, size.height * 0.38, size.width * 0.08, size.height * 0.24),
        Radius.circular(size.width * 0.04),
      ),
      tipPaint,
    );

    // Draw Battery Charge segments (high load: 3 bars)
    final chargePaint = Paint()
      ..color = paintColor.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final double xPos = size.width * 0.18 + (i * size.width * 0.18);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(xPos, size.height * 0.28, size.width * 0.12, size.height * 0.44),
          Radius.circular(size.width * 0.03),
        ),
        chargePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Vector Icon showing a security shield with lock detail for GDPR consent and data privacy
class ShieldVectorIcon extends StatelessWidget {
  final double size;
  final Color? color;
  const ShieldVectorIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ShieldPainter(color ?? AppTheme.accentTeal),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  final Color paintColor;
  _ShieldPainter(this.paintColor);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Shield
    final shieldPaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final shieldPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.12)
      ..lineTo(size.width * 0.85, size.height * 0.22)
      ..lineTo(size.width * 0.85, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.85, size.width * 0.5, size.height * 0.92)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.85, size.width * 0.15, size.height * 0.55)
      ..lineTo(size.width * 0.15, size.height * 0.22)
      ..close();

    canvas.drawPath(shieldPath, shieldPaint);

    // 2. Draw Lock Shackle
    final shacklePaint = Paint()
      ..color = paintColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.44),
        width: size.width * 0.22,
        height: size.height * 0.22,
      ),
      math.pi,
      math.pi,
      false,
      shacklePaint,
    );

    // 3. Draw Lock Body
    final bodyPaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.57),
          width: size.width * 0.28,
          height: size.height * 0.20,
        ),
        Radius.circular(size.width * 0.04),
      ),
      bodyPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Vector Icon showing clusters of sparkles / lightbulbs for recommendations and wellness actions
class WellnessSparkles extends StatelessWidget {
  final double size;
  final Color? color;
  const WellnessSparkles({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WellnessSparklesPainter(color ?? AppTheme.accentTeal),
      ),
    );
  }
}

class _WellnessSparklesPainter extends CustomPainter {
  final Color paintColor;
  _WellnessSparklesPainter(this.paintColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill;

    // Draw main star center
    final double cx = size.width * 0.5;
    final double cy = size.height * 0.5;
    final double w = size.width * 0.28;

    final path1 = Path()
      ..moveTo(cx, cy - w)
      ..quadraticBezierTo(cx, cy, cx + w, cy)
      ..quadraticBezierTo(cx, cy, cx, cy + w)
      ..quadraticBezierTo(cx, cy, cx - w, cy)
      ..quadraticBezierTo(cx, cy, cx, cy - w)
      ..close();
    canvas.drawPath(path1, paint);

    // Draw helper sparkle (top right)
    final double cx2 = size.width * 0.78;
    final double cy2 = size.height * 0.26;
    final double w2 = size.width * 0.14;

    final path2 = Path()
      ..moveTo(cx2, cy2 - w2)
      ..quadraticBezierTo(cx2, cy2, cx2 + w2, cy2)
      ..quadraticBezierTo(cx2, cy2, cx2, cy2 + w2)
      ..quadraticBezierTo(cx2, cy2, cx2 - w2, cy2)
      ..quadraticBezierTo(cx2, cy2, cx2, cy2 - w2)
      ..close();

    final paint2 = Paint()
      ..color = paintColor.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
      
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
