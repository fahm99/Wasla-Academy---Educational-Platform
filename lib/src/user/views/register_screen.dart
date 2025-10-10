import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waslaacademy/src/user/constants/app_colors.dart';
import 'package:waslaacademy/src/user/views/terms_screen.dart';
import 'package:waslaacademy/src/user/views/verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterSuccess;

  const RegisterScreen({
    super.key,
    required this.onLoginTap,
    required this.onRegisterSuccess,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;
  // New variable to track registration type
  bool _isStudentRegistration = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    // If registering as educational institution, show coming soon message
    if (!_isStudentRegistration) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('سيتم تطوير التطبيق قريباً'),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate() && _agreedToTerms) {
      setState(() {
        _isLoading = true;
      });

      // الانتقال إلى شاشة التحقق بدلاً من التسجيل المباشر
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            email: _emailController.text,
            name: _nameController.text,
            phone: _phoneController.text,
            password: _passwordController.text,
          ),
        ),
      ).then((_) {
        // إعادة تعيين حالة التحميل عند العودة
        setState(() {
          _isLoading = false;
        });
      });
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء الموافقة على الشروط والأحكام'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w), // Reduced from 20.w
        child: Column(
          children: [
                            SizedBox(height: 20.h), // Reduced from 20.h

            // App logo - Reduced size
            Container(
              width: 72.w, // Reduced from 96.w
              height: 72.w, // Reduced from 96.w
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 36.w, // Reduced from 48.w
                height: 36.w, // Reduced from 48.w
              ),
            ),
            SizedBox(height: 16.h), // Reduced from 20.h
            Text(
              'إنشاء حساب جديد',
              style: TextStyle(
                fontSize: 20.sp, // Reduced from 24.sp
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: 6.h), // Reduced from 8.h
            Text(
              'انضم إلى منصتنا التعليمية',
              style: TextStyle(
                fontSize: 14.sp, // Reduced from 16.sp
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.h), // Reduced from 20.h
            // Registration type toggle - Reduced padding
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r), // Reduced from 16.r
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16, // Reduced from 20
                    offset: const Offset(0, 2), // Reduced from (0, 4)
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.w), // Reduced from original
              child: Column(
                children: [
                  Text(
                    'نوع الحساب',
                    style: TextStyle(
                      fontSize: 16.sp, // Reduced from 18.sp
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  SizedBox(height: 12.h), // Reduced from 16.h
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isStudentRegistration = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isStudentRegistration
                                ? AppColors.primary
                                : Colors.white,
                            foregroundColor: _isStudentRegistration
                                ? Colors.white
                                : AppColors.primary,
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 1.w,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h), // Reduced from 16.h
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6.r), // Reduced from 8.r
                            ),
                          ),
                          child: Text(
                            'طالب',
                            style: TextStyle(
                              fontSize: 14.sp, // Reduced from 16.sp
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w), // Reduced from 16.w
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isStudentRegistration = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !_isStudentRegistration
                                ? AppColors.primary
                                : Colors.white,
                            foregroundColor: !_isStudentRegistration
                                ? Colors.white
                                : AppColors.primary,
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 1.w,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h), // Reduced from 16.h
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6.r), // Reduced from 8.r
                            ),
                          ),
                          child: Text(
                            'جهة تعليمية',
                            style: TextStyle(
                              fontSize: 14.sp, // Reduced from 16.sp
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h), // Reduced from 20.h
            // Register form - Reduced padding
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r), // Reduced from 16.r
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16, // Reduced from 20
                    offset: const Offset(0, 2), // Reduced from (0, 4)
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.w), // Reduced from 30.w
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name field
                    _buildTextFormField(
                      controller: _nameController,
                      label: 'الاسم الكامل',
                      hint: 'أدخل اسمك الكامل',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم الكامل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h), // Reduced from 20.h
                    // Email field
                    _buildTextFormField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      hint: 'أدخل بريدك الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h), // Reduced from 20.h
                    // Phone field
                    _buildTextFormField(
                      controller: _phoneController,
                      label: 'رقم الهاتف (اختياري)',
                      hint: 'أدخل رقم هاتفك',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h), // Reduced from 20.h
                    // Password field
                    _buildTextFormField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      hint: 'أدخل كلمة المرور',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h), // Reduced from 20.h
                    // Confirm password field
                    _buildTextFormField(
                      controller: _confirmPasswordController,
                      label: 'تأكيد كلمة المرور',
                      hint: 'أعد إدخال كلمة المرور',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء تأكيد كلمة المرور';
                        }
                        if (value != _passwordController.text) {
                          return 'كلمتا المرور غير متطابقتين';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h), // Reduced from 20.h
                    // Terms and conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'أوافق على ',
                          style: TextStyle(
                            fontSize: 12.sp, // Reduced from 14.sp
                            color: AppColors.dark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TermsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'الشروط والأحكام',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp, // Reduced from 14.sp
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h), // Reduced from 20.h
                    // Register button - Reduced padding
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h), // Reduced from 16.h
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6.r), // Reduced from 8.r
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                  fontSize: 14.sp, // Reduced from 16.sp
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h), // Reduced from 30.h
            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'لديك حساب بالفعل؟',
                  style: TextStyle(
                    fontSize: 12.sp, // Reduced from 14.sp
                    color: Colors.grey[600],
                  ),
                ),
                TextButton(
                  onPressed: widget.onLoginTap,
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp, // Reduced from 14.sp
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp, // Reduced from 16.sp
            color: AppColors.dark,
          ),
        ),
        SizedBox(height: 6.h), // Reduced from 8.h
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14.sp, // Reduced from 16.sp
              color: Colors.grey[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r), // Reduced from 8.r
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r), // Reduced from 8.r
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r), // Reduced from 8.r
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.w,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w, // Reduced from 16.w
              vertical: 10.h, // Reduced from 12.h
            ),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(
            fontSize: 14.sp, // Reduced from 16.sp
            color: AppColors.dark,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
