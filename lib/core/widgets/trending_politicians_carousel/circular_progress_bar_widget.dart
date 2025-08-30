import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';

class CircularProgressBarWidget extends StatelessWidget {
  const CircularProgressBarWidget({
    super.key,
    required this.percent, // 0..1  (например, 0.72 для 72%)
    required this.size,
    required this.fillColor, // зелёный
    this.text,
    this.borderColor = Colors.white,
  });

  final double percent;
  final double size;
  final Color fillColor;
  final String? text;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        // кольцо (фон + прогресс)
        Container(
          width: size, // чуть больше, чтобы кольцо было вокруг
          height: size,
          decoration: BoxDecoration(color: fillColor, shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CustomPaint(
              size: Size.square(size),
              painter: _RingPainter(
                progress: p,
                trackColor: fillColor,
                progressColor: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
        // белый текст
        Text(
          text ?? '${(p * 100).round()}%',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.background,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress, // 0..1
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = -math.pi / 2; // сверху

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // фон-кольцо
    canvas.drawArc(rect, start, math.pi * 2, false, track);
    // прогресс-дуга
    canvas.drawArc(rect, start, math.pi * 2 * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor ||
      old.strokeWidth != strokeWidth;
}
