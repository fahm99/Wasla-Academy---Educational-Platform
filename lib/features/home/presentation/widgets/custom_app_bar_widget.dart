import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// شريط التطبيق المخصص
class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final bool showAuthIcons;
  final List<Widget>? actions;

  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.showAuthIcons = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.headlineMedium(context).copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      leading: onMenuPressed != null
          ? IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColors.textPrimary,
              ),
              onPressed: onMenuPressed,
            )
          : null,
      actions: actions ??
          (showAuthIcons
              ? [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      // Navigate to notifications
                    },
                  ),
                  const SizedBox(width: AppSizes.sm),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
