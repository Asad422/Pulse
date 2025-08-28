import 'package:flutter/material.dart';

class AppButtonWidget extends StatefulWidget {
  const AppButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = AppButtonWidgetSize.medium,
    this.intent = AppButtonWidgetIntent.primary,
    this.tone = AppButtonWidgetTone.solid,
    this.variant = AppButtonWidgetVariant.standard,
    this.enabled = true,
    this.borderRadius,
    this.padding,
    this.iconSize,
    this.customIcon,   // для iconOnly
    this.leftIcon,     // 👈 кастом иконка слева (по умолчанию стандартная стрелка)
    this.rightIcon,    // 👈 кастом иконка справа (по умолчанию стандартная стрелка)
    this.elevation = 0,
  });

  // factories
  factory AppButtonWidget.rightIcon({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonWidgetSize size = AppButtonWidgetSize.medium,
    AppButtonWidgetIntent intent = AppButtonWidgetIntent.primary,
    AppButtonWidgetTone tone = AppButtonWidgetTone.solid,
    bool enabled = true,
    IconData? rightIcon, // кастом справа
  }) =>
      AppButtonWidget(
        key: key,
        label: label,
        onPressed: onPressed,
        size: size,
        intent: intent,
        tone: tone,
        enabled: enabled,
        rightIcon: rightIcon,
        variant: AppButtonWidgetVariant.rightIcon,
      );

  factory AppButtonWidget.leftIcon({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonWidgetSize size = AppButtonWidgetSize.medium,
    AppButtonWidgetIntent intent = AppButtonWidgetIntent.primary,
    AppButtonWidgetTone tone = AppButtonWidgetTone.solid,
    bool enabled = true,
    IconData? leftIcon, // кастом слева
  }) =>
      AppButtonWidget(
        key: key,
        label: label,
        onPressed: onPressed,
        size: size,
        intent: intent,
        tone: tone,
        enabled: enabled,
        leftIcon: leftIcon,
        variant: AppButtonWidgetVariant.leftIcon,
      );

  factory AppButtonWidget.doubleIcons({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonWidgetSize size = AppButtonWidgetSize.medium,
    AppButtonWidgetIntent intent = AppButtonWidgetIntent.primary,
    AppButtonWidgetTone tone = AppButtonWidgetTone.solid,
    bool enabled = true,
    IconData? leftIcon,
    IconData? rightIcon,
  }) =>
      AppButtonWidget(
        key: key,
        label: label,
        onPressed: onPressed,
        size: size,
        intent: intent,
        tone: tone,
        enabled: enabled,
        leftIcon: leftIcon,
        rightIcon: rightIcon,
        variant: AppButtonWidgetVariant.doubleIcons,
      );

  factory AppButtonWidget.trailingSeparated({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonWidgetSize size = AppButtonWidgetSize.medium,
    AppButtonWidgetIntent intent = AppButtonWidgetIntent.primary,
    AppButtonWidgetTone tone = AppButtonWidgetTone.solid,
    bool enabled = true,
    IconData? rightIcon,
  }) =>
      AppButtonWidget(
        key: key,
        label: label,
        onPressed: onPressed,
        size: size,
        intent: intent,
        tone: tone,
        enabled: enabled,
        rightIcon: rightIcon,
        variant: AppButtonWidgetVariant.trailingSeparated,
      );

  factory AppButtonWidget.iconOnly({
    Key? key,
    required VoidCallback? onPressed,
    AppButtonWidgetSize size = AppButtonWidgetSize.medium,
    AppButtonWidgetIntent intent = AppButtonWidgetIntent.primary,
    AppButtonWidgetTone tone = AppButtonWidgetTone.solid,
    bool enabled = true,
    IconData icon = Icons.arrow_forward_rounded,
  }) =>
      AppButtonWidget(
        key: key,
        label: '',
        onPressed: onPressed,
        size: size,
        intent: intent,
        tone: tone,
        enabled: enabled,
        variant: AppButtonWidgetVariant.iconOnly,
        customIcon: icon,
      );

  /// ← | Button | →
  factory AppButtonWidget.doubleIconsSeparated({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    AppButtonWidgetSize size = AppButtonWidgetSize.medium,
    AppButtonWidgetIntent intent = AppButtonWidgetIntent.primary,
    AppButtonWidgetTone tone = AppButtonWidgetTone.solid,
    bool enabled = true,
    IconData? leftIcon,
    IconData? rightIcon,
  }) =>
      AppButtonWidget(
        key: key,
        label: label,
        onPressed: onPressed,
        size: size,
        intent: intent,
        tone: tone,
        enabled: enabled,
        leftIcon: leftIcon,
        rightIcon: rightIcon,
        variant: AppButtonWidgetVariant.doubleIconsSeparated,
      );

  final String label;
  final VoidCallback? onPressed;

  final AppButtonWidgetSize size;
  final AppButtonWidgetIntent intent;
  final AppButtonWidgetTone tone;
  final AppButtonWidgetVariant variant;

  final bool enabled;

  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;

  /// Иконка для варианта `iconOnly`
  final IconData? customIcon;

  /// Кастомные иконки для левой/правой стороны (по умолчанию — стандартные стрелки)
  final IconData? leftIcon;
  final IconData? rightIcon;

  final double elevation;

  @override
  State<AppButtonWidget> createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final _Metrics m = _metricsFor(widget.size);
    final palette = _Palette.of(widget.intent);

    final style = _ToneStyle.resolve(
      tone: widget.tone,
      palette: palette,
      pressed: _pressed,
      enabled: widget.enabled && widget.onPressed != null,
    );

    final double radius = widget.borderRadius ?? 12;
    final EdgeInsetsGeometry contentPadding =
        widget.padding ??
            EdgeInsets.symmetric(horizontal: m.hPadding, vertical: m.vPadding);
    final double iSize = widget.iconSize ?? m.icon;

    // берем кастомные иконки, иначе дефолтные стрелки
    final IconData leftIconData  = widget.leftIcon  ?? Icons.arrow_back_rounded;
    final IconData rightIconData = widget.rightIcon ?? Icons.arrow_forward_rounded;

    final iconLeft  = Icon(leftIconData,  size: iSize, color: style.fg);
    final iconRight = Icon(rightIconData, size: iSize, color: style.fg);

    // icon-only
    if (widget.variant == AppButtonWidgetVariant.iconOnly) {
      final icon = Icon(widget.customIcon ?? Icons.arrow_forward_rounded,
          size: iSize, color: style.fg);
      return _buildBase(
        m: m,
        radius: radius,
        style: style,
        child: Center(child: icon),
      );
    }

    // ← | Button | →
    if (widget.variant == AppButtonWidgetVariant.doubleIconsSeparated) {
      return _buildBase(
        m: m,
        radius: radius,
        style: style,
        padding: contentPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconLeft,
            SizedBox(width: m.gap),
            _divider(m, style),
            SizedBox(width: m.gap),
            Flexible(
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: style.fg,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
              ),
            ),
            SizedBox(width: m.gap),
            _divider(m, style),
            SizedBox(width: m.gap),
            iconRight,
          ],
        ),
      );
    }

    // остальные варианты
    final children = <Widget>[];

    if (widget.variant == AppButtonWidgetVariant.leftIcon ||
        widget.variant == AppButtonWidgetVariant.doubleIcons) {
      children.add(iconLeft);
      children.add(SizedBox(width: m.gap));
    }

    children.add(Flexible(
      child: Text(
        widget.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: style.fg,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
      ),
    ));

    if (widget.variant == AppButtonWidgetVariant.rightIcon ||
        widget.variant == AppButtonWidgetVariant.doubleIcons ||
        widget.variant == AppButtonWidgetVariant.trailingSeparated) {
      children.add(SizedBox(width: m.gap));

      if (widget.variant == AppButtonWidgetVariant.trailingSeparated) {
        children.add(_divider(m, style));
        children.add(SizedBox(width: m.gap));
      }

      children.add(iconRight);
    }

    return _buildBase(
      m: m,
      radius: radius,
      style: style,
      padding: contentPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  // ---------- helpers ----------

  Widget _divider(_Metrics m, _ToneStyle style) => Container(
        width: 1,
        height: m.dividerHeight,
        color: style.fg.withValues(alpha: 0.45),
      );

  Widget _buildBase({
    required _Metrics m,
    required double radius,
    required _ToneStyle style,
    EdgeInsetsGeometry? padding,
    required Widget child,
  }) {
    final bool enabled = widget.enabled && widget.onPressed != null;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: m.minHeight, minWidth: m.minWidth),
      child: Material(
        color: style.bg,
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: style.border ?? BorderSide.none,
        ),
        child: InkWell(
          onHighlightChanged: (v) => setState(() => _pressed = v),
          borderRadius: BorderRadius.circular(radius),
          splashColor: style.splash,
          highlightColor: style.highlight,
          onTap: enabled ? widget.onPressed : null,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}

/* ========================== enums & metrics =========================== */

enum AppButtonWidgetVariant {
  standard,
  leftIcon,
  rightIcon,
  doubleIcons,
  trailingSeparated,
  iconOnly,
  doubleIconsSeparated,
}

enum AppButtonWidgetSize { small, medium, large }
enum AppButtonWidgetIntent { primary, success, danger }
enum AppButtonWidgetTone { solid, subtle, ghost, outline }

class _Metrics {
  const _Metrics({
    required this.minHeight,
    required this.minWidth,
    required this.hPadding,
    required this.vPadding,
    required this.gap,
    required this.icon,
    required this.dividerHeight,
  });

  final double minHeight;
  final double minWidth;
  final double hPadding;
  final double vPadding;
  final double gap;
  final double icon;
  final double dividerHeight;
}

_Metrics _metricsFor(AppButtonWidgetSize s) {
  switch (s) {
    case AppButtonWidgetSize.small:
      return const _Metrics(
        minHeight: 32,
        minWidth: 32,
        hPadding: 24,
        vPadding: 8,
        gap: 8,
        icon: 24,
        dividerHeight: 16,
      );
    case AppButtonWidgetSize.medium:
      return const _Metrics(
        minHeight: 48,
        minWidth: 48,
        hPadding: 24,
        vPadding: 14,
        gap: 12,
        icon: 24,
        dividerHeight: 24,
      );
    case AppButtonWidgetSize.large:
      return const _Metrics(
        minHeight: 56,
        minWidth: 72,
        hPadding: 18,
        vPadding: 18,
        gap: 12,
        icon: 20,
        dividerHeight: 24,
      );
  }
}

/* ============================ palette ================================ */

class _Palette {
  const _Palette(this.base, this.fgOnBase, this.tint);

  final Color base;
  final Color fgOnBase;
  final Color tint;

  static _Palette of(AppButtonWidgetIntent i) {
    switch (i) {
      case AppButtonWidgetIntent.primary:
        return const _Palette(Color(0xFF3B5BFF), Colors.white, Color(0xFFE8EDFF));
      case AppButtonWidgetIntent.success:
        return const _Palette(Color(0xFF28A745), Colors.white, Color(0xFFE6F6EA));
      case AppButtonWidgetIntent.danger:
        return const _Palette(Color(0xFFEF4444), Colors.white, Color(0xFFFDE8E8));
    }
  }
}

/* ============================ tone style ============================= */

class _ToneStyle {
  const _ToneStyle({
    required this.bg,
    required this.fg,
    required this.highlight,
    required this.splash,
    this.border,
  });

  final Color bg;
  final Color fg;
  final Color highlight;
  final Color splash;
  final BorderSide? border;

  static _ToneStyle resolve({
    required AppButtonWidgetTone tone,
    required _Palette palette,
    required bool pressed,
    required bool enabled,
  }) {
    const double kPressedOverlay = 0.12;
    const double kDisabledOpacity = 0.45;

    switch (tone) {
      case AppButtonWidgetTone.solid: {
        final base = palette.base;
        final bg = enabled
            ? (pressed ? _darken(base, 0.06) : base)
            : base.withValues(alpha: kDisabledOpacity);
        final fg = enabled ? palette.fgOnBase : palette.fgOnBase.withValues(alpha: 0.7);
        return _ToneStyle(
          bg: bg,
          fg: fg,
          highlight: Colors.black.withValues(alpha: kPressedOverlay),
          splash: Colors.white.withValues(alpha: 0.10),
        );
      }
      case AppButtonWidgetTone.subtle: {
        final base = palette.tint;
        final bg = enabled
            ? (pressed ? _darken(base, 0.06) : base)
            : base.withValues(alpha: 0.6);
        final fg = enabled ? palette.base : palette.base.withValues(alpha: 0.45);
        return _ToneStyle(
          bg: bg,
          fg: fg,
          highlight: Colors.black.withValues(alpha: kPressedOverlay),
          splash: Colors.black.withValues(alpha: 0.06),
        );
      }
      case AppButtonWidgetTone.ghost: {
        final bg = enabled
            ? (pressed ? palette.base.withValues(alpha: 0.08) : Colors.transparent)
            : Colors.transparent;
        final fg = enabled ? palette.base : palette.base.withValues(alpha: 0.40);
        return _ToneStyle(
          bg: bg,
          fg: fg,
          highlight: palette.base.withValues(alpha: 0.10),
          splash: palette.base.withValues(alpha: 0.10),
        );
      }
      case AppButtonWidgetTone.outline: {
        final border = BorderSide(
          color: enabled ? palette.base : palette.base.withValues(alpha: 0.40),
          width: 1,
        );
        final bg = enabled
            ? (pressed ? palette.base.withValues(alpha: 0.08) : Colors.transparent)
            : Colors.transparent;
        final fg = enabled ? palette.base : palette.base.withValues(alpha: 0.40);
        return _ToneStyle(
          bg: bg,
          fg: fg,
          highlight: palette.base.withValues(alpha: 0.10),
          splash: palette.base.withValues(alpha: 0.10),
          border: border,
        );
      }
    }
  }
}

/* ============================ helpers ================================ */

Color _darken(Color c, double amount) {
  assert(amount >= 0 && amount <= 1);
  final f = 1 - amount;
  return Color.fromARGB(
    ((c.a * 255.0).round() & 0xff),
    ((c.r * f * 255.0).round() & 0xff),
    ((c.g * f * 255.0).round() & 0xff),
    ((c.b * f * 255.0).round() & 0xff),
  );
}
