import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/helpers.dart';
import '../bloc/certificates_bloc.dart';
import 'certificate_detail_page.dart';

/// صفحة الشهادات
class CertificatesPage extends StatefulWidget {
  const CertificatesPage({super.key});

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  @override
  void initState() {
    super.initState();
    // Load certificates - will need student ID from auth
    // context.read<CertificatesBloc>().add(LoadMyCertificatesEvent(studentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'شهاداتي',
          style: AppTextStyles.headlineMedium(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocConsumer<CertificatesBloc, CertificatesState>(
        listener: (context, state) {
          if (state is CertificatesError) {
            Helpers.showErrorSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CertificatesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MyCertificatesLoaded) {
            final certificates = state.certificates;

            if (certificates.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.lg),
              itemCount: certificates.length,
              itemBuilder: (context, index) {
                final certificate = certificates[index];
                return _buildCertificateCard(certificate);
              },
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'لا توجد شهادات',
            style: AppTextStyles.headlineSmall(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'أكمل الكورسات واجتاز الامتحانات للحصول على الشهادات',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(certificate) {
    final isExpired = certificate.expiryDate != null &&
        certificate.expiryDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.lg),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CertificateDetailPage(
                certificate: certificate,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isExpired
                          ? AppColors.textLight.withOpacity(0.1)
                          : AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      Icons.workspace_premium,
                      size: 32,
                      color:
                          isExpired ? AppColors.textLight : AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certificate.courseName ?? 'شهادة إتمام',
                          style: AppTextStyles.headlineSmall(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          certificate.providerName ?? 'مقدم الخدمة',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textLight,
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.lg),

              const Divider(),

              const SizedBox(height: AppSizes.md),

              // Info
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.numbers,
                      label: 'رقم الشهادة',
                      value: certificate.certificateNumber,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.calendar_today,
                      label: 'تاريخ الإصدار',
                      value: Helpers.formatDate(certificate.issueDate),
                    ),
                  ),
                ],
              ),

              if (certificate.expiryDate != null) ...[
                const SizedBox(height: AppSizes.md),
                _buildInfoItem(
                  context,
                  icon: Icons.event_busy,
                  label: 'تاريخ الانتهاء',
                  value: Helpers.formatDate(certificate.expiryDate!),
                  valueColor: isExpired ? AppColors.error : null,
                ),
              ],

              if (isExpired) ...[
                const SizedBox(height: AppSizes.md),
                Container(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    border: Border.all(
                      color: AppColors.error.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        'هذه الشهادة منتهية الصلاحية',
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSizes.xs),
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
              Text(
                value,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
