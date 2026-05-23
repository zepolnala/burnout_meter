import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

class BurnoutRadialScore extends StatelessWidget {
  final double score;
  final double size;
  const BurnoutRadialScore({super.key, required this.score, this.size = 180});

  String _getRiskLevelText(double score) {
    if (score < 40) return 'ESTABLE';
    if (score < 75) return 'MODERADO';
    return 'CRÍTICO';
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getScoreColor(score);
    final text = _getRiskLevelText(score);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: score),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutBack,
      builder: (context, animatedValue, child) {
        return Center(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 36,
                  spreadRadius: 4,
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Draw Dial Paint
                SizedBox(
                  width: size,
                  height: size,
                  child: CustomPaint(
                    painter: _RadialDialPainter(
                      score: animatedValue,
                      activeColor: color,
                    ),
                  ),
                ),
                // 2. Central Metrics details
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      animatedValue.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const Text(
                      'ÍNDICE BURNOUT',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.softText,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RadialDialPainter extends CustomPainter {
  final double score;
  final Color activeColor;
  _RadialDialPainter({required this.score, required this.activeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * 0.88;
    final strokeWidth = size.width * 0.08;

    // A. Draw Background Track Circle
    final trackPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    canvas.drawCircle(center, radius, trackPaint);

    // B. Draw Active Progress Arc
    final sweepAngle = (score / 100) * 2 * math.pi;
    final progressPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start at 12 o'clock
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialDialPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.activeColor != activeColor;
  }
}
