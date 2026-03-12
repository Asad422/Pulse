import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {

  // ===== Label ===== // NEW
  static const TextStyle labelL1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelL2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelL3 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, // базовый цвет; перекрашиваем через copyWith
  );

  // ===== Button =====
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // ===== Input =====
  static const TextStyle inputText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle inputSublabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ===== Headline =====
  static const TextStyle headlineH1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    height: 56 / 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineH2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineH3 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle headlineH4 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  // ===== Title =====
  static const TextStyle titleT1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleT2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleT3 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ===== Paragraph p1 =====
  static const TextStyle paragraphP1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle paragraphP1Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle paragraphP1High = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle paragraphP1HighBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  // ===== Paragraph p2 =====
  static const TextStyle paragraphP2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle paragraphP2Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle paragraphP2High = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle paragraphP2HighBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  // ===== Paragraph p3 =====
  static const TextStyle paragraphP3 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle paragraphP3Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle paragraphP3High = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle paragraphP3HighBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  // ===== Маппер =====
  static final Map<String, TextStyle> _map = {
    // Button
    "Button/Large": buttonLarge,
    "Button/Medium": buttonMedium,
    "Button/Small": buttonSmall,

    // Input
    "Input/Text": inputText,
    "Input/Label": inputLabel,
    "Input/Sublabel": inputSublabel,

    // Headline
    "Headline/h1": headlineH1,
    "Headline/h2": headlineH2,
    "Headline/h3": headlineH3,

    // Title
    "Title/t1": titleT1,
    "Title/t2": titleT2,
    "Title/t3": titleT3,

    // Paragraph
    "Paragraph/p1": paragraphP1,
    "Paragraph/p1-bold": paragraphP1Bold,
    "Paragraph/p1-high": paragraphP1High,
    "Paragraph/p1-high-bold": paragraphP1HighBold,
    "Paragraph/p2": paragraphP2,
    "Paragraph/p2-bold": paragraphP2Bold,
    "Paragraph/p2-high": paragraphP2High,
    "Paragraph/p2-high-bold": paragraphP2HighBold,
    "Paragraph/p3": paragraphP3,
    "Paragraph/p3-bold": paragraphP3Bold,
    "Paragraph/p3-high": paragraphP3High,
    "Paragraph/p3-high-bold": paragraphP3HighBold,

    // Алиасы Body
    "Body/p1": paragraphP1,
    "Body/p1-bold": paragraphP1Bold,
    "Body/p1-high": paragraphP1High,
    "Body/p1-high-bold": paragraphP1HighBold,
    "Body/p2": paragraphP2,
    "Body/p2-bold": paragraphP2Bold,
    "Body/p2-high": paragraphP2High,
    "Body/p2-high-bold": paragraphP2HighBold,
    "Body/p3": paragraphP3,
    "Body/p3-bold": paragraphP3Bold,
    "Body/p3-high": paragraphP3High,
    "Body/p3-high-bold": paragraphP3HighBold,

    // Label // NEW
    "Label/l1": labelL1,
    "Label/l2": labelL2,
    "Label/l3": labelL3,
  };

  static TextStyle? get(String name) => _map[name];
}
