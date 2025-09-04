import 'package:flutter/material.dart';
import 'package:pulse/core/widgets/app_button_widget.dart'; // AppButtonWidget

class ButtonsShowcase extends StatelessWidget {
  const ButtonsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = 12.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _h1('Buttons'),

          // --- Sizes ---------------------------------------------------------
          const SizedBox(height: 8),
          _label('Large'),
          const SizedBox(height: 8),
          _variantsRow(AppButtonWidgetSize.large),
          SizedBox(height: gap),

          _label('Medium'),
          const SizedBox(height: 8),
          _variantsRow(AppButtonWidgetSize.medium),
          SizedBox(height: gap),

          _label('Small'),
          const SizedBox(height: 8),
          _variantsRow(AppButtonWidgetSize.small),
          const SizedBox(height: 24),

          // --- States / Intents / Tones -------------------------------------
          _h2('States · Intents · Tones'),
          const SizedBox(height: 8),
          _legendRow(),
          const SizedBox(height: 12),

          _intentBlock(
            title: 'Primary (blue)',
            intent: AppButtonWidgetIntent.primary,
          ),
          const SizedBox(height: 16),

          _intentBlock(
            title: 'Danger (red)',
            intent: AppButtonWidgetIntent.danger,
          ),
          const SizedBox(height: 16),

          _intentBlock(
            title: 'Success (green)',
            intent: AppButtonWidgetIntent.success,
          ),
          const SizedBox(height: 24),

          // --- Button group (из макета справа) ------------------------------
          _h2('Button group'),
          const SizedBox(height: 12),
          _buttonGroupSample(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ---------- helpers UI ----------------------------------------------------

  static Widget _variantsRow(AppButtonWidgetSize size) {
    const label = 'Button';
    const gap = 12.0;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppButtonWidget(label: label, onPressed: () {}, size: size,),
        AppButtonWidget.rightIcon(label: label, onPressed: () {}, size: size,),
        AppButtonWidget.leftIcon(label: label, onPressed: () {}, size: size),
        AppButtonWidget.doubleIcons(label: label, onPressed: () {}, size: size),
        AppButtonWidget.trailingSeparated(label: label, onPressed: () {}, size: size),

        // 👇 новый вариант с двумя разделителями
        AppButtonWidget.doubleIconsSeparated(label: label, onPressed: () {}, size: size),

        AppButtonWidget.iconOnly(onPressed: () {}, size: size),
      ],
    );
  }

  static Widget _legendRow() {
    Text chip(String t) => Text(t, style: const TextStyle(fontSize: 12, color: Colors.black54));
    return Row(
      children: [
        chip('Normal — вид по умолчанию'),
        const SizedBox(width: 16),
        chip('Pressed — видно при нажатии'),
        const SizedBox(width: 16),
        chip('Disabled — onPressed: null / enabled: false'),
      ],
    );
  }

  static Widget _intentBlock({
    required String title,
    required AppButtonWidgetIntent intent,
  }) {
    const label = 'Button';
    const gap = 10.0;

    Widget col(String toneLabel, AppButtonWidgetTone tone) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(toneLabel, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 8),
            // Normal
            Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                AppButtonWidget(label: label, onPressed: () {}, intent: intent, tone: tone),
                AppButtonWidget.rightIcon(label: label, onPressed: () {}, intent: intent, tone: tone),
                AppButtonWidget.leftIcon(label: label, onPressed: () {}, intent: intent, tone: tone),
                AppButtonWidget.doubleIcons(label: label, onPressed: () {}, intent: intent, tone: tone),
                AppButtonWidget.trailingSeparated(label: label, onPressed: () {}, intent: intent, tone: tone),

                // 👇 новый вариант «← | Button | →»
                AppButtonWidget.doubleIconsSeparated(label: label, onPressed: () {}, intent: intent, tone: tone),

                AppButtonWidget.iconOnly(onPressed: () {}, intent: intent, tone: tone),
              ],
            ),
            const SizedBox(height: 8),
            // Disabled
            Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                AppButtonWidget(label: label, onPressed: null, intent: intent, tone: tone, enabled: false),
                AppButtonWidget.rightIcon(label: label, onPressed: null, intent: intent, tone: tone, enabled: false),
                AppButtonWidget.leftIcon(label: label, onPressed: null, intent: intent, tone: tone, enabled: false),
                AppButtonWidget.doubleIcons(label: label, onPressed: null, intent: intent, tone: tone, enabled: false),
                AppButtonWidget.trailingSeparated(label: label, onPressed: null, intent: intent, tone: tone, enabled: false),

                // 👇 disabled для «двух разделителей»
                AppButtonWidget.doubleIconsSeparated(label: label, onPressed: null, intent: intent, tone: tone, enabled: false),

                AppButtonWidget.iconOnly(onPressed: null, intent: intent, tone: tone, enabled: false),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(title),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            col('Solid', AppButtonWidgetTone.solid),
            const SizedBox(width: 12),
            col('Subtle', AppButtonWidgetTone.subtle),
            const SizedBox(width: 12),
            col('Ghost', AppButtonWidgetTone.ghost),
            const SizedBox(width: 12),
            col('Outline', AppButtonWidgetTone.outline),
          ],
        ),
      ],
    );
  }

  static Widget _buttonGroupSample() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppButtonWidget(
                label: 'Редактировать',
                onPressed: () {},
                tone: AppButtonWidgetTone.subtle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButtonWidget(
                label: 'Закрыть',
                onPressed: () {},
                tone: AppButtonWidgetTone.solid,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButtonWidget(
                label: 'Редактировать',
                onPressed: () {},
                tone: AppButtonWidgetTone.subtle,
                intent: AppButtonWidgetIntent.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: AppButtonWidget(
                label: 'Закрыть',
                onPressed: null,
                enabled: false,
                tone: AppButtonWidgetTone.solid,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- small headings -------------------------------------------------

  static Widget _h1(String t) =>
      Text(t, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700));

  static Widget _h2(String t) =>
      Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));

  static Widget _label(String t) =>
      Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
}
