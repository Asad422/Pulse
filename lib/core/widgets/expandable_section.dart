import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';

class ExpandableSection<T> extends StatefulWidget {
  const ExpandableSection({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.initialCount = 3,
    this.loading,
    this.emptyMessage = 'No items available.',
    this.titlePadding,
  });

  final String title;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final int initialCount;
  final Widget? loading;
  final String emptyMessage;
  final EdgeInsetsGeometry? titlePadding;

  @override
  State<ExpandableSection<T>> createState() => _ExpandableSectionState<T>();
}

class _ExpandableSectionState<T> extends State<ExpandableSection<T>> {
  bool _expanded = false;

  Widget _title() {
    final title = Text(widget.title, style: AppTextStyles.titleT2);
    if (widget.titlePadding != null) {
      return Padding(padding: widget.titlePadding!, child: title);
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          const SizedBox(height: 12),
          Center(child: widget.loading),
          const SizedBox(height: 24),
        ],
      );
    }

    if (widget.items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          const SizedBox(height: 12),
          Padding(
            padding: widget.titlePadding ?? EdgeInsets.zero,
            child: Text(
              widget.emptyMessage,
              style: AppTextStyles.paragraphP2.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    }

    final visibleItems = _expanded
        ? widget.items
        : widget.items.take(widget.initialCount).toList();
    final hasMore = widget.items.length > widget.initialCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        const SizedBox(height: 12),
        ...visibleItems.map((item) => widget.itemBuilder(item)),
        if (hasMore) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _expanded
                      ? 'Show Less'
                      : 'Show More (${widget.items.length - widget.initialCount})',
                  style: AppTextStyles.paragraphP2Bold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
