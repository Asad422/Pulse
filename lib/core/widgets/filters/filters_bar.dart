import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';
import '../../resources/app_icons.dart';

/// Универсальный фильтр-панель с уровнями (All / Federal / State / Local)
/// и поиском — можно использовать на любом экране.
class FiltersBar extends StatefulWidget {
  const FiltersBar({
    super.key,
    this.selectedLevel,
    this.onLevelChanged,
    this.onSearchChanged,
    this.onClearSearch,
    this.showBookmark = false,
  });

  final String? selectedLevel; // 'federal', 'state', 'local', null для All
  final ValueChanged<String?>? onLevelChanged;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onClearSearch;
  final bool showBookmark;

  @override
  State<FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<FiltersBar> {
  final _searchCtrl = TextEditingController();

  final _levels = const [
    {'label': 'All', 'value': null},
    {'label': 'Federal', 'value': 'federal'},
    {'label': 'State', 'value': 'state'},
    {'label': 'Local', 'value': 'local'},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Filter chips =====
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              ..._levels.map((lvl) {
                final label = lvl['label'] as String;
                final value = lvl['value'] as String?;
                final isSelected = widget.selectedLevel == value ||
                    (widget.selectedLevel == null && value == null);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) => widget.onLevelChanged?.call(value),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surfaceContainerLow,
                    labelStyle: AppTextStyles.paragraphP2.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                  ),
                );
              }),

              // bookmark icon (опционально)
              if (widget.showBookmark)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: AppIcons.icBookMark.svg(
                        width: 18,
                        height: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ===== Search =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchCtrl,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainerLow.withOpacity(0.5),
              hintText: 'Search...',
              hintStyle: AppTextStyles.paragraphP2High
                  .copyWith(color: AppColors.textSecondary),
              prefixIcon:
              const Icon(Icons.search, color: AppColors.textSecondary),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.close,
                    color: AppColors.textSecondary),
                onPressed: () {
                  _searchCtrl.clear();
                  widget.onClearSearch?.call();
                },
              )
                  : null,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
