import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppSizes.tablet;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppSizes.tablet && width < AppSizes.desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppSizes.desktop;
  }

  static double getScreenPadding(BuildContext context) {
    return AppSizes.getScreenPadding(context);
  }

  static double getCardPadding(BuildContext context) {
    return AppSizes.getCardPadding(context);
  }

  static double getResponsiveFontSize(BuildContext context, double mobileSize) {
    return AppSizes.getResponsiveFontSize(context, mobileSize);
  }

  static double getResponsiveSpacing(
      BuildContext context, double mobileSpacing) {
    return AppSizes.getResponsiveSpacing(context, mobileSpacing);
  }

  static double getButtonHeight(BuildContext context) {
    return isTablet(context)
        ? AppSizes.buttonHeightTablet
        : AppSizes.buttonHeight;
  }

  static double getCourseImageHeight(BuildContext context) {
    return isTablet(context)
        ? AppSizes.courseImageHeightTablet
        : AppSizes.courseImageHeight;
  }
}
