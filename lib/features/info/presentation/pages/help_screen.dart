import 'package:flutter/material.dart';
import 'package:waslaacademy/core/constants/app_colors.dart';
import 'package:waslaacademy/core/constants/app_sizes.dart';

/// Help Screen - FAQ and support information
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعدة والدعم'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: AppSizes.elevationLow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Information
            const Text(
              'تواصل معنا',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            _buildContactItem(
              context,
              icon: Icons.email,
              title: 'البريد الإلكتروني',
              subtitle: 'support@waslaacademy.com',
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            _buildContactItem(
              context,
              icon: Icons.phone,
              title: 'الهاتف',
              subtitle: '+966 50 123 4567',
            ),
            const SizedBox(height: AppSizes.spaceSmall),
            _buildContactItem(
              context,
              icon: Icons.schedule,
              title: 'ساعات العمل',
              subtitle: 'الأحد - الخميس: 9:00 ص - 6:00 م',
            ),

            const SizedBox(height: AppSizes.spaceXXLarge),

            // FAQ Section
            const Text(
              'الأسئلة الشائعة',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            _buildFAQItem(
              context,
              question: 'كيف يمكنني التسجيل في كورس؟',
              answer:
                  'يمكنك التسجيل في أي كورس من خلال الضغط على زر "التسجيل" في صفحة تفاصيل الكورس. إذا كان الكورس مدفوعاً، ستحتاج إلى إكمال عملية الدفع أولاً.',
            ),
            _buildFAQItem(
              context,
              question: 'هل يمكنني الحصول على شهادة؟',
              answer:
                  'نعم، ستحصل على شهادة إتمام معتمدة بعد إنهاء الكورس بنجاح واجتياز جميع الامتحانات المطلوبة.',
            ),
            _buildFAQItem(
              context,
              question: 'كيف يمكنني تتبع تقدمي؟',
              answer:
                  'يمكنك متابعة تقدمك من خلال قسم "كورساتي" في التطبيق. ستجد نسبة الإنجاز لكل كورس والدروس المكتملة.',
            ),
            _buildFAQItem(
              context,
              question: 'ماذا أفعل إذا نسيت كلمة المرور؟',
              answer:
                  'يمكنك استعادة كلمة المرور من خلال الضغط على "نسيت كلمة المرور" في صفحة تسجيل الدخول. سنرسل لك رابط استعادة كلمة المرور عبر البريد الإلكتروني.',
            ),
            _buildFAQItem(
              context,
              question: 'كيف يمكنني الدفع مقابل الكورسات؟',
              answer:
                  'نوفر عدة طرق للدفع حسب الجهة المقدمة للكورس. يمكنك الدفع عن طريق التحويل البنكي أو الدفع الإلكتروني. ستجد التفاصيل في صفحة الدفع.',
            ),
            _buildFAQItem(
              context,
              question: 'هل يمكنني إعادة الامتحان؟',
              answer:
                  'نعم، يمكنك إعادة الامتحان حسب سياسة الكورس. بعض الكورسات تسمح بعدد محدود من المحاولات.',
            ),

            const SizedBox(height: AppSizes.spaceXXLarge),

            // Technical Support
            const Text(
              'الدعم التقني',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.spaceMedium),
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceLarge),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(
                  color: AppColors.info.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: AppSizes.spaceSmall),
                      Text(
                        'هل تحتاج مساعدة؟',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Text(
                    'إذا واجهت أي مشاكل تقنية أو كان لديك أي استفسار، يرجى التواصل معنا عبر البريد الإلكتروني أو الهاتف المذكور أعلاه. فريق الدعم متاح لمساعدتك.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: AppColors.light),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: AppSizes.spaceSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.light),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceLarge),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
