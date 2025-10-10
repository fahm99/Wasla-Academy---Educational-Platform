import 'package:flutter/material.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? iconColor;
  final Widget? customIcon;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.iconColor,
    this.customIcon,
  });

  // Factory constructors for common empty states
  factory EmptyState.noCourses({
    VoidCallback? onBrowsePressed,
  }) {
    return EmptyState(
      icon: Icons.school_outlined,
      title: 'لا توجد كورسات',
      subtitle: 'لم تسجل في أي كورس بعد. ابدأ رحلة التعلم الآن!',
      actionText: 'تصفح الكورسات',
      onActionPressed: onBrowsePressed,
      iconColor: AppColors.primary,
    );
  }

  factory EmptyState.noSearchResults({
    String? searchQuery,
    VoidCallback? onClearSearch,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'لا توجد نتائج',
      subtitle: searchQuery != null
          ? 'لم نجد أي كورسات تطابق "$searchQuery"'
          : 'لم نجد أي كورسات تطابق بحثك',
      actionText: 'مسح البحث',
      onActionPressed: onClearSearch,
      iconColor: AppColors.textSecondary,
    );
  }

  factory EmptyState.noNotifications({
    VoidCallback? onRefresh,
  }) {
    return EmptyState(
      icon: Icons.notifications_none,
      title: 'لا توجد إشعارات',
      subtitle: 'ستظهر هنا جميع الإشعارات والتحديثات الجديدة',
      actionText: 'تحديث',
      onActionPressed: onRefresh,
      iconColor: AppColors.textSecondary,
    );
  }

  factory EmptyState.noCertificates({
    VoidCallback? onBrowsePressed,
  }) {
    return EmptyState(
      icon: Icons.workspace_premium,
      title: 'لا توجد شهادات',
      subtitle: 'أكمل الكورسات للحصول على شهادات معتمدة',
      actionText: 'تصفح الكورسات',
      onActionPressed: onBrowsePressed,
      iconColor: AppColors.warning,
    );
  }

  factory EmptyState.noLiveLectures({
    VoidCallback? onRefresh,
  }) {
    return EmptyState(
      icon: Icons.live_tv_outlined,
      title: 'لا توجد محاضرات مباشرة',
      subtitle: 'لا توجد محاضرات مباشرة في الوقت الحالي',
      actionText: 'تحديث',
      onActionPressed: onRefresh,
      iconColor: AppColors.danger,
    );
  }

  factory EmptyState.networkError({
    VoidCallback? onRetry,
  }) {
    return EmptyState(
      icon: Icons.wifi_off,
      title: 'خطأ في الاتصال',
      subtitle: 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى',
      actionText: 'إعادة المحاولة',
      onActionPressed: onRetry,
      iconColor: AppColors.danger,
    );
  }

  factory EmptyState.serverError({
    VoidCallback? onRetry,
  }) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'حدث خطأ',
      subtitle: 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً',
      actionText: 'إعادة المحاولة',
      onActionPressed: onRetry,
      iconColor: AppColors.danger,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Center(
      child: Padding(
        padding: screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Custom Widget
            if (customIcon != null)
              customIcon!
            else
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                decoration: BoxDecoration(
                  color:
                      (iconColor ?? AppColors.textSecondary).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppSizes.iconXXXLarge,
                  color: iconColor ?? AppColors.textSecondary,
                ),
              ),

            const SizedBox(height: AppSizes.spaceXLarge),

            // Title
            Text(
              title,
              style: AppTextStyles.headline2(context).copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: AppSizes.spaceSmall),
              Text(
                subtitle!,
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Action Button
            if (actionText != null && onActionPressed != null) ...[
              const SizedBox(height: AppSizes.spaceXXLarge),
              SizedBox(
                width:
                    ResponsiveHelper.isTablet(context) ? 200 : double.infinity,
                height: ResponsiveHelper.getButtonHeight(context),
                child: ElevatedButton(
                  onPressed: onActionPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceXXLarge,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    elevation: AppSizes.elevationLow,
                  ),
                  child: Text(
                    actionText!,
                    style: AppTextStyles.buttonLarge(context),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state مع animation
class AnimatedEmptyState extends StatefulWidget {
  final EmptyState emptyState;
  final Duration animationDuration;

  const AnimatedEmptyState({
    super.key,
    required this.emptyState,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.emptyState,
      ),
    );
  }
}
