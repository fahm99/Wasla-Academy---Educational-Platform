import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';

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
          backgroundColor: isSecondary ? Colors.white : AppColors.primary,
          foregroundColor: isSecondary ? AppColors.primary : Colors.white,
          elevation: isSecondary ? 0 : AppSizes.elevationMedium,
          side: isSecondary
              ? const BorderSide(color: AppColors.primary, width: 1)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceLarge,
            vertical: AppSizes.spaceMedium,
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: AppSizes.iconMedium,
                      color: isSecondary ? AppColors.primary : Colors.white,
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.buttonLarge(context).copyWith(
                      color: isSecondary ? AppColors.primary : Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
