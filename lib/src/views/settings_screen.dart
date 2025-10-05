import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _language = 'العربية';
  String _videoQuality = 'تلقائي';
  String _downloadOption = 'عبر شبكة الواي فاي فقط';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'الإعدادات',
        onBack: () => Navigator.pop(context),
        showAuthIcons: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Colors.white),
            onPressed: () {
              _showHelpDialog(context);
            },
            tooltip: 'المساعدة',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSettingItem(
              icon: Icons.language,
              title: 'اللغة',
              subtitle: _language,
              onTap: () {
                _showLanguageDialog();
              },
            ),
            _buildSettingItemWithToggle(
              icon: Icons.dark_mode,
              title: 'الوضع الليلي',
              subtitle: 'تفعيل الوضع الليلي',
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
            ),
            _buildSettingItem(
              icon: Icons.high_quality,
              title: 'جودة الفيديو',
              subtitle: _videoQuality,
              onTap: () {
                _showVideoQualityDialog();
              },
            ),
            _buildSettingItem(
              icon: Icons.download,
              title: 'التنزيل التلقائي',
              subtitle: _downloadOption,
              onTap: () {
                _showDownloadOptionsDialog();
              },
            ),
            _buildSettingItem(
              icon: Icons.storage,
              title: 'مساحة التخزين',
              subtitle: '1.2 GB مستخدم من 5 GB',
              onTap: () {
                _showStorageManagement();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
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
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Switch(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختيار اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              title: const Text('العربية'),
              trailing: _language == 'العربية'
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _language = 'العربية';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing: _language == 'English'
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _language = 'English';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('جودة الفيديو'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'تلقائي',
            '720p',
            '480p',
            '360p',
          ]
              .map((quality) => ListTile(
                    title: Text(quality),
                    trailing: _videoQuality == quality
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _videoQuality = quality;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showDownloadOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خيارات التنزيل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'عبر شبكة الواي فاي فقط',
            'عبر الواي فاي والبيانات',
            'إيقاف التنزيل التلقائي',
          ]
              .map((option) => ListTile(
                    title: Text(option),
                    trailing: _downloadOption == option
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _downloadOption = option;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showStorageManagement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إدارة مساحة التخزين'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('المساحة المستخدمة: 1.2 GB'),
            const Text('المساحة المتاحة: 3.8 GB'),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.24,
              backgroundColor: Colors.grey[300],
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('الملفات المحملة:'),
            const Text('• الفيديوهات: 800 MB'),
            const Text('• المواد التعليمية: 300 MB'),
            const Text('• الصور: 100 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
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
            child: const Text('مسح الملفات المؤقتة'),
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
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
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
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  color: AppColors.primary,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'مساعدة الإعدادات',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'يمكنك تخصيص تجربة التعلم الخاصة بك من خلال:\n\n'
                '• تغيير اللغة\n'
                '• ضبط جودة الفيديو\n'
                '• إدارة خيارات التحميل\n'
                '• تفعيل الوضع المظلم\n'
                '• إدارة مساحة التخزين',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                ),
                child: const Text(
                  'فهمت',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
