import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';



class AppInput {
  /// Общая декорация для инпутов
  static InputDecoration decoration(
      String label, {
        Widget? suffix,
      }) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.inputLabel,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelAlignment: FloatingLabelAlignment.start,

      filled: true,
      fillColor: Colors.white,

      // больше места сверху под лейбл
      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 14),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.25)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),

      suffixIcon: suffix,
    );
  }
}

/// Универсальный текстфилд с поддержкой errorText и onChanged
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffix;

  /// Текст ошибки (если null — ошибки нет)
  final String? errorText;

  /// Коллбек изменения текста
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffix,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: AppTextStyles.get("Input/Text"),
      onChanged: onChanged,
      decoration: AppInput.decoration(label, suffix: suffix)
          .copyWith(errorText: errorText),
    );
  }
}
