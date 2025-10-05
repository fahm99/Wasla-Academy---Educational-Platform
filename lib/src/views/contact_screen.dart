import 'package:flutter/material.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/constants/app_sizes.dart';
import 'package:waslaacademy/src/constants/app_text_styles.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: AppSizes.spaceLarge),
              Text(
                'جاري إرسال الرسالة...',
                style: AppTextStyles.bodyLarge(context),
              ),
            ],
          ),
        ),
      );

      // Simulate message sending
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close loading dialog

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تم إرسال الرسالة'),
            content: Text(
              'شكرًا لتواصلك معنا. سنقوم بالرد عليك في أقرب وقت ممكن.',
              style: AppTextStyles.bodyLarge(context),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close contact screen
                },
                child: const Text('موافق'),
              ),
            ],
          ),
        );

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تواصل معنا'),
        backgroundColor: Colors.white,
        elevation: AppSizes.elevationLow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Information
              Text(
                'معلومات التواصل',
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
                    _buildContactInfoItem(
                      context,
                      icon: Icons.email,
                      title: 'البريد الإلكتروني',
                      value: 'info@waslaacademy.com',
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    _buildContactInfoItem(
                      context,
                      icon: Icons.phone,
                      title: 'رقم الهاتف',
                      value: '+966 50 123 4567',
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    _buildContactInfoItem(
                      context,
                      icon: Icons.location_on,
                      title: 'العنوان',
                      value: 'صنعاء، اليمن',
                    ),
                    const SizedBox(height: AppSizes.spaceLarge),
                    _buildContactInfoItem(
                      context,
                      icon: Icons.access_time,
                      title: 'ساعات العمل',
                      value: 'الأحد - الخميس: 8:00 ص - 5:00 م',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceXXLarge),

              // Social Media
              Text(
                'تابعنا على وسائل التواصل',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialMediaButton(
                      Icons.facebook,
                      AppColors.primary,
                      () {
                        // Handle Facebook tap
                      },
                    ),
                    _buildSocialMediaButton(
                      Icons.chat,
                      Colors.green,
                      () {
                        // Handle WhatsApp tap
                      },
                    ),
                    _buildSocialMediaButton(
                      Icons.link,
                      Colors.blue,
                      () {
                        // Handle LinkedIn tap
                      },
                    ),
                    _buildSocialMediaButton(
                      Icons.telegram,
                      Colors.blueAccent,
                      () {
                        // Handle Telegram tap
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceXXLarge),

              // Contact Form
              Text(
                'أرسل لنا رسالة',
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _nameController,
                        label: 'الاسم',
                        hint: 'أدخل اسمك الكامل',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الاسم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spaceMedium),
                      _buildTextFormField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني',
                        hint: 'أدخل بريدك الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'يرجى إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spaceMedium),
                      _buildTextFormField(
                        controller: _subjectController,
                        label: 'الموضوع',
                        hint: 'أدخل موضوع الرسالة',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الموضوع';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spaceMedium),
                      _buildTextFormField(
                        controller: _messageController,
                        label: 'الرسالة',
                        hint: 'اكتب رسالتك هنا',
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى كتابة الرسالة';
                          }
                          if (value.length < 10) {
                            return 'الرسالة قصيرة جداً';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spaceXXLarge),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _sendMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMedium),
                            ),
                            elevation: AppSizes.elevationLow,
                          ),
                          child: Text(
                            'إرسال الرسالة',
                            style: AppTextStyles.buttonLarge(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
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
                value,
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

  Widget _buildSocialMediaButton(
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium(context),
        ),
        const SizedBox(height: AppSizes.spaceXSmall),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            contentPadding: const EdgeInsets.all(AppSizes.spaceMedium),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }
}
