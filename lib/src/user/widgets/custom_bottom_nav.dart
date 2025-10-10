import 'package:flutter/material.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int notificationCount;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.bottomNavHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppSizes.elevationHigh,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'الرئيسية',
            index: 0,
            isActive: currentIndex == 0,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.book_outlined,
            activeIcon: Icons.book,
            label: 'الكورسات',
            index: 1,
            isActive: currentIndex == 1,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.school_outlined,
            activeIcon: Icons.school,
            label: 'التعلم',
            index: 2,
            isActive: currentIndex == 2,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'حسابي',
            index: 3,
            isActive: currentIndex == 3,
            hasNotification: notificationCount > 0,
            notificationCount: notificationCount,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
    bool hasNotification = false,
    int notificationCount = 0,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spaceSmall,
            horizontal: AppSizes.spaceXSmall,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isActive ? activeIcon : icon,
                      key: ValueKey(isActive),
                      size: AppSizes.iconMedium,
                      color: isActive
                          ? AppColors.primary
                          : const Color(0xFF6b7280),
                    ),
                  ),
                  if (hasNotification && notificationCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        height: AppSizes.badgeMedium,
                        padding: const EdgeInsets.all(AppSizes.spaceXSmall / 2),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius:
                              BorderRadius.circular(AppSizes.badgeMedium / 2),
                        ),
                        child: Center(
                          child: Text(
                            notificationCount > 99
                                ? '99+'
                                : notificationCount.toString(),
                            style: AppTextStyles.badge(context).copyWith(
                              fontSize: AppSizes.fontXSmall,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceXSmall / 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.caption(context).copyWith(
                  color: isActive ? AppColors.primary : const Color(0xFF6b7280),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
