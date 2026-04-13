import 'package:flutter/material.dart';
import 'package:waslaacademy/core/constants/app_colors.dart';
import 'package:waslaacademy/core/constants/app_sizes.dart';

/// Email Verification Screen
///
/// Note: Supabase handles email verification automatically.
/// This screen informs the user to check their email and verify.
/// After verification, they can sign in.
class VerificationScreen extends StatelessWidget {
  final String email;

  const VerificationScreen({
    super.key,
    required this.email,
  });

  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _resendVerification(BuildContext context) {
    // In production, call Supabase resend verification email API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إرسال رابط التحقق مرة أخرى إلى $email'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من البريد الإلكتروني'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spaceXXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Title
              const Text(
                'تحقق من بريدك الإلكتروني',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spaceLarge),

              // Description
              Text(
                'لقد أرسلنا رابط التحقق إلى',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spaceSmall),

              Text(
                email,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spaceXLarge),

              // Instructions
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceLarge),
                decoration: BoxDecoration(
                  color: AppColors.light,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Column(
                  children: [
                    _buildInstructionItem(
                      '1',
                      'افتح بريدك الإلكتروني',
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    _buildInstructionItem(
                      '2',
                      'ابحث عن رسالة من وصلة أكاديمي',
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    _buildInstructionItem(
                      '3',
                      'اضغط على رابط التحقق',
                    ),
                    const SizedBox(height: AppSizes.spaceMedium),
                    _buildInstructionItem(
                      '4',
                      'ارجع للتطبيق وسجل الدخول',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spaceXXLarge),

              // Go to Login Button
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => _goToLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                  ),
                  child: const Text(
                    'الذهاب لتسجيل الدخول',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.spaceMedium),

              // Resend Link
              TextButton(
                onPressed: () => _resendVerification(context),
                child: const Text(
                  'إعادة إرسال رابط التحقق',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.spaceXLarge),

              // Note
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceMedium),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.spaceSmall),
                    Expanded(
                      child: Text(
                        'تحقق من مجلد الرسائل غير المرغوب فيها (Spam) إذا لم تجد الرسالة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
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

  Widget _buildInstructionItem(String number, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceMedium),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
