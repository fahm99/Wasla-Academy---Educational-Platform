import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/models/course.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';

class ResourceViewerScreen extends StatefulWidget {
  final Resource resource;

  const ResourceViewerScreen({
    super.key,
    required this.resource,
  });

  @override
  State<ResourceViewerScreen> createState() => _ResourceViewerScreenState();
}

class _ResourceViewerScreenState extends State<ResourceViewerScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.resource.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: _shareResource,
            icon: const Icon(Icons.share),
            tooltip: 'مشاركة',
          ),
        ],
      ),
      body: Column(
        children: [
          // Resource Info Card
          Container(
            width: double.infinity,
            margin: ResponsiveHelper.getScreenPadding(context),
            padding: const EdgeInsets.all(AppSizes.spaceLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              border: Border.all(color: AppColors.light),
            ),
            child: Column(
              children: [
                // Resource Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _getResourceColor().withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getResourceIcon(),
                    size: 40,
                    color: _getResourceColor(),
                  ),
                ),

                const SizedBox(height: AppSizes.spaceLarge),

                // Resource Name
                Text(
                  widget.resource.name,
                  style: AppTextStyles.headline2(context),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSizes.spaceMedium),

                // Resource Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDetailItem(
                      icon: Icons.storage,
                      label: 'الحجم',
                      value: widget.resource.size,
                    ),
                    _buildDetailItem(
                      icon: Icons.calendar_today,
                      label: 'التاريخ',
                      value: widget.resource.date,
                    ),
                    _buildDetailItem(
                      icon: Icons.category,
                      label: 'النوع',
                      value: _getResourceTypeText(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceLarge),

          // Download Section
          Expanded(
            child: Container(
              width: double.infinity,
              margin: ResponsiveHelper.getScreenPadding(context),
              padding: const EdgeInsets.all(AppSizes.spaceLarge),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(color: AppColors.light),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isDownloading) ...[
                    // Download Progress
                    CircularProgressIndicator(
                      value: _downloadProgress,
                      backgroundColor: AppColors.light,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                      strokeWidth: 6,
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    Text(
                      'جاري التحميل...',
                      style: AppTextStyles.bodyLarge(context),
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      '${(_downloadProgress * 100).toInt()}%',
                      style: AppTextStyles.labelLarge(context).copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ] else ...[
                    // Download Button
                    const Icon(
                      Icons.cloud_download,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    Text(
                      'تحميل الملف',
                      style: AppTextStyles.headline2(context),
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      'اضغط على الزر أدناه لتحميل الملف على جهازك',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _downloadResource,
                        icon: const Icon(Icons.download),
                        label: const Text('تحميل الآن'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.spaceLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            width: double.infinity,
            padding: ResponsiveHelper.getScreenPadding(context),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previewResource,
                    icon: const Icon(Icons.visibility),
                    label: const Text('معاينة'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spaceMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceMedium),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openResource,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('فتح'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spaceMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: AppSizes.iconMedium,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSizes.spaceXSmall),
        Text(
          label,
          style: AppTextStyles.caption(context),
        ),
        const SizedBox(height: AppSizes.spaceXSmall),
        Text(
          value,
          style: AppTextStyles.labelMedium(context),
        ),
      ],
    );
  }

  IconData _getResourceIcon() {
    switch (widget.resource.type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'zip':
        return Icons.archive;
      case 'video':
        return Icons.video_library;
      case 'document':
      case 'docx':
        return Icons.description;
      case 'spreadsheet':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getResourceColor() {
    switch (widget.resource.type.toLowerCase()) {
      case 'pdf':
        return AppColors.danger;
      case 'zip':
        return AppColors.warning;
      case 'video':
        return AppColors.primary;
      case 'document':
      case 'docx':
        return AppColors.info;
      case 'spreadsheet':
      case 'xlsx':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getResourceTypeText() {
    switch (widget.resource.type.toLowerCase()) {
      case 'pdf':
        return 'PDF';
      case 'zip':
        return 'أرشيف';
      case 'video':
        return 'فيديو';
      case 'document':
      case 'docx':
        return 'مستند';
      case 'spreadsheet':
      case 'xlsx':
        return 'جدول بيانات';
      default:
        return 'ملف';
    }
  }

  void _downloadResource() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    // Simulate download progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _downloadProgress = i / 100;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: AppSizes.spaceSmall),
              Expanded(
                child: Text('تم تحميل ${widget.resource.name} بنجاح'),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
        ),
      );
    }
  }

  void _previewResource() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('معاينة ${widget.resource.name}'),
        action: SnackBarAction(
          label: 'فتح',
          onPressed: () {
            // Implement preview functionality
          },
        ),
      ),
    );
  }

  void _openResource() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح ${widget.resource.name}'),
        action: SnackBarAction(
          label: 'موافق',
          onPressed: () {},
        ),
      ),
    );
  }

  void _shareResource() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('مشاركة ${widget.resource.name}'),
        action: SnackBarAction(
          label: 'مشاركة',
          onPressed: () {
            // Implement share functionality
          },
        ),
      ),
    );
  }
}
