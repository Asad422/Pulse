import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';

class CircularProgressBarWidget extends StatelessWidget {
  const CircularProgressBarWidget({
    super.key,
    required this.percent,
    required this.size,
    required this.fontSize,
    required this.lineHeight,
    this.fillColor = Colors.green,
    this.text,
    this.borderColor = Colors.white,
    this.opposeColor = Colors.red,
    this.forceBinaryColors = true,
  });

  final double percent;
  final double size;
  final Color fillColor;
  final Color opposeColor;
  final String? text;
  final Color borderColor;
  final bool forceBinaryColors;
  final double lineHeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);
    final supportColor = forceBinaryColors ? Colors.green : fillColor;
    final oppose = forceBinaryColors ? Colors.red : opposeColor;

    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size.square(size),
          painter: _PiePainter(
            support: p,
            supportColor: supportColor,
            opposeColor: oppose,
            borderColor: borderColor,
          ),
        ),
        Text(
          text ?? '${(p * 100).round()}%',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: fontSize,
            height: lineHeight / fontSize,
            fontWeight: FontWeight.w900,
            color: AppColors.background,
          ),
        ),
      ],
    );
  }
}

class _PiePainter extends CustomPainter {
  _PiePainter({
    required this.support, // 0..1
    required this.supportColor,
    required this.opposeColor,
    required this.borderColor,
  });

  final double support;
  final Color supportColor;
  final Color opposeColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const start = -math.pi / 2;
    final supportSweep = math.pi * 2 * support;
    final opposeSweep = math.pi * 2 - supportSweep;

    final supportPaint = Paint()..color = supportColor;
    final opposePaint = Paint()..color = opposeColor;

    if (opposeSweep > 0) {
      canvas.drawArc(rect, start + supportSweep, opposeSweep, true, opposePaint);
    }
    if (supportSweep > 0) {
      canvas.drawArc(rect, start, supportSweep, true, supportPaint);
    }

    final border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(rect.center, size.shortestSide / 2, border);
  }

  @override
  bool shouldRepaint(covariant _PiePainter old) =>
      old.support != support ||
      old.supportColor != supportColor ||
      old.opposeColor != opposeColor ||
      old.borderColor != borderColor;
}
