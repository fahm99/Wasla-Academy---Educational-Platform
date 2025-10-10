import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/constants/app_sizes.dart';
import 'package:waslaacademy/src/user/constants/app_text_styles.dart';
import 'package:waslaacademy/src/user/utils/responsive_helper.dart';
import 'package:waslaacademy/src/user/models/certificate.dart';
import 'package:waslaacademy/src/user/widgets/certificate_card.dart';
import 'package:waslaacademy/src/user/widgets/empty_state.dart';
import 'package:waslaacademy/src/user/views/courses_screen.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  List<Certificate> _certificates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  void _loadCertificates() {
    // Mock certificates data
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _certificates = [
          Certificate(
            id: 'cert_001',
            courseId: 'course_1',
            courseName: 'تطوير تطبيقات Flutter',
            studentName: 'أحمد محمد علي',
            studentId: 'student_123',
            issueDate: DateTime.now().subtract(const Duration(days: 30)),
            certificateUrl: 'https://example.com/cert1.pdf',
            instructorName: 'د. سارة أحمد',
            institutionName: 'أكاديمية وصلة',
            grade: 95.5,
            gradeLevel: 'ممتاز',
          ),
          Certificate(
            id: 'cert_002',
            courseId: 'course_2',
            courseName: 'أساسيات البرمجة بـ JavaScript',
            studentName: 'أحمد محمد علي',
            studentId: 'student_123',
            issueDate: DateTime.now().subtract(const Duration(days: 60)),
            certificateUrl: 'https://example.com/cert2.pdf',
            instructorName: 'م. خالد يوسف',
            institutionName: 'أكاديمية وصلة',
            grade: 88.0,
            gradeLevel: 'جيد جداً',
          ),
          Certificate(
            id: 'cert_003',
            courseId: 'course_3',
            courseName: 'تصميم واجهات المستخدم UI/UX',
            studentName: 'أحمد محمد علي',
            studentId: 'student_123',
            issueDate: DateTime.now().subtract(const Duration(days: 90)),
            certificateUrl: 'https://example.com/cert3.pdf',
            instructorName: 'أ. فاطمة حسن',
            institutionName: 'أكاديمية وصلة',
            grade: 92.0,
            gradeLevel: 'ممتاز',
          ),
        ];
        _isLoading = false;
      });
    });
  }

  void _downloadCertificate(Certificate certificate) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppSizes.spaceLarge),
            Text(
              'جاري تحميل الشهادة...',
              style: AppTextStyles.bodyLarge(context),
            ),
          ],
        ),
      ),
    );

    // Simulate download
    final success = await certificate.download();

    Navigator.of(context).pop(); // Close loading dialog

    // Show result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'تم تحميل الشهادة بنجاح' : 'فشل في تحميل الشهادة',
          style: AppTextStyles.bodyLarge(context).copyWith(color: Colors.white),
        ),
        backgroundColor: success ? AppColors.success : AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
      ),
    );
  }

  void _shareCertificate(Certificate certificate) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppSizes.spaceLarge),
            Text(
              'جاري مشاركة الشهادة...',
              style: AppTextStyles.bodyLarge(context),
            ),
          ],
        ),
      ),
    );

    // Simulate share
    final success = await certificate.share();

    Navigator.of(context).pop(); // Close loading dialog

    // Show result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'تم مشاركة الشهادة بنجاح' : 'فشل في مشاركة الشهادة',
          style: AppTextStyles.bodyLarge(context).copyWith(color: Colors.white),
        ),
        backgroundColor: success ? AppColors.success : AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
      ),
    );
  }

  // New method to share certificate as image or link
  void _shareCertificateAsImage(Certificate certificate) {
    // Generate share text
    final shareText = certificate.generateShareText();

    // In a real app, you would generate an image of the certificate
    // For now, we'll just share the text with a link

    Share.share(
      '$shareText\n\nرابط الشهادة: ${certificate.certificateUrl}',
      subject: 'شهادة إتمام - ${certificate.courseName}',
    );
  }

  void _viewCertificate(Certificate certificate) {
    // Show certificate preview dialog
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceXLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Certificate Preview Header
              Row(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: AppSizes.iconLarge,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: AppSizes.spaceMedium),
                  Expanded(
                    child: Text(
                      'معاينة الشهادة',
                      style: AppTextStyles.headline2(context),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceXLarge),

              // Certificate Mock Preview
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      size: AppSizes.iconXXXLarge,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    Text(
                      'شهادة إتمام',
                      style: AppTextStyles.headline2(context).copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      certificate.courseName,
                      style: AppTextStyles.bodyLarge(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      certificate.studentName,
                      style: AppTextStyles.labelLarge(context).copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      'تاريخ الإصدار: ${certificate.getFormattedIssueDate()}',
                      style: AppTextStyles.caption(context),
                    ),
                    if (certificate.grade != null) ...[
                      const SizedBox(height: AppSizes.spaceSmall),
                      Text(
                        'التقدير: ${certificate.getGradeDisplayText()}',
                        style: AppTextStyles.labelLarge(context).copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceXLarge),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _downloadCertificate(certificate);
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('تحميل'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceMedium),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _shareCertificateAsImage(certificate);
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'شهاداتي',
          style: AppTextStyles.headline2(context),
        ),
        backgroundColor: Colors.white,
        elevation: AppSizes.elevationLow,
        actions: [
          IconButton(
            onPressed: _loadCertificates,
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _certificates.isEmpty
              ? EmptyState.noCertificates(
                  onBrowsePressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CoursesScreen(),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    // Statistics Header
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(screenPadding.horizontal / 2),
                      padding: const EdgeInsets.all(AppSizes.spaceLarge),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMedium),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: AppSizes.elevationMedium,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildStatItem(
                            context,
                            icon: Icons.workspace_premium,
                            label: 'إجمالي الشهادات',
                            value: '${_certificates.length}',
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSizes.spaceLarge),
                          _buildStatItem(
                            context,
                            icon: Icons.star,
                            label: 'شهادات ممتازة',
                            value:
                                '${_certificates.where((c) => c.gradeLevel == 'ممتاز').length}',
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: AppSizes.spaceLarge),
                          _buildStatItem(
                            context,
                            icon: Icons.trending_up,
                            label: 'هذا الشهر',
                            value:
                                '${_certificates.where((c) => c.isRecent).length}',
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    ),

                    // Certificates List
                    Expanded(
                      child: ListView.builder(
                        padding: screenPadding,
                        itemCount: _certificates.length,
                        itemBuilder: (context, index) {
                          final certificate = _certificates[index];
                          return CertificateCard(
                            studentName: certificate.studentName,
                            courseName: certificate.courseName,
                            issueDate: certificate.getFormattedIssueDate(),
                            certificateId: certificate.getCertificateNumber(),
                            onDownload: () => _downloadCertificate(certificate),
                            onShare: () =>
                                _shareCertificateAsImage(certificate),
                            onView: () => _viewCertificate(certificate),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spaceSmall),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppSizes.iconMedium,
              color: color,
            ),
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Text(
            value,
            style: AppTextStyles.headline2(context).copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXSmall),
          Text(
            label,
            style: AppTextStyles.caption(context),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
