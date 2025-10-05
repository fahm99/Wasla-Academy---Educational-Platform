import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/constants/app_colors.dart';
import 'package:waslaacademy/src/widgets/custom_app_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitResetRequest() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال بريدك الإلكتروني'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    // Validate email format
    if (!_isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال بريد إلكتروني صحيح'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    // In a real app, this would send a reset password request to the server
    setState(() {
      _isSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'نسيت كلمة المرور',
        onBack: () => Navigator.pop(context),
        showAuthIcons: false, // Hide auth icons on forgot password screen
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نسيت كلمة المرور',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'أدخل بريدك الإلكتروني لإرسال رابط إعادة تعيين كلمة المرور',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32.h),
            if (_isSubmitted) ...[
              // Success message
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 80.sp,
                      color: AppColors.success,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'تم إرسال الرابط بنجاح!',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'يرجى التحقق من بريدك الإلكتروني واتباع التعليمات لإعادة تعيين كلمة المرور الخاصة بك.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Email input
              Text(
                'البريد الإلكتروني',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'أدخل بريدك الإلكتروني',
                  border: const OutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 14.sp),
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 32.h),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitResetRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'إرسال الرابط',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
