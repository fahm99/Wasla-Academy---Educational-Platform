import 'package:flutter/material.dart';
import 'app_sizes.dart';
import 'app_colors.dart';

/// أنماط النصوص المتجاوبة للتطبيق
/// مستخرجة من تصميم HTML المرجعي
class AppTextStyles {
  // Headlines - العناوين الرئيسية

  /// عنوان رئيسي كبير (18sp موبايل، 24sp تابلت)
  static TextStyle headline1(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXXXLargeTablet : AppSizes.fontXLarge,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  /// عنوان ثانوي (16sp موبايل، 20sp تابلت)
  static TextStyle headline2(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXLargeTablet : AppSizes.fontLarge,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  /// عنوان صغير (14sp موبايل، 16sp تابلت)
  static TextStyle headline3(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  // Body Text - النصوص العادية

  /// نص كبير (14sp موبايل، 16sp تابلت)
  static TextStyle bodyLarge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
      height: 1.5,
    );
  }

  /// نص متوسط (12sp موبايل، 14sp تابلت)
  static TextStyle bodyMedium(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
      height: 1.5,
    );
  }

  /// نص صغير (10sp موبايل، 12sp تابلت)
  static TextStyle bodySmall(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
      height: 1.5,
    );
  }

  // Subtitle Text - النصوص الثانوية

  /// نص ثانوي كبير (14sp موبايل، 16sp تابلت)
  static TextStyle subtitleLarge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  /// نص ثانوي متوسط (12sp موبايل، 14sp تابلت)
  static TextStyle subtitleMedium(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  /// نص ثانوي صغير (10sp موبايل، 12sp تابلت)
  static TextStyle subtitleSmall(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight,
      height: 1.4,
    );
  }

  // Button Text - نصوص الأزرار

  /// نص زر كبير (14sp موبايل، 16sp تابلت)
  static TextStyle buttonLarge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.2,
    );
  }

  /// نص زر متوسط (12sp موبايل، 14sp تابلت)
  static TextStyle buttonMedium(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.2,
    );
  }

  /// نص زر صغير (10sp موبايل، 12sp تابلت)
  static TextStyle buttonSmall(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      height: 1.2,
    );
  }

  // Caption Text - نصوص توضيحية

  /// نص توضيحي (10sp موبايل، 12sp تابلت)
  static TextStyle caption(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.textLight,
      height: 1.3,
    );
  }

  // Label Text - نصوص التسميات

  /// تسمية كبيرة (14sp موبايل، 16sp تابلت)
  static TextStyle labelLarge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontMediumTablet : AppSizes.fontMedium,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.2,
    );
  }

  /// تسمية متوسطة (12sp موبايل، 14sp تابلت)
  static TextStyle labelMedium(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.2,
    );
  }

  /// تسمية صغيرة (10sp موبايل، 12sp تابلت)
  static TextStyle labelSmall(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      height: 1.2,
    );
  }

  // Special Text Styles - أنماط خاصة

  /// نص السعر (18sp موبايل، 20sp تابلت)
  static TextStyle price(BuildContext context, {bool isFree = false}) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXLargeTablet : AppSizes.fontXLarge,
      fontWeight: FontWeight.bold,
      color: isFree ? AppColors.success : AppColors.primary,
      height: 1.2,
    );
  }

  /// نص التقييم (12sp موبايل، 14sp تابلت)
  static TextStyle rating(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.warning,
      height: 1.2,
    );
  }

  /// نص الشارة (10sp موبايل، 12sp تابلت)
  static TextStyle badge(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.0,
    );
  }

  /// نص الحالة (10sp موبايل، 12sp تابلت)
  static TextStyle status(BuildContext context, Color color) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontXSmallTablet : AppSizes.fontXSmall,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.2,
    );
  }

  /// نص الرابط (12sp موبايل، 14sp تابلت)
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

  /// نص الخطأ (12sp موبايل، 14sp تابلت)
  static TextStyle error(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= AppSizes.tablet;
    return TextStyle(
      fontSize: isTablet ? AppSizes.fontSmallTablet : AppSizes.fontSmall,
      fontWeight: FontWeight.normal,
      color: AppColors.danger,
      height: 1.4,
    );
  }

  /// نص النجاح (12sp موبايل، 14sp تابلت)
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
