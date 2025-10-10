import 'package:flutter/material.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';
import 'package:waslaacademy/src/user/widgets/custom_app_bar.dart';
import 'package:waslaacademy/src/user/widgets/empty_state.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for downloads
  final List<DownloadItem> _completedDownloads = [
    DownloadItem(
      id: 1,
      title: 'مقدمة في البرمجة - الدرس الأول',
      courseName: 'أساسيات البرمجة',
      size: '45 MB',
      downloadDate: DateTime.now().subtract(const Duration(days: 1)),
      type: DownloadType.video,
    ),
    DownloadItem(
      id: 2,
      title: 'ملف المراجع والمصادر',
      courseName: 'أساسيات البرمجة',
      size: '2.3 MB',
      downloadDate: DateTime.now().subtract(const Duration(days: 2)),
      type: DownloadType.document,
    ),
  ];

  final List<DownloadItem> _activeDownloads = [
    DownloadItem(
      id: 3,
      title: 'الدرس الثاني - المتغيرات',
      courseName: 'أساسيات البرمجة',
      size: '67 MB',
      downloadDate: DateTime.now(),
      type: DownloadType.video,
      progress: 0.65,
      isDownloading: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'التنزيلات',
        onBack: () => Navigator.pop(context),
        actions: [
          IconButton(
            onPressed: _showDownloadSettings,
            icon: const Icon(Icons.settings),
            tooltip: 'إعدادات التنزيل',
          ),
        ],
      ),
      body: Column(
        children: [
          // Storage Info
          Container(
            margin: screenPadding,
            padding: const EdgeInsets.all(AppSizes.spaceLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'مساحة التخزين المستخدمة',
                      style: AppTextStyles.labelLarge(context),
                    ),
                    Text(
                      '1.2 GB من 5 GB',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceSmall),
                const LinearProgressIndicator(
                  value: 0.24,
                  backgroundColor: AppColors.light,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelStyle: AppTextStyles.labelLarge(context),
              unselectedLabelStyle: AppTextStyles.labelMedium(context),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'جاري التنزيل'),
                Tab(text: 'مكتملة'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active Downloads Tab
                _buildActiveDownloadsTab(screenPadding),

                // Completed Downloads Tab
                _buildCompletedDownloadsTab(screenPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDownloadsTab(EdgeInsets screenPadding) {
    if (_activeDownloads.isEmpty) {
      return const EmptyState(
        icon: Icons.download_outlined,
        title: 'لا توجد تنزيلات نشطة',
        subtitle: 'ابدأ بتنزيل الدروس للوصول إليها بدون إنترنت',
        iconColor: AppColors.primary,
      );
    }

    return ListView.builder(
      padding: screenPadding,
      itemCount: _activeDownloads.length,
      itemBuilder: (context, index) {
        return _buildDownloadItem(_activeDownloads[index]);
      },
    );
  }

  Widget _buildCompletedDownloadsTab(EdgeInsets screenPadding) {
    if (_completedDownloads.isEmpty) {
      return const EmptyState(
        icon: Icons.download_done,
        title: 'لا توجد تنزيلات مكتملة',
        subtitle: 'التنزيلات المكتملة ستظهر هنا',
        iconColor: AppColors.success,
      );
    }

    return ListView.builder(
      padding: screenPadding,
      itemCount: _completedDownloads.length,
      itemBuilder: (context, index) {
        return _buildDownloadItem(_completedDownloads[index]);
      },
    );
  }

  Widget _buildDownloadItem(DownloadItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
      child: Card(
        elevation: AppSizes.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spaceSmall),
                    decoration: BoxDecoration(
                      color: _getTypeColor(item.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Icon(
                      _getTypeIcon(item.type),
                      color: _getTypeColor(item.type),
                      size: AppSizes.iconMedium,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTextStyles.labelLarge(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSizes.spaceXSmall),
                        Text(
                          item.courseName,
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Button
                  if (item.isDownloading)
                    IconButton(
                      onPressed: () => _pauseDownload(item),
                      icon: const Icon(Icons.pause),
                      tooltip: 'إيقاف مؤقت',
                    )
                  else
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleDownloadAction(value, item),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'play',
                          child: Row(
                            children: [
                              Icon(Icons.play_arrow),
                              SizedBox(width: 8),
                              Text('تشغيل'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: AppColors.danger),
                              SizedBox(width: 8),
                              Text('حذف',
                                  style: TextStyle(color: AppColors.danger)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              // Progress Bar (for active downloads)
              if (item.isDownloading) ...[
                const SizedBox(height: AppSizes.spaceMedium),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: item.progress,
                        backgroundColor: AppColors.light,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                    Text(
                      '${(item.progress! * 100).round()}%',
                      style: AppTextStyles.caption(context),
                    ),
                  ],
                ),
              ],

              // Footer
              const SizedBox(height: AppSizes.spaceSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.size,
                    style: AppTextStyles.caption(context),
                  ),
                  Text(
                    _formatDate(item.downloadDate),
                    style: AppTextStyles.caption(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(DownloadType type) {
    switch (type) {
      case DownloadType.video:
        return Icons.play_circle_outline;
      case DownloadType.document:
        return Icons.description_outlined;
      case DownloadType.audio:
        return Icons.audiotrack;
    }
  }

  Color _getTypeColor(DownloadType type) {
    switch (type) {
      case DownloadType.video:
        return AppColors.primary;
      case DownloadType.document:
        return AppColors.secondary;
      case DownloadType.audio:
        return AppColors.success;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'اليوم';
    } else if (difference == 1) {
      return 'أمس';
    } else {
      return 'منذ $difference أيام';
    }
  }

  void _pauseDownload(DownloadItem item) {
    setState(() {
      item.isDownloading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إيقاف تنزيل "${item.title}" مؤقتاً'),
        action: SnackBarAction(
          label: 'استئناف',
          onPressed: () {
            setState(() {
              item.isDownloading = true;
            });
          },
        ),
      ),
    );
  }

  void _handleDownloadAction(String action, DownloadItem item) {
    switch (action) {
      case 'play':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تشغيل "${item.title}"')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(item);
        break;
    }
  }

  void _showDeleteConfirmation(DownloadItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التنزيل'),
        content: Text('هل أنت متأكد من حذف "${item.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _completedDownloads.remove(item);
                _activeDownloads.remove(item);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف "${item.title}"'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showDownloadSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعدادات التنزيل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('التنزيل عبر الواي فاي فقط'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.hd),
              title: const Text('جودة التنزيل'),
              subtitle: const Text('عالية'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('مجلد التنزيل'),
              subtitle: const Text('/storage/downloads'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

// Data Models
enum DownloadType { video, document, audio }

class DownloadItem {
  final int id;
  final String title;
  final String courseName;
  final String size;
  final DateTime downloadDate;
  final DownloadType type;
  final double? progress;
  bool isDownloading;

  DownloadItem({
    required this.id,
    required this.title,
    required this.courseName,
    required this.size,
    required this.downloadDate,
    required this.type,
    this.progress,
    this.isDownloading = false,
  });
}
