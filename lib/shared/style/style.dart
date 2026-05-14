import 'package:flutter/material.dart';
import 'package:portfolio/shared/theme/colors.dart';

class AppStyle {

  // Headline - Geist
  static const TextStyle headline1 = TextStyle(
    color: AppColors.tertiary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: 'Geist',
    letterSpacing: -0.5,
  );

  static const TextStyle headline2 = TextStyle(
    color: AppColors.tertiary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Geist',
    letterSpacing: -0.3,
  );

  static const TextStyle headline3 = TextStyle(
    color: AppColors.tertiary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Geist',
  );

  // Body - Geist
  static const TextStyle bodyLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Geist',
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Geist',
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Geist',
  );

  // Label - JetBrains Mono
  static const TextStyle label = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: 'JetBrainsMono',
    letterSpacing: 0.8,
  );

  static const TextStyle labelLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'JetBrainsMono',
    letterSpacing: 0.5,
  );

  // ── Border Radius ───────────────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusFull = 999;

  // ── Spacing ─────────────────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // ── Button Styles ───────────────────────────────────────────
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.bgColor,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
    textStyle: const TextStyle(
      fontFamily: 'Geist',
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
  );

  static final ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.cardColor,
    foregroundColor: AppColors.textPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
    textStyle: const TextStyle(
      fontFamily: 'Geist',
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
  );

  static final ButtonStyle outlinedButton = OutlinedButton.styleFrom(
    foregroundColor: AppColors.textPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    side: const BorderSide(color: AppColors.borderColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
    textStyle: const TextStyle(
      fontFamily: 'Geist',
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
  );

  // ── Card Decoration ─────────────────────────────────────────
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardColor,
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(color: AppColors.borderColor),
  );

  // ── Input Decoration ────────────────────────────────────────
  static InputDecoration inputDecoration({String? hint, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: bodyMedium,
      prefixIcon: prefix,
      filled: true,
      fillColor: AppColors.cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusFull),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusFull),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusFull),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    );
  }
}
