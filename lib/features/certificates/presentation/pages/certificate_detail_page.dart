import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/certificate.dart';

/// صفحة تفاصيل الشهادة
class CertificateDetailPage extends StatelessWidget {
  final Certificate certificate;

  const CertificateDetailPage({
    super.key,
    required this.certificate,
  });

  @override
  Widget build(BuildContext context) {
    final isExpired = certificate.expiryDate != null &&
        certificate.expiryDate!.isBefore(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'تفاصيل الشهادة',
          style: AppTextStyles.headlineMedium(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Helpers.showInfoSnackbar(context, 'سيتم إضافة المشاركة قريباً');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          children: [
            // Certificate Preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.xxl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isExpired
                      ? [
                          AppColors.textLight.withOpacity(0.1),
                          AppColors.textLight.withOpacity(0.2),
                        ]
                      : [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.secondary.withOpacity(0.1),
                        ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: isExpired
                      ? AppColors.textLight.withOpacity(0.3)
                      : AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    size: 80,
                    color: isExpired ? AppColors.textLight : AppColors.primary,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'شهادة إتمام',
                    style: AppTextStyles.headlineLarge(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    certificate.courseName ?? 'اسم الكورس',
                    style: AppTextStyles.headlineSmall(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  Text(
                    certificate.studentName ?? 'اسم الطالب',
                    style: AppTextStyles.headlineMedium(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    certificate.providerName ?? 'مقدم الخدمة',
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xxl),

            // Certificate Details
            Container(
              padding: const EdgeInsets.all(AppSizes.xl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات الشهادة',
                    style: AppTextStyles.headlineSmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  _buildDetailRow(
                    context,
                    icon: Icons.numbers,
                    label: 'رقم الشهادة',
                    value: certificate.certificateNumber,
                    onCopy: () {
                      Clipboard.setData(
                        ClipboardData(text: certificate.certificateNumber),
                      );
                      Helpers.showSuccessSnackbar(
                        context,
                        'تم نسخ رقم الشهادة',
                      );
                    },
                  ),
                  const Divider(height: AppSizes.xl),
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_today,
                    label: 'تاريخ الإصدار',
                    value: Helpers.formatDate(certificate.issueDate),
                  ),
                  if (certificate.expiryDate != null) ...[
                    const Divider(height: AppSizes.xl),
                    _buildDetailRow(
                      context,
                      icon: Icons.event_busy,
                      label: 'تاريخ الانتهاء',
                      value: Helpers.formatDate(certificate.expiryDate!),
                      valueColor: isExpired ? AppColors.error : null,
                    ),
                  ],
                  const Divider(height: AppSizes.xl),
                  _buildDetailRow(
                    context,
                    icon: Icons.info_outline,
                    label: 'الحالة',
                    value: isExpired ? 'منتهية' : 'سارية',
                    valueColor: isExpired ? AppColors.error : AppColors.success,
                  ),
                ],
              ),
            ),

            if (isExpired) ...[
              const SizedBox(height: AppSizes.xl),
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        'هذه الشهادة منتهية الصلاحية. قد تحتاج إلى إعادة الكورس للحصول على شهادة جديدة.',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSizes.xxl),

            // Actions
            if (certificate.certificateUrl != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Helpers.showInfoSnackbar(
                      context,
                      'سيتم إضافة تحميل الشهادة قريباً',
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('تحميل الشهادة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.lg,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: AppSizes.md),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Helpers.showInfoSnackbar(
                    context,
                    'سيتم إضافة التحقق من الشهادة قريباً',
                  );
                },
                icon: const Icon(Icons.verified_outlined),
                label: const Text('التحقق من الشهادة'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.lg,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    VoidCallback? onCopy,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall(context).copyWith(
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                value,
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (onCopy != null)
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            onPressed: onCopy,
            color: AppColors.primary,
          ),
      ],
    );
  }
}
