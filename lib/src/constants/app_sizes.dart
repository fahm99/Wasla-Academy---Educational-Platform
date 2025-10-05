import 'package:flutter/material.dart';

/// ثوابت الأحجام المتجاوبة للتطبيق
/// مستخرجة من تصميم HTML المرجعي
class AppSizes {
  // Breakpoints - نقاط التحول لأحجام الشاشات
  static const double mobileSmall = 360;
  static const double mobileMedium = 375;
  static const double mobileLarge = 414;
  static const double tablet = 600;
  static const double desktop = 1024;

  // Font Sizes - أحجام الخطوط (للموبايل)
  static const double fontXSmall = 10;
  static const double fontSmall = 12;
  static const double fontMedium = 14;
  static const double fontLarge = 16;
  static const double fontXLarge = 18;
  static const double fontXXLarge = 20;
  static const double fontXXXLarge = 24;

  // Font Sizes - أحجام الخطوط (للتابلت) - زيادة 20-30%
  static const double fontXSmallTablet = 12;
  static const double fontSmallTablet = 14;
  static const double fontMediumTablet = 16;
  static const double fontLargeTablet = 18;
  static const double fontXLargeTablet = 20;
  static const double fontXXLargeTablet = 24;
  static const double fontXXXLargeTablet = 28;

  // Spacing - المسافات
  static const double spaceXSmall = 4;
  static const double spaceSmall = 8;
  static const double spaceMedium = 12;
  static const double spaceLarge = 16;
  static const double spaceXLarge = 20;
  static const double spaceXXLarge = 24;
  static const double spaceXXXLarge = 32;

  // Border Radius - انحناء الحواف
  static const double radiusXSmall = 4;
  static const double radiusSmall = 6;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;
  static const double radiusXXLarge = 20;
  static const double radiusRound = 25; // للعناصر الدائرية مثل شريط البحث

  // Icon Sizes - أحجام الأيقونات
  static const double iconXSmall = 12;
  static const double iconSmall = 16;
  static const double iconMedium = 20;
  static const double iconLarge = 24;
  static const double iconXLarge = 32;
  static const double iconXXLarge = 40;
  static const double iconXXXLarge = 48;

  // Component Heights - ارتفاعات المكونات
  static const double courseImageHeight = 160; // من HTML: 180px مصغر لـ 160
  static const double courseImageHeightTablet = 200;
  static const double bottomNavHeight = 60;
  static const double appBarHeight = 56;
  static const double buttonHeight = 32;
  static const double buttonHeightTablet = 40;
  static const double searchBarHeight = 48;

  // Avatar Sizes - أحجام الصور الشخصية
  static const double avatarSmall = 24;
  static const double avatarMedium = 36;
  static const double avatarLarge = 40;
  static const double avatarXLarge = 60;
  static const double avatarXXLarge = 80;

  // Badge Sizes - أحجام الشارات
  static const double badgeSmall = 16;
  static const double badgeMedium = 18;
  static const double badgeLarge = 20;

  // Card Padding - مسافات البطاقات
  static const double cardPaddingMobile = 12;
  static const double cardPaddingTablet = 16;
  static const double cardPaddingDesktop = 20;

  // Screen Padding - مسافات الشاشات
  static const double screenPaddingMobile = 16;
  static const double screenPaddingTablet = 20;
  static const double screenPaddingDesktop = 24;

  // Elevation - الظلال
  static const double elevationLow = 1;
  static const double elevationMedium = 2;
  static const double elevationHigh = 4;
  static const double elevationXHigh = 8;

  // دالة للحصول على حجم الخط المتجاوب
  static double getResponsiveFontSize(BuildContext context, double mobileSize) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tablet) {
      return mobileSize * 1.2; // زيادة 20% للتابلت
    }
    return mobileSize;
  }

  // دالة للحصول على المسافة المتجاوبة
  static double getResponsiveSpacing(
      BuildContext context, double mobileSpacing) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tablet) {
      return mobileSpacing * 1.25; // زيادة 25% للتابلت
    }
    return mobileSpacing;
  }

  // دالة للحصول على padding البطاقة المتجاوب
  static double getCardPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop) return cardPaddingDesktop;
    if (width >= tablet) return cardPaddingTablet;
    return cardPaddingMobile;
  }

  // دالة للحصول على padding الشاشة المتجاوب
  static double getScreenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop) return screenPaddingDesktop;
    if (width >= tablet) return screenPaddingTablet;
    return screenPaddingMobile;
  }
}
