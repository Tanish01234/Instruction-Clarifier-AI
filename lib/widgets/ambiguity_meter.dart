import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

class AmbiguityMeter extends StatefulWidget {
  final int score; // 0-100
  final String severity; // Low, Medium, High

  const AmbiguityMeter({
    super.key,
    required this.score,
    required this.severity,
  });

  @override
  State<AmbiguityMeter> createState() => _AmbiguityMeterState();
}

class _AmbiguityMeterState extends State<AmbiguityMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor(double value) {
    if (value < 0.33) {
      return AppColors.ambiguityLow;
    } else if (value < 0.67) {
      return AppColors.ambiguityMedium;
    } else {
      return AppColors.ambiguityHigh;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: _AmbiguityMeterPainter(
                  progress: _animation.value,
                  color: _getColor(_animation.value),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(_animation.value * 100).toInt()}',
                        style: AppTypography.h1.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _getColor(_animation.value),
                        ),
                      ),
                      Text(
                        'Ambiguity',
                        style: AppTypography.caption.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .color!
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getColor(widget.score / 100).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getColor(widget.score / 100).withOpacity(0.3),
            ),
          ),
          child: Text(
            widget.severity.toUpperCase(),
            style: AppTypography.overline.copyWith(
              color: _getColor(widget.score / 100),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).scale(delay: 150.ms);
  }
}

class _AmbiguityMeterPainter extends CustomPainter {
  final double progress;
  final Color color;

  _AmbiguityMeterPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background circle
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress circle
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0.5),
          color,
        ],
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + (2 * math.pi * progress),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AmbiguityMeterPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
