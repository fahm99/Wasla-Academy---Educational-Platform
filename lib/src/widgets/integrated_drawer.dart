import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/views/profile_screen.dart';
import 'package:waslaacademy/src/views/courses_screen.dart';
import 'package:waslaacademy/src/views/my_courses_screen.dart';
import 'package:waslaacademy/src/views/notifications_screen.dart';
import 'package:waslaacademy/src/views/certificates_screen.dart';
import 'package:waslaacademy/src/views/advanced_search_screen.dart';
import 'package:waslaacademy/src/views/settings_screen.dart';
import 'package:waslaacademy/src/views/help_screen.dart';
import 'package:waslaacademy/src/views/about_screen.dart';
import 'package:waslaacademy/src/views/contact_screen.dart';
import 'package:waslaacademy/src/views/downloads_screen.dart';

class IntegratedDrawer extends StatelessWidget {
  const IntegratedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with user info and gradient background
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + AppSizes.spaceLarge,
              bottom: AppSizes.spaceXLarge,
              left: AppSizes.spaceLarge,
              right: AppSizes.spaceLarge,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  Color(0xFF1e3a8a),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image and Info
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: AppSizes.avatarLarge / 2,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: AppSizes.iconLarge,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'أحمد محمد',
                            style: AppTextStyles.headline3(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSizes.spaceXSmall),
                          Text(
                            'ahmed@example.com',
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.spaceXLarge),

                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickStat(
                        context,
                        icon: Icons.school,
                        value: '5',
                        label: 'كورسات',
                      ),
                    ),
                    Expanded(
                      child: _buildQuickStat(
                        context,
                        icon: Icons.workspace_premium,
                        value: '3',
                        label: 'شهادات',
                      ),
                    ),
                    Expanded(
                      child: _buildQuickStat(
                        context,
                        icon: Icons.access_time,
                        value: '120',
                        label: 'ساعة',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: AppSizes.spaceMedium),

                // Main Navigation
                _buildSectionHeader(context, 'التنقل الرئيسي'),

                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'الرئيسية',
                  onTap: () => Navigator.pop(context),
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.school_outlined,
                  title: 'جميع الكورسات',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CoursesScreen(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.play_circle_outline,
                  title: 'كورساتي',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCoursesScreen(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.search_outlined,
                  title: 'البحث المتقدم',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdvancedSearchScreen(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.download_outlined,
                  title: 'التنزيلات',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DownloadsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSizes.spaceMedium),

                // Account & Progress
                _buildSectionHeader(context, 'الحساب والتقدم'),

                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'الملف الشخصي',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.workspace_premium_outlined,
                  title: 'الشهادات',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CertificatesScreen(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'الإشعارات',
                  badge: '3',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSizes.spaceMedium),

                // Settings & Support
                _buildSectionHeader(context, 'الإعدادات والدعم'),

                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'الإعدادات',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'المساعدة والدعم',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'حول التطبيق',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),

                _buildDrawerItem(
                  context,
                  icon: Icons.contact_mail_outlined,
                  title: 'تواصل معنا',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSizes.spaceLarge),

                // Logout
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceLarge,
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showLogoutDialog(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: AppSizes.iconMedium,
                      color: AppColors.danger,
                    ),
                    label: Text(
                      'تسجيل الخروج',
                      style: AppTextStyles.buttonMedium(context).copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.danger),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spaceMedium,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.spaceXLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.spaceSmall),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Icon(
            icon,
            size: AppSizes.iconMedium,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        Text(
          value,
          style: AppTextStyles.headline3(context).copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption(context).copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceLarge,
        vertical: AppSizes.spaceSmall,
      ),
      child: Text(
        title,
        style: AppTextStyles.labelMedium(context).copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppColors.textPrimary,
        size: AppSizes.iconMedium,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: textColor ?? AppColors.textPrimary,
              ),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceSmall,
                vertical: AppSizes.spaceXSmall / 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
              ),
              child: Text(
                badge,
                style: AppTextStyles.caption(context).copyWith(
                  color: Colors.white,
                  fontSize: AppSizes.fontXSmall,
                ),
              ),
            ),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceLarge,
        vertical: AppSizes.spaceXSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.logout,
                color: AppColors.danger,
                size: AppSizes.iconMedium,
              ),
              const SizedBox(width: AppSizes.spaceMedium),
              Text(
                'تسجيل الخروج',
                style: AppTextStyles.headline3(context),
              ),
            ],
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
            style: AppTextStyles.bodyLarge(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: AppTextStyles.buttonMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Handle logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم تسجيل الخروج بنجاح',
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
              child: Text(
                'تسجيل الخروج',
                style: AppTextStyles.buttonMedium(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'وصلة أكاديمي',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(AppSizes.spaceSmall),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: const Icon(
          Icons.school,
          size: AppSizes.iconXLarge,
          color: AppColors.primary,
        ),
      ),
      children: [
        Text(
          'منصة تعليمية شاملة تهدف إلى توفير أفضل الدورات التدريبية والتعليمية للطلاب والمتعلمين في الوطن العربي.',
          style: AppTextStyles.bodyMedium(context),
        ),
        const SizedBox(height: AppSizes.spaceLarge),
        Text(
          'تواصل معنا:',
          style: AppTextStyles.labelLarge(context),
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        const Row(
          children: [
            Icon(Icons.email,
                size: AppSizes.iconSmall, color: AppColors.primary),
            SizedBox(width: AppSizes.spaceSmall),
            Text('info@waslaacademy.com'),
          ],
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        const Row(
          children: [
            Icon(Icons.phone,
                size: AppSizes.iconSmall, color: AppColors.primary),
            SizedBox(width: AppSizes.spaceSmall),
            Text('+966 50 123 4567'),
          ],
        ),
      ],
    );
  }
}
