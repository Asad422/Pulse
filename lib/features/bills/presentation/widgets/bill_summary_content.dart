import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class BillSummaryContent extends StatefulWidget {
  const BillSummaryContent({
    super.key,
    required this.summary,
  });

  final String? summary;

  @override
  State<BillSummaryContent> createState() => _BillSummaryContentState();
}

class _BillSummaryContentState extends State<BillSummaryContent> {
  static const _collapsedHeight = 150.0;
  static const _minCharsForCollapse = 300;
  bool _expanded = false;

  static final _baseStyle = AppTextStyles.paragraphP2.copyWith(
    color: AppColors.onSurface,
  );

  @override
  Widget build(BuildContext context) {
    final text = widget.summary?.trim() ?? '';
    if (text.isEmpty) {
      return Text(
        'No summary available.',
        style: _baseStyle.copyWith(color: AppColors.onSurfaceVariant),
      );
    }

    final hasHtml =
        RegExp(r'<[a-z][\s\S]*>', caseSensitive: false).hasMatch(text);

    final plainText =
        hasHtml ? text.replaceAll(RegExp(r'<[^>]*>'), '').trim() : text;

    final isCollapsible = plainText.length > _minCharsForCollapse;

    final content = hasHtml
        ? HtmlWidget(text, textStyle: _baseStyle)
        : Text(text, style: _baseStyle);

    if (!isCollapsible) return content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_expanded)
          SizedBox(
            height: _collapsedHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: content,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 48,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          content,
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 18,
            ),
            label: Text(_expanded ? 'Show less' : 'See full summary'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: AppTextStyles.paragraphP2,
            ),
          ),
        ),
      ],
    );
  }
}
