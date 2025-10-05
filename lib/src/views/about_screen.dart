import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن المنصة'),
        backgroundColor: Colors.white,
        elevation: AppSizes.elevationLow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform Logo and Name
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.spaceLarge),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school,
                    size: AppSizes.iconXXXLarge,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceLarge),
              Text(
                'وصلة أكاديمي',
                style: AppTextStyles.headline1(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceMedium),
              Text(
                'منصة تعليمية شاملة',
                style: AppTextStyles.headline3(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceXXLarge),

              // Mission Section
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppSizes.elevationMedium,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spaceSmall),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSmall),
                          ),
                          child: const Icon(
                            Icons.rocket_launch,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceMedium),
                        Text(
                          'مهمتنا',
                          style: AppTextStyles.headline3(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    Text(
                      'نهدف إلى توفير أفضل الدورات التدريبية والتعليمية للطلاب والمتعلمين في الوطن العربي. نؤمن بأن التعليم هو مفتاح التقدم والازدهار، ونسعى لجعله في متناول الجميع بغض النظر عن موقعهم الجغرافي أو ظروفهم المعيشية.',
                      style: AppTextStyles.bodyLarge(context),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceXXLarge),

              // Vision Section
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppSizes.elevationMedium,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSizes.spaceSmall),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSmall),
                          ),
                          child: const Icon(
                            Icons.visibility,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceMedium),
                        Text(
                          'رؤيتنا',
                          style: AppTextStyles.headline3(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    Text(
                      'أن نكون المنصة التعليمية الرائدة في المنطقة العربية، ونساهم في بناء جيل قادر على مواكبة التطورات التكنولوجية والعلمية، ونحقق التحول الرقمي في مجال التعليم.',
                      style: AppTextStyles.bodyLarge(context),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceXXLarge),

              // Values Section
              Text(
                'قيمنا',
                style: AppTextStyles.headline2(context),
              ),
              const SizedBox(height: AppSizes.spaceMedium),
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppSizes.elevationMedium,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildValueItem(
                      context,
                      icon: Icons.star,
                      title: 'الجودة',
                      description:
                          'نلتزم بتقديم محتوى تعليمي عالي الجودة من قبل خبراء في مجالاتهم.',
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    _buildValueItem(
                      context,
                      icon: Icons.accessibility,
                      title: 'الشمولية',
                      description:
                          'نؤمن بأن التعليم يجب أن يكون في متناول الجميع، ونسعى لتقديم حلول تعليمية تناسب جميع الفئات.',
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    _buildValueItem(
                      context,
                      icon: Icons.auto_awesome,
                      title: 'الابتكار',
                      description:
                          'نستخدم أحدث التقنيات وأفضل الممارسات لتقديم تجربة تعليمية متميزة.',
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    _buildValueItem(
                      context,
                      icon: Icons.handshake,
                      title: 'الشراكة',
                      description:
                          'نتعاون مع أفضل الجامعات والمؤسسات التعليمية لتقديم محتوى موثوق ومتميز.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceXXLarge),

              // Team Section
              Text(
                'فريق العمل',
                style: AppTextStyles.headline2(context),
              ),
              const SizedBox(height: AppSizes.spaceMedium),
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppSizes.elevationMedium,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'فريق وصلة أكاديمي يتكون من مجموعة من الخبراء في مجالات التعليم والتكنولوجيا، ويسعى جاهداً لتقديم أفضل الحلول التعليمية للطلاب والمتعلمين في الوطن العربي.',
                      style: AppTextStyles.bodyLarge(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeamMember(
                          'محمد أحمد',
                          'المؤسس والرئيس التنفيذي',
                        ),
                        _buildTeamMember(
                          'سارة عبدالله',
                          'مدير المحتوى التعليمي',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeamMember(
                          'خالد علي',
                          'مدير التقنية',
                        ),
                        _buildTeamMember(
                          'فاطمة حسن',
                          'مدير التسويق',
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

  Widget _buildValueItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                description,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember(String name, String position) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.light,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSizes.spaceSmall),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          position,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
