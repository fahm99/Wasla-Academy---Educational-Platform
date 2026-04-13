import 'package:flutter/material.dart';
import 'package:waslaacademy/core/constants/app_colors.dart';
import 'package:waslaacademy/core/constants/app_sizes.dart';
import 'package:waslaacademy/core/constants/app_text_styles.dart';
import 'package:waslaacademy/core/utils/responsive_helper.dart';

/// Custom button widget with loading state and optional icon
///
/// Usage:
/// ```dart
/// CustomButton(
///   text: 'تسجيل الدخول',
///   onPressed: () {},
///   icon: Icons.login,
///   isLoading: false,
/// )
/// ```
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? ResponsiveHelper.getButtonHeight(context);

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSecondary ? AppColors.secondary : AppColors.primary,
          foregroundColor: isSecondary ? Colors.black : Colors.white,
          elevation: AppSizes.elevationMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceLarge,
            vertical: AppSizes.spaceMedium,
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isSecondary ? Colors.black : Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: AppSizes.iconMedium,
                      color: isSecondary ? Colors.black : Colors.white,
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: AppTextStyles.buttonLarge(context).copyWith(
                        color: isSecondary ? Colors.black : Colors.white,
                        overflow: TextOverflow.visible,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
