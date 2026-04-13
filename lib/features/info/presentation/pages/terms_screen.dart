import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الشروط والأحكام',
          style: AppTextStyles.headline2(context).copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الشروط والأحكام',
              style: AppTextStyles.headline1(context),
            ),
            const SizedBox(height: AppSizes.spaceLarge),
            _buildSection(
              context,
              title: '1. قبول الشروط',
              content:
                  'باستخدام منصة وصلة أكاديمي، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على أي من هذه الشروط، يرجى عدم استخدام المنصة.',
            ),
            _buildSection(
              context,
              title: '2. استخدام المنصة',
              content:
                  'يحق لك استخدام المنصة للأغراض التعليمية الشخصية فقط. يُمنع استخدام المحتوى لأغراض تجارية أو إعادة توزيعه دون إذن مكتوب.',
            ),
            _buildSection(
              context,
              title: '3. حساب المستخدم',
              content:
                  'أنت مسؤول عن الحفاظ على سرية معلومات حسابك وكلمة المرور. يجب إخطارنا فوراً بأي استخدام غير مصرح به لحسابك.',
            ),
            _buildSection(
              context,
              title: '4. المحتوى التعليمي',
              content:
                  'جميع المواد التعليمية محمية بحقوق الطبع والنشر. يُمنع نسخ أو توزيع أو تعديل المحتوى دون إذن صريح من المنصة.',
            ),
            _buildSection(
              context,
              title: '5. الدفع والاسترداد',
              content:
                  'جميع المدفوعات نهائية وغير قابلة للاسترداد إلا في حالات استثنائية وفقاً لسياسة الاسترداد الخاصة بنا.',
            ),
            _buildSection(
              context,
              title: '6. الخصوصية',
              content:
                  'نحن ملتزمون بحماية خصوصيتك. يرجى مراجعة سياسة الخصوصية الخاصة بنا لفهم كيفية جمع واستخدام معلوماتك الشخصية.',
            ),
            _buildSection(
              context,
              title: '7. إنهاء الخدمة',
              content:
                  'يحق لنا إنهاء أو تعليق حسابك في أي وقت دون إشعار مسبق في حالة انتهاك هذه الشروط.',
            ),
            _buildSection(
              context,
              title: '8. تحديث الشروط',
              content:
                  'نحتفظ بالحق في تحديث هذه الشروط في أي وقت. سيتم إشعارك بأي تغييرات جوهرية عبر البريد الإلكتروني أو من خلال المنصة.',
            ),
            _buildSection(
              context,
              title: '9. القانون المطبق',
              content:
                  'تخضع هذه الشروط لقوانين المملكة العربية السعودية، وأي نزاع سيتم حله وفقاً للقوانين السعودية.',
            ),
            _buildSection(
              context,
              title: '10. التواصل',
              content:
                  'لأي استفسارات حول هذه الشروط، يرجى التواصل معنا عبر البريد الإلكتروني: legal@waslaacademy.com',
            ),
            const SizedBox(height: AppSizes.spaceXXLarge),
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceLarge),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: AppSizes.iconMedium,
                      ),
                      const SizedBox(width: AppSizes.spaceSmall),
                      Text(
                        'معلومات مهمة',
                        style: AppTextStyles.labelLarge(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceSmall),
                  Text(
                    'آخر تحديث: 1 أكتوبر 2025\nتاريخ السريان: 1 أكتوبر 2025',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceXXLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headline3(context).copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSizes.spaceSmall),
          Text(
            content,
            style: AppTextStyles.bodyLarge(context).copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
