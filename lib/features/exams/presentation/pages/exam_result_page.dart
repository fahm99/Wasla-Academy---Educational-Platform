import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/exam_result.dart';

/// صفحة نتيجة الامتحان
class ExamResultPage extends StatelessWidget {
  final ExamResult result;

  const ExamResultPage({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: Text(
          'نتيجة الامتحان',
          style: AppTextStyles.headlineMedium(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          children: [
            // Result Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: result.passed
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                result.passed ? Icons.check_circle : Icons.cancel,
                size: 64,
                color: result.passed ? AppColors.success : AppColors.error,
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // Result Status
            Text(
              result.passed ? 'مبروك! لقد نجحت' : 'للأسف، لم تنجح',
              style: AppTextStyles.headlineLarge(context).copyWith(
                color: result.passed ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSizes.xl),

            // Score Card
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
                children: [
                  // Percentage
                  Text(
                    '${result.percentage.toStringAsFixed(1)}%',
                    style: AppTextStyles.headlineLarge(context).copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color:
                          result.passed ? AppColors.success : AppColors.error,
                    ),
                  ),

                  const SizedBox(height: AppSizes.md),

                  // Score Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'النتيجة: ',
                        style: AppTextStyles.bodyLarge(context),
                      ),
                      Text(
                        '${result.score} / ${result.totalScore}',
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.lg),

                  const Divider(),

                  const SizedBox(height: AppSizes.lg),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        context,
                        icon: Icons.check_circle_outline,
                        label: 'إجابات صحيحة',
                        value: result.score.toString(),
                        color: AppColors.success,
                      ),
                      _buildStat(
                        context,
                        icon: Icons.cancel_outlined,
                        label: 'إجابات خاطئة',
                        value: (result.totalScore - result.score).toString(),
                        color: AppColors.error,
                      ),
                      _buildStat(
                        context,
                        icon: Icons.repeat,
                        label: 'المحاولة',
                        value: result.attemptNumber.toString(),
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // Message
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: result.passed
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: result.passed
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    result.passed ? Icons.celebration : Icons.info_outline,
                    color:
                        result.passed ? AppColors.success : AppColors.warning,
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Text(
                      result.passed
                          ? 'أحسنت! لقد اجتزت الامتحان بنجاح. يمكنك الآن الحصول على الشهادة.'
                          : 'لم تحصل على درجة النجاح. يمكنك إعادة المحاولة مرة أخرى.',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: result.passed
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xxxl),

            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.lg,
                  ),
                ),
                child: const Text('العودة للرئيسية'),
              ),
            ),

            if (!result.passed) ...[
              const SizedBox(height: AppSizes.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.lg,
                    ),
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: AppSizes.sm),
        Text(
          value,
          style: AppTextStyles.headlineSmall(context).copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
