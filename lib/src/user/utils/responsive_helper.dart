import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// مساعد للتعامل مع الاستجابة (Responsive Design)
class ResponsiveHelper {
  /// التحقق من الشاشة الصغيرة جداً (< 360px)
  static bool isMobileSmall(BuildContext context) {
    return MediaQuery.of(context).size.width < AppSizes.mobileSmall;
  }

  /// التحقق من الشاشة المتوسطة (360-600px)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppSizes.tablet;
  }

  /// التحقق من التابلت (600-1024px)
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppSizes.tablet &&
        MediaQuery.of(context).size.width < AppSizes.desktop;
  }

  /// التحقق من سطح المكتب (>= 1024px)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppSizes.desktop;
  }

  /// التحقق من الاتجاه الأفقي
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// التحقق من الاتجاه العمودي
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// الحصول على قيمة متجاوبة بناءً على حجم الشاشة
  ///
  /// مثال:
  /// ```dart
  /// double fontSize = ResponsiveHelper.getResponsiveValue(
  ///   context,
  ///   mobile: 14,
  ///   tablet: 16,
  ///   desktop: 18,
  /// );
  /// ```
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  /// الحصول على حجم خط متجاوب
  /// يزيد الحجم بنسبة 20% للتابلت و 30% لسطح المكتب
  static double getResponsiveFontSize(
    BuildContext context,
    double baseSize,
  ) {
    if (isDesktop(context)) return baseSize * 1.3;
    if (isTablet(context)) return baseSize * 1.2;
    return baseSize;
  }

  /// الحصول على مسافة متجاوبة
  /// يزيد المسافة بنسبة 25% للتابلت و 50% لسطح المكتب
  static double getResponsiveSpacing(
    BuildContext context,
    double baseSpacing,
  ) {
    if (isDesktop(context)) return baseSpacing * 1.5;
    if (isTablet(context)) return baseSpacing * 1.25;
    return baseSpacing;
  }

  /// الحصول على عدد الأعمدة في Grid بناءً على حجم الشاشة
  static int getGridColumns(
    BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// الحصول على نسبة العرض إلى الارتفاع للبطاقات
  static double getCardAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 1.5;
    if (isTablet(context)) return 1.4;
    return 1.3;
  }

  /// الحصول على عرض الشاشة
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// الحصول على ارتفاع الشاشة
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// الحصول على padding الشاشة الآمن (Safe Area)
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// الحصول على padding الشاشة
  static EdgeInsets getScreenPadding(BuildContext context) {
    final padding = AppSizes.getScreenPadding(context);
    return EdgeInsets.all(padding);
  }

  /// الحصول على padding أفقي للشاشة
  static EdgeInsets getScreenHorizontalPadding(BuildContext context) {
    final padding = AppSizes.getScreenPadding(context);
    return EdgeInsets.symmetric(horizontal: padding);
  }

  /// الحصول على padding عمودي للشاشة
  static EdgeInsets getScreenVerticalPadding(BuildContext context) {
    final padding = AppSizes.getScreenPadding(context);
    return EdgeInsets.symmetric(vertical: padding);
  }

  /// الحصول على الحد الأقصى لعرض المحتوى (للشاشات الكبيرة)
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 800;
    return double.infinity;
  }

  /// تطبيق الحد الأقصى لعرض المحتوى
  static Widget constrainWidth(BuildContext context, Widget child) {
    final maxWidth = getMaxContentWidth(context);
    if (maxWidth == double.infinity) return child;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }

  /// الحصول على عدد العناصر المرئية في قائمة أفقية
  static int getVisibleItemsCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    if (isMobileSmall(context)) return 1;
    return 2;
  }

  /// الحصول على ارتفاع صورة الكورس المتجاوب
  static double getCourseImageHeight(BuildContext context) {
    if (isTablet(context)) return AppSizes.courseImageHeightTablet;
    return AppSizes.courseImageHeight;
  }

  /// الحصول على حجم الأيقونة المتجاوب
  static double getIconSize(BuildContext context, double baseSize) {
    if (isTablet(context)) return baseSize * 1.2;
    return baseSize;
  }

  /// الحصول على ارتفاع الزر المتجاوب
  static double getButtonHeight(BuildContext context) {
    if (isTablet(context)) return AppSizes.buttonHeightTablet;
    return AppSizes.buttonHeight;
  }

  /// التحقق من إمكانية عرض عنصرين جنباً إلى جنب
  static bool canShowTwoColumns(BuildContext context) {
    return getScreenWidth(context) >= AppSizes.mobileLarge;
  }

  /// الحصول على نوع الجهاز كنص
  static String getDeviceType(BuildContext context) {
    if (isDesktop(context)) return 'Desktop';
    if (isTablet(context)) return 'Tablet';
    if (isMobileSmall(context)) return 'Mobile Small';
    return 'Mobile';
  }

  /// طباعة معلومات الشاشة (للتطوير فقط)
  static void printScreenInfo(BuildContext context) {
    final width = getScreenWidth(context);
    final height = getScreenHeight(context);
    final deviceType = getDeviceType(context);
    final orientation = isLandscape(context) ? 'Landscape' : 'Portrait';

    print('=== Screen Info ===');
    print('Device Type: $deviceType');
    print('Width: $width');
    print('Height: $height');
    print('Orientation: $orientation');
    print('==================');
  }
}
