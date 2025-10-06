import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/blocs/auth/auth_bloc.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';
import 'package:waslaacademy/src/services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'العربية';
  String _videoQuality = 'تلقائي';
  String _downloadOption = 'عبر شبكة الواي فاي فقط';
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _autoDownload = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final localStorage = await LocalStorageService.getInstance();
    final themeMode = await localStorage.getThemeMode();
    setState(() {
      _isDarkMode = themeMode == 'dark';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: AppTextStyles.headline2(context).copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'المساعدة',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthSuccess) {
                  return _buildUserProfileSection(state.user);
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: AppSizes.spaceLarge),

            // Settings Sections
            _buildSectionTitle('المظهر والعرض'),
            _buildSettingItem(
              icon: Icons.language,
              title: 'اللغة',
              subtitle: _language,
              onTap: _showLanguageDialog,
            ),
            _buildSettingItemWithToggle(
              icon: Icons.dark_mode,
              title: 'الوضع الليلي',
              subtitle: 'تفعيل الوضع الليلي',
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),

            const SizedBox(height: AppSizes.spaceLarge),

            _buildSectionTitle('الفيديو والتحميل'),
            _buildSettingItem(
              icon: Icons.high_quality,
              title: 'جودة الفيديو',
              subtitle: _videoQuality,
              onTap: _showVideoQualityDialog,
            ),
            _buildSettingItem(
              icon: Icons.download,
              title: 'التنزيل التلقائي',
              subtitle: _downloadOption,
              onTap: _showDownloadOptionsDialog,
            ),
            _buildSettingItemWithToggle(
              icon: Icons.wifi,
              title: 'التحميل عبر الواي فاي فقط',
              subtitle: 'توفير البيانات',
              value: _autoDownload,
              onChanged: (value) {
                setState(() {
                  _autoDownload = value;
                });
              },
            ),

            const SizedBox(height: AppSizes.spaceLarge),

            _buildSectionTitle('الإشعارات'),
            _buildSettingItemWithToggle(
              icon: Icons.notifications,
              title: 'الإشعارات',
              subtitle: 'تلقي إشعارات الكورسات الجديدة',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),

            const SizedBox(height: AppSizes.spaceLarge),

            _buildSectionTitle('التخزين والبيانات'),
            _buildSettingItem(
              icon: Icons.storage,
              title: 'مساحة التخزين',
              subtitle: '1.2 GB مستخدم من 5 GB',
              onTap: _showStorageManagement,
            ),
            _buildSettingItem(
              icon: Icons.cached,
              title: 'مسح البيانات المؤقتة',
              subtitle: 'تحرير مساحة التخزين',
              onTap: _clearCache,
            ),

            const SizedBox(height: AppSizes.spaceLarge),

            _buildSectionTitle('الحساب'),
            _buildSettingItem(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              subtitle: 'الخروج من الحساب الحالي',
              onTap: _showLogoutDialog,
              isDestructive: true,
            ),

            const SizedBox(height: AppSizes.spaceLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(user) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.light),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage:
                user.avatar != null ? NetworkImage(user.avatar!) : null,
            child: user.avatar == null
                ? Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.headline1(context).copyWith(
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSizes.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.headline2(context),
                ),
                const SizedBox(height: AppSizes.spaceXSmall),
                Text(
                  user.email,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                Row(
                  children: [
                    _buildStatChip('${user.enrolledCourses.length} كورس',
                        AppColors.primary),
                    const SizedBox(width: AppSizes.spaceSmall),
                    _buildStatChip('${user.completedCourses.length} مكتمل',
                        AppColors.success),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceSmall,
        vertical: AppSizes.spaceXSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption(context).copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
      child: Text(
        title,
        style: AppTextStyles.headline3(context).copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spaceMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              border: Border.all(color: AppColors.light),
            ),
            child: Row(
              children: [
                Container(
                  width: AppSizes.avatarMedium,
                  height: AppSizes.avatarMedium,
                  decoration: BoxDecoration(
                    color:
                        (isDestructive ? AppColors.danger : AppColors.primary)
                            .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconMedium,
                    color: isDestructive ? AppColors.danger : AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.labelLarge(context).copyWith(
                          color: isDestructive
                              ? AppColors.danger
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceXSmall),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall(context),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: AppSizes.iconSmall,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItemWithToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spaceMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: AppColors.light),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.avatarMedium,
              height: AppSizes.avatarMedium,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSizes.iconMedium,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSizes.spaceMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge(context),
                  ),
                  const SizedBox(height: AppSizes.spaceXSmall),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall(context),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              activeColor: AppColors.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });

    final localStorage = await LocalStorageService.getInstance();
    await localStorage.saveThemeMode(value ? 'dark' : 'light');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(value ? 'تم تفعيل الوضع الليلي' : 'تم إلغاء الوضع الليلي'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'مسح البيانات المؤقتة',
          style: AppTextStyles.headline3(context),
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في مسح جميع البيانات المؤقتة؟ سيؤدي هذا إلى تحرير مساحة التخزين.',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم مسح البيانات المؤقتة بنجاح'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'مسح',
              style: AppTextStyles.buttonMedium(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'اختيار اللغة',
          style: AppTextStyles.headline3(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('🇸🇦', 'العربية'),
            _buildLanguageOption('🇺🇸', 'English'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String flag, String language) {
    final isSelected = _language == language;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _language = language;
          });
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceMedium),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSizes.spaceMedium),
              Expanded(
                child: Text(
                  language,
                  style: AppTextStyles.bodyLarge(context),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: AppSizes.iconMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoQualityDialog() {
    final qualities = ['تلقائي', '720p', '480p', '360p'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'جودة الفيديو',
          style: AppTextStyles.headline3(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              qualities.map((quality) => _buildQualityOption(quality)).toList(),
        ),
      ),
    );
  }

  Widget _buildQualityOption(String quality) {
    final isSelected = _videoQuality == quality;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _videoQuality = quality;
          });
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceMedium),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  quality,
                  style: AppTextStyles.bodyLarge(context),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: AppSizes.iconMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDownloadOptionsDialog() {
    final options = [
      'عبر شبكة الواي فاي فقط',
      'عبر الواي فاي والبيانات',
      'إيقاف التنزيل التلقائي',
    ];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'خيارات التنزيل',
          style: AppTextStyles.headline3(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              options.map((option) => _buildDownloadOption(option)).toList(),
        ),
      ),
    );
  }

  Widget _buildDownloadOption(String option) {
    final isSelected = _downloadOption == option;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _downloadOption = option;
          });
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceMedium),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: AppTextStyles.bodyLarge(context),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: AppSizes.iconMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStorageManagement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إدارة مساحة التخزين',
          style: AppTextStyles.headline3(context),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Storage Overview
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceMedium),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المساحة المستخدمة',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                      Text(
                        '1.2 GB من 5 GB',
                        style: AppTextStyles.labelMedium(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  LinearProgressIndicator(
                    value: 0.24,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXSmall),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceMedium),

            Text(
              'تفاصيل الاستخدام:',
              style: AppTextStyles.labelLarge(context),
            ),
            const SizedBox(height: AppSizes.spaceSmall),

            _buildStorageItem(
                'الفيديوهات', '800 MB', Icons.video_library, AppColors.primary),
            _buildStorageItem('المواد التعليمية', '300 MB', Icons.description,
                AppColors.info),
            _buildStorageItem(
                'الصور', '100 MB', Icons.image, AppColors.success),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: AppTextStyles.buttonMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم مسح الملفات المؤقتة'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'مسح الملفات المؤقتة',
              style: AppTextStyles.buttonMedium(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(
      String title, String size, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceSmall),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.iconSmall,
            color: color,
          ),
          const SizedBox(width: AppSizes.spaceSmall),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium(context),
            ),
          ),
          Text(
            size,
            style: AppTextStyles.labelMedium(context).copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceLarge),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.light,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceMedium),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: AppColors.primary,
                  size: AppSizes.iconXLarge,
                ),
              ),
              const SizedBox(height: AppSizes.spaceMedium),
              Text(
                'مساعدة الإعدادات',
                style: AppTextStyles.headline2(context).copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSizes.spaceSmall),
              Text(
                'يمكنك تخصيص تجربة التعلم الخاصة بك من خلال:\n\n'
                '• تغيير اللغة والمظهر\n'
                '• ضبط جودة الفيديو\n'
                '• إدارة خيارات التحميل\n'
                '• تفعيل الإشعارات\n'
                '• إدارة مساحة التخزين',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.spaceMedium,
                    ),
                  ),
                  child: Text(
                    'فهمت',
                    style: AppTextStyles.buttonMedium(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
