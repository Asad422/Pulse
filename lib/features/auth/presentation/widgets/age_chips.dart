import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class AgeChips extends StatelessWidget {
  const AgeChips({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int? selectedIndex;
  final ValueChanged<int> onChanged;

  static const _labels = ['18–25', '26–35', '36–50', '51+'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_labels.length, (i) {
        final selected = selectedIndex == i;
        return ChoiceChip(
          label: Text(
            _labels[i],
            style: AppTextStyles.get("Button/Medium")?.copyWith(
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
          selected: selected,
          onSelected: (_) => onChanged(i),
          showCheckmark: false,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
          side: selected
              ? BorderSide.none
              : BorderSide(color: AppColors.textSecondary.withOpacity(0.25)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }),
    );
  }
}
