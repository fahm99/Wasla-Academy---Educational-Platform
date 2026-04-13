import 'package:flutter/material.dart';
import 'package:waslaacademy/core/constants/app_colors.dart';
import 'package:waslaacademy/core/constants/app_sizes.dart';

/// About Screen - Information about the platform
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن المنصة'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
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
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceLarge),
              const Center(
                child: Text(
                  'وصلة أكاديمي',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSizes.spaceMedium),
              Center(
                child: Text(
                  'منصة تعليمية شاملة',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSizes.spaceXXLarge),

              // Mission Section
              _buildSection(
                context,
                icon: Icons.rocket_launch,
                title: 'مهمتنا',
                content:
                    'نهدف إلى توفير أفضل الدورات التدريبية والتعليمية للطلاب والمتعلمين في الوطن العربي. نؤمن بأن التعليم هو مفتاح التقدم والازدهار، ونسعى لجعله في متناول الجميع بغض النظر عن موقعهم الجغرافي أو ظروفهم المعيشية.',
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Vision Section
              _buildSection(
                context,
                icon: Icons.visibility,
                title: 'رؤيتنا',
                content:
                    'أن نكون المنصة التعليمية الرائدة في المنطقة العربية، ونساهم في بناء جيل قادر على مواكبة التطورات التكنولوجية والعلمية، ونحقق التحول الرقمي في مجال التعليم.',
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Values Section
              const Text(
                'قيمنا',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.spaceMedium),
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
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
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
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSizes.spaceMedium),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceLarge),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
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
            size: 24,
          ),
        ),
        const SizedBox(width: AppSizes.spaceMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.spaceXSmall),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
