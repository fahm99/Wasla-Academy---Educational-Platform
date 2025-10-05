import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/utils/responsive_helper.dart';

class CertificateCard extends StatelessWidget {
  final String studentName;
  final String courseName;
  final String issueDate;
  final String? certificateId;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onView;

  const CertificateCard({
    super.key,
    required this.studentName,
    required this.courseName,
    required this.issueDate,
    this.certificateId,
    this.onDownload,
    this.onShare,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final cardPadding = AppSizes.getCardPadding(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceLarge),
      child: Card(
        elevation: AppSizes.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF0F9FF), // #f0f9ff
                Color(0xFFE0F2FE), // #e0f2fe
              ],
            ),
          ),
          child: Column(
            children: [
              // Header with primary color
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(cardPadding),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radiusLarge),
                    topRight: Radius.circular(AppSizes.radiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spaceSmall),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMedium),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        size: AppSizes.iconLarge,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'شهادة إتمام',
                            style: AppTextStyles.labelLarge(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                          if (certificateId != null) ...[
                            const SizedBox(height: AppSizes.spaceXSmall / 2),
                            Text(
                              'رقم الشهادة: $certificateId',
                              style: AppTextStyles.caption(context).copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Certificate Content
              Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Name
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: AppSizes.iconSmall,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.spaceSmall),
                        Text(
                          'الطالب:',
                          style: AppTextStyles.labelMedium(context).copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceSmall),
                        Expanded(
                          child: Text(
                            studentName,
                            style: AppTextStyles.labelLarge(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.spaceMedium),

                    // Course Name
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.school,
                          size: AppSizes.iconSmall,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.spaceSmall),
                        Text(
                          'الكورس:',
                          style: AppTextStyles.labelMedium(context).copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceSmall),
                        Expanded(
                          child: Text(
                            courseName,
                            style: AppTextStyles.labelLarge(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.spaceMedium),

                    // Issue Date
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: AppSizes.iconSmall,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.spaceSmall),
                        Text(
                          'تاريخ الإصدار:',
                          style: AppTextStyles.labelMedium(context).copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceSmall),
                        Text(
                          issueDate,
                          style: AppTextStyles.labelMedium(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.spaceXLarge),

                    // Action Buttons
                    Row(
                      children: [
                        // View Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onView,
                            icon: const Icon(
                              Icons.visibility,
                              size: AppSizes.iconSmall,
                            ),
                            label: Text(
                              'عرض',
                              style:
                                  AppTextStyles.buttonMedium(context).copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMedium),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.spaceSmall,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: AppSizes.spaceSmall),

                        // Download Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onDownload,
                            icon: const Icon(
                              Icons.download,
                              size: AppSizes.iconSmall,
                              color: Colors.white,
                            ),
                            label: Text(
                              'تحميل',
                              style: AppTextStyles.buttonMedium(context),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMedium),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.spaceSmall,
                              ),
                              elevation: AppSizes.elevationLow,
                            ),
                          ),
                        ),

                        const SizedBox(width: AppSizes.spaceSmall),

                        // Share Button
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMedium),
                          ),
                          child: IconButton(
                            onPressed: onShare,
                            icon: const Icon(
                              Icons.share,
                              size: AppSizes.iconMedium,
                              color: AppColors.secondary,
                            ),
                            tooltip: 'مشاركة',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// قائمة الشهادات مع إمكانية التجميع
class CertificatesList extends StatelessWidget {
  final List<CertificateCard> certificates;
  final bool showEmptyState;
  final VoidCallback? onBrowseCourses;

  const CertificatesList({
    super.key,
    required this.certificates,
    this.showEmptyState = true,
    this.onBrowseCourses,
  });

  @override
  Widget build(BuildContext context) {
    if (certificates.isEmpty && showEmptyState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceXXLarge),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                size: AppSizes.iconXXXLarge,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXLarge),
            Text(
              'لا توجد شهادات',
              style: AppTextStyles.headline2(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            Text(
              'أكمل الكورسات للحصول على شهادات معتمدة',
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onBrowseCourses != null) ...[
              const SizedBox(height: AppSizes.spaceXXLarge),
              ElevatedButton(
                onPressed: onBrowseCourses,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceXXLarge,
                    vertical: AppSizes.spaceMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                child: Text(
                  'تصفح الكورسات',
                  style: AppTextStyles.buttonLarge(context),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.screenPaddingMobile),
      itemCount: certificates.length,
      itemBuilder: (context, index) => certificates[index],
    );
  }
}
