import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المساعدة والدعم',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Information
            _buildSection(
              context,
              title: 'تواصل معنا',
              icon: Icons.contact_support,
              children: [
                _buildContactItem(
                  context,
                  icon: Icons.email,
                  title: 'البريد الإلكتروني',
                  subtitle: 'support@waslaacademy.com',
                ),
                _buildContactItem(
                  context,
                  icon: Icons.phone,
                  title: 'الهاتف',
                  subtitle: '+966 50 123 4567',
                ),
                _buildContactItem(
                  context,
                  icon: Icons.schedule,
                  title: 'ساعات العمل',
                  subtitle: 'الأحد - الخميس: 9:00 ص - 6:00 م',
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spaceXLarge),

            // FAQ Section
            _buildSection(
              context,
              title: 'الأسئلة الشائعة',
              icon: Icons.help_outline,
              children: [
                _buildFAQItem(
                  context,
                  question: 'كيف يمكنني التسجيل في كورس؟',
                  answer:
                      'يمكنك التسجيل في أي كورس من خلال الضغط على زر "التسجيل" في صفحة تفاصيل الكورس.',
                ),
                _buildFAQItem(
                  context,
                  question: 'هل يمكنني الحصول على شهادة؟',
                  answer:
                      'نعم، ستحصل على شهادة إتمام معتمدة بعد إنهاء الكورس بنجاح.',
                ),
                _buildFAQItem(
                  context,
                  question: 'كيف يمكنني تتبع تقدمي؟',
                  answer:
                      'يمكنك متابعة تقدمك من خلال قسم "كورساتي" في التطبيق.',
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spaceXLarge),

            // Technical Support
            _buildSection(
              context,
              title: 'الدعم التقني',
              icon: Icons.build,
              children: [
                Text(
                  'إذا واجهت أي مشاكل تقنية، يرجى التواصل معنا عبر البريد الإلكتروني أو الهاتف المذكور أعلاه.',
                  style: AppTextStyles.bodyLarge(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: AppSizes.iconMedium,
            ),
            const SizedBox(width: AppSizes.spaceSmall),
            Text(
              title,
              style: AppTextStyles.headline2(context),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceLarge),
        ...children,
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spaceSmall),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppSizes.iconMedium,
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
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTextStyles.labelLarge(context),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceLarge),
            child: Text(
              answer,
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
