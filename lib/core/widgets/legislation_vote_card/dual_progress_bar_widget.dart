import 'package:flutter/material.dart';

/// Двухцветная прогресс-полоса с небольшим разрывом посередине.
class DualProgressBar extends StatelessWidget {
  const DualProgressBar({
    super.key,
    required this.fraction,
    required this.leftColor,
    required this.rightColor,
    required this.background,
    this.height = 8,
    this.gap = 8, // ширина пустой зоны по центру
  });

  final double fraction; // 0..1
  final Color leftColor;
  final Color rightColor;
  final Color background;
  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final f = fraction.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final total = constraints.maxWidth;

        // ширина, доступная для двух цветных сегментов без центрального зазора
        final inner = (total - gap).clamp(0.0, double.infinity);
        final leftW = inner * f;
        final rightW = inner - leftW;

        return SizedBox(
          height: height,
          child: Stack(
            children: [
              // Фон дорожки (может быть прозрачным)
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(height),
                ),
              ),

              // Левая (зелёная) часть
              Positioned(
                left: 0,
                width: leftW,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: leftColor,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(height),
                      right: Radius.circular(height),
                    ),
                  ),
                ),
              ),

              // Правая (красная) часть
              Positioned(
                right: 0,
                width: rightW,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: rightColor,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(height),
                      left: Radius.circular(height),
                    ),
                  ),
                ),
              ),

              // Пустой центральный зазор
              if (gap > 0)
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: gap,
                    height: height,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
