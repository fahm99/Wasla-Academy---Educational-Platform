import 'package:flutter/material.dart';
import 'app_sizes.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headlines
  static TextStyle headline1(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXXXLargeTablet : AppSizes.fontXLarge,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  static TextStyle headline2(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXLargeTablet : AppSizes.fontLarge,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  static TextStyle headline3(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  // Aliases for Material Design naming
  static TextStyle headlineLarge(BuildContext context) => headline1(context);
  static TextStyle headlineMedium(BuildContext context) => headline2(context);
  static TextStyle headlineSmall(BuildContext context) => headline3(context);

  // Body Text
  static TextStyle bodyLarge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
      height: 1.5,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
      height: 1.5,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
      height: 1.5,
    );
  }

  // Subtitle Text
  static TextStyle subtitleLarge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  static TextStyle subtitleMedium(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  static TextStyle subtitleSmall(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight,
      height: 1.4,
    );
  }

  // Button Text
  static TextStyle buttonLarge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.2,
    );
  }

  static TextStyle buttonMedium(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.2,
    );
  }

  static TextStyle buttonSmall(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.2,
    );
  }

  // Caption & Label
  static TextStyle caption(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.textLight,
      height: 1.3,
    );
  }

  static TextStyle labelLarge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.2,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.2,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      height: 1.2,
    );
  }

  // Special Styles
  static TextStyle price(BuildContext context, {bool isFree = false}) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXLargeTablet : AppSizes.fontXLarge,
      fontWeight: FontWeight.bold,
      color: isFree ? AppColors.success : AppColors.primary,
      height: 1.2,
    );
  }

  static TextStyle rating(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.warning,
      height: 1.2,
    );
  }

  static TextStyle badge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.0,
    );
  }

  static TextStyle status(BuildContext context, Color color) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.2,
    );
  }

  static TextStyle link(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.primary,
      decoration: TextDecoration.underline,
      height: 1.4,
    );
  }

  static TextStyle error(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.danger,
      height: 1.4,
    );
  }

  static TextStyle success(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.success,
      height: 1.4,
    );
  }
}
