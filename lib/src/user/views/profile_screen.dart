import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslaacademy/src/user/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';
import 'package:waslaacademy/src/user/views/edit_profile_screen.dart';
import 'package:waslaacademy/src/user/views/certificates_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile header with primary color
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top +
                          AppSizes.spaceLarge,
                      bottom: AppSizes.spaceXXLarge,
                      left: screenPadding.left,
                      right: screenPadding.right,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppSizes.radiusXLarge),
                        bottomRight: Radius.circular(AppSizes.radiusXLarge),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Profile Image
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: user.avatar != null && user.avatar!.isNotEmpty
                              ? CircleAvatar(
                                  radius: AppSizes.avatarXXLarge / 2,
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.2),
                                  backgroundImage: NetworkImage(user.avatar!),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    // Handle image load error
                                  },
                                )
                              : CircleAvatar(
                                  radius: AppSizes.avatarXXLarge / 2,
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.2),
                                  child: const Icon(
                                    Icons.person,
                                    size: AppSizes.iconXXLarge,
                                    color: Colors.white,
                                  ),
                                ),
                        ),

                        const SizedBox(height: AppSizes.spaceLarge),

                        // User Name
                        Text(
                          user.name,
                          style: AppTextStyles.headline1(context).copyWith(
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: AppSizes.spaceXSmall),

                        // User Email
                        Text(
                          user.email,
                          style: AppTextStyles.bodyLarge(context).copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),

                        const SizedBox(height: AppSizes.spaceXLarge),

                        // Statistics Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                              context,
                              value: '5',
                              label: 'كورسات',
                              icon: Icons.school,
                            ),
                            _buildStatItem(
                              context,
                              value: '3',
                              label: 'شهادات',
                              icon: Icons.workspace_premium,
                            ),
                            _buildStatItem(
                              context,
                              value: '120',
                              label: 'ساعات',
                              icon: Icons.access_time,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXLarge),

                  // Settings List
                  Padding(
                    padding: screenPadding,
                    child: Column(
                      children: [
                        _buildProfileSetting(
                          context,
                          icon: Icons.person_outline,
                          title: 'الملف الشخصي',
                          subtitle: 'تعديل معلوماتك الشخصية',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),

                        _buildProfileSettingWithToggle(
                          context,
                          icon: Icons.notifications_outlined,
                          title: 'الإشعارات',
                          subtitle: 'إدارة الإشعارات والتنبيهات',
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),

                        _buildProfileSetting(
                          context,
                          icon: Icons.language_outlined,
                          title: 'اللغة',
                          subtitle: 'العربية',
                          onTap: () {
                            // Show language selection dialog
                            _showLanguageDialog(context);
                          },
                        ),

                        _buildProfileSettingWithToggle(
                          context,
                          icon: Icons.dark_mode_outlined,
                          title: 'الوضع الليلي',
                          subtitle: 'تفعيل الثيم الداكن',
                          value: _darkModeEnabled,
                          onChanged: (value) {
                            setState(() {
                              _darkModeEnabled = value;
                            });
                          },
                        ),

                        _buildProfileSetting(
                          context,
                          icon: Icons.workspace_premium_outlined,
                          title: 'الشهادات',
                          subtitle: 'عرض وإدارة شهاداتك',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CertificatesScreen(),
                              ),
                            );
                          },
                        ),

                        _buildProfileSetting(
                          context,
                          icon: Icons.help_outline,
                          title: 'المساعدة والدعم',
                          subtitle: 'مركز المساعدة والأسئلة الشائعة',
                          onTap: () {
                            _showHelpDialog(context);
                          },
                        ),

                        const SizedBox(height: AppSizes.spaceXXLarge),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          height: ResponsiveHelper.getButtonHeight(context),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showLogoutDialog(context);
                            },
                            icon: const Icon(
                              Icons.logout,
                              size: AppSizes.iconMedium,
                              color: AppColors.danger,
                            ),
                            label: Text(
                              'تسجيل الخروج',
                              style:
                                  AppTextStyles.buttonLarge(context).copyWith(
                                color: AppColors.danger,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.danger),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMedium),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSizes.spaceXXLarge),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.spaceSmall),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
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
          style: AppTextStyles.headline2(context).copyWith(
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: AppSizes.spaceXSmall / 2),
        Text(
          label,
          style: AppTextStyles.caption(context).copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSetting(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Card(
        elevation: AppSizes.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppSizes.spaceLarge),
          leading: Container(
            padding: const EdgeInsets.all(AppSizes.spaceSmall),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppSizes.iconMedium,
            ),
          ),
          title: Text(
            title,
            style: AppTextStyles.labelLarge(context),
          ),
          subtitle: Text(
            subtitle,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: AppSizes.iconSmall,
            color: AppColors.textLight,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildProfileSettingWithToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Card(
        elevation: AppSizes.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppSizes.spaceLarge),
          leading: Container(
            padding: const EdgeInsets.all(AppSizes.spaceSmall),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppSizes.iconMedium,
            ),
          ),
          title: Text(
            title,
            style: AppTextStyles.labelLarge(context),
          ),
          subtitle: Text(
            subtitle,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        title: Text(
          'اختيار اللغة',
          style: AppTextStyles.headline3(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              title: const Text('العربية'),
              trailing: const Icon(Icons.check, color: AppColors.primary),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        title: Text(
          'المساعدة والدعم',
          style: AppTextStyles.headline3(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'يمكنك التواصل معنا عبر:',
              style: AppTextStyles.bodyLarge(context),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            const Row(
              children: [
                Icon(Icons.email, size: AppSizes.iconSmall),
                SizedBox(width: AppSizes.spaceSmall),
                Text('support@waslaacademy.com'),
              ],
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            const Row(
              children: [
                Icon(Icons.phone, size: AppSizes.iconSmall),
                SizedBox(width: AppSizes.spaceSmall),
                Text('+966 50 123 4567'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        title: Text(
          'تسجيل الخروج',
          style: AppTextStyles.headline3(context),
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          style: AppTextStyles.bodyLarge(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyles.buttonMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
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
      ),
    );
  }
}
